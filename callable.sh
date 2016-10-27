#!/bin/bash

# fileio(1)
#
# NAME
#           fileio - Upload file(s) to https://file.io
#
# SYNOPSIS
#           fileio file             upload single file & copy link to clipboard
#           fileio file1 file2      upload multiple files
#           fileio:history          output history

FileIO__callable_main () {
  if [[ $@ == "" ]]; then
    Logger__alert "No file passed"
    exit
  fi

  for param in $@; do
    output=$(curl --silent -F "file=@$param" https://file.io)
    if [[ $output =~ (\"success\"\:)(true|false) ]]; then
      if [[ ${BASH_REMATCH[2]} == true ]]; then
        if [[ $output =~ (\"link\"\:\")(.*)\", ]]; then
          url="${BASH_REMATCH[2]}"
          echo "$(date) [$url] $1" >> "$Ash__ACTIVE_MODULE_DIRECTORY/extras/history.txt"
          echo "Uploaded: [$url] $param"
          if [[ $# == 1 ]]; then
            echo $url | pbcopy
            echo "Copied to clipboard."
          fi
        else
          Logger__alert "Unable to decode response: $output"
          exit
        fi
      else
          Logger__alert "Failed to upload"
          if [[ $output =~ (\"error\"\:)(.*)(,) ]]; then # next char (,)
            Logger__alert "Error: ${BASH_REMATCH[2]}"
          elif [[ $output =~ (\"error\"\:)(.*)(}) ]]; then # next char (})
              Logger__alert "Error: ${BASH_REMATCH[2]}"
          fi
          if [[ $output =~ (\"message\"\:)(\")(.*)\" ]]; then
            Logger__alert "Message: ${BASH_REMATCH[3]}"
          fi
          exit
      fi
    fi
  done
}

FileIO__callable_help () {
  more "$Ash__ACTIVE_MODULE_DIRECTORY/help.txt"
}

FileIO__callable_history () {
  cat "$Ash__ACTIVE_MODULE_DIRECTORY/extras/history.txt"
}
