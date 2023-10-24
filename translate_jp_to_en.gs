// Google Sheet's App Scripts

// translates the active sheet in the associated spreadsheet from Japanese to English
function translateSpreadsheet() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet();
  var translatedSheet = sheet.duplicateActiveSheet();
  translatedSheet.setName( "translated_" + translatedSheet.getName());
  var range = translatedSheet.getDataRange();
  range.clearDataValidations();
  var values = range.getValues();

  for (var i = 0; i < values.length; i++) {
    for (var j = 0; j < values[i].length; j++) {
      if (values[i][j] != "") {
        try {
          values[i][j] = '=GOOGLETRANSLATE("' + values[i][j] + '", "ja", "en")';
        }
        catch (e) {
          Logger.log('Error: ' + e.toString());
        }
      }
    }
  }

  range.setFormulas(values);
}
