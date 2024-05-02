# Request a credentials.json file in the same folder that has GCP OAuth2.0 creds for the same org
# Pass in args for either a drive_id or folder_id

import pickle
import os.path
import sys
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from argparse import ArgumentParser
from ratelimit import limits, sleep_and_retry

# Define the rate limit: 10,000 requests per minute
CALLS = 10000
PERIOD = 60

# If modifying these scopes, delete the file token.pickle.
SCOPES = ["https://www.googleapis.com/auth/drive"]


@sleep_and_retry
@limits(calls=CALLS, period=PERIOD)
def list_files_recursive(service, folder_id="root", drive_id=None, folder_name=""):
    # Fetch and print the current folder's name if not provided (and not 'root')
    if not folder_name and folder_id != "root":
        folder_metadata = (
            service.files()
            .get(fileId=folder_id, supportsAllDrives=True, fields="name")
            .execute()
        )
        folder_name = folder_metadata.get("name")

    print(f"Checking folder: {folder_name} (ID: {folder_id})")
    query = f"'{folder_id}' in parents and trashed = false"
    params = {
        "q": query,
        "pageSize": 100,
        "fields": "nextPageToken, files(id, name, mimeType, parents)",
        "supportsAllDrives": True,
        "includeItemsFromAllDrives": True,
    }
    if drive_id:
        params["driveId"] = drive_id
        params["corpora"] = "drive"

    results = []
    page_token = None
    while True:
        if page_token:
            params["pageToken"] = page_token
        response = service.files().list(**params).execute()
        results.extend(response.get("files", []))
        page_token = response.get("nextPageToken", None)
        if not page_token:
            break

    count = 0
    for item in results:
        count += 1
        if item["mimeType"] == "application/vnd.google-apps.folder":
            count += list_files_recursive(service, item["id"], drive_id, item["name"])
    return count


def main(drive_id, folder_id):
    creds = None
    if os.path.exists("token.pickle"):
        with open("token.pickle", "rb") as token:
            creds = pickle.load(token)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
            creds = flow.run_local_server(port=0)
        with open("token.pickle", "wb") as token:
            pickle.dump(creds, token)

    service = build("drive", "v3", credentials=creds)

    total_count = list_files_recursive(service, folder_id, drive_id)
    print(f"Total number of items in the folder (including subfolders): {total_count}")


if __name__ == "__main__":
    parser = ArgumentParser(description="Google Drive Folder Analysis Tool")
    parser.add_argument(
        "--drive_id",
        help="The ID of the Google Drive (for Shared Drives).",
        default=None,
    )
    parser.add_argument(
        "--folder_id",
        help="The ID of the folder to start analysis from.",
        default="root",
    )
    args = parser.parse_args()

    main(args.drive_id, args.folder_id)
