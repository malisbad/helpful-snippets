# Paginate will paginate the contents any file in a zsh shell
# Usage: paginate [file] [lines_per_page]
# Example: paginate my_text_file.txt 10

paginate() {
  local file=$1
  local lines_per_page=$2
  local total_lines=$(wc -l < $file)
  local total_pages=$(( (total_lines + lines_per_page - 1) / lines_per_page ))

  for ((page=1; page<=total_pages; page++))
  do
    echo "Page $page/$total_pages:"
    awk "NR > (($page-1) * $lines_per_page) && NR <= ($page * $lines_per_page)" $file
    if ((page < total_pages)); then
      read -k1 -s "?Press any key to continue or q to quit"
      if [[ $REPLY == "q" ]]; then
        break
      fi
      echo
    fi
  done
}
