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
#
#    FLAGS
#           -e, --expires 'time'  (default: 2 weeks) positive integer followed by
#                                     w (week), m (month) or y (year)
#
# EXAMPLES
#           ash fileio --expires 1w help.txt license.md
#           ash fileio help.txt license.md -e 1w
#           ash fileio --expires 1w help.txt license.md -e 1y readme.md
#
# NOTES
#           The expires/e flag is able to be added after or before the files.
#           Which ever you pattern you choose you must be consitant with.

FileIO__callable_main () {
  Logger__set_prefix "file.io"
  if [[ $@ == "" ]]; then
    Logger__alert "No file passed"
    return
  fi

  # hacky way to create an array of all params, including short flags
  local str="$(echo "$@" | awk '{ for (i=1; i <= NF; i++) { print $i } }')"
  local arr
  local counter=0
  for i in $str; do
    arr[$counter]="$i"
    counter=$(($counter+1))
  done

  local pos=$(( ${#arr[*]} - 1 ))
  local last=${arr[$pos]}
  local flagFound="false" # identifies the start or end of the list
  local firstPass="true"
  local filesAfter="false"
  local files=""
  local fileSets=()
  local fSetIndex=""
  local setIndex=""
  local prevTime=""
  for param in "${arr[@]}"; do
    if [[ "${param}" == "-e" ]] || [[ "${param}" == "--expires" ]]; then
      if [[ "$firstPass" == "true" ]]; then
        filesAfter="true"
      fi
      flagFound="true"
      continue
    elif [[ -f "$param" ]]; then
      if [[ $files == "" ]]; then
        files+="$param" # start of set
      else
        files+=":$param"
      fi
    elif [[ ! "$param" =~ \d*([wmy]) ]]; then
      Logger__error "Unknown parameter $param"
      return
    fi

    if [[ "$flagFound" == "true" ]]; then
      if [[ "$filesAfter" != "true" ]]; then
        # add to set
        time="$param"

        # push current fileSet to fileSetArray
        fSetIndex="${#fileSets[@]}"
        setIndex=$(($fSetIndex + 1))
        fileSets[$setIndex]="$time|$files"

        # reset variables
        time=""
        files=""
      elif [[ "$firstPass" != "true" ]]; then
        # push current fileSet to fileSetArray
        fSetIndex="${#fileSets[@]}"
        setIndex=$(($fSetIndex + 1))
        fileSets[$setIndex]="$prevTime|$files"

        # reset variables
        time=""
        files=""
      fi

      prevTime="$param"
      flagFound="false"
      continue
    elif [[ "$last" == "$param" ]]; then
      # push current fileSet to fileSetArray
      fSetIndex="${#fileSets[@]}"
      setIndex=$(($fSetIndex + 1))
      fileSets[$setIndex]="$prevTime|$files"
    fi

    firstPass="false"
  done

  pos=$(( ${#fileSets[*]} - 1 ))
  last=${fileSets[$pos]}
  for fileSet in ${fileSets[@]}; do
    if [[ "$fileSet" =~ (.*)\|(.*) ]]; then
      local expiry="${BASH_REMATCH[1]}"
      local expiryQuery=""
      local files="${BASH_REMATCH[2]}"
      files=(${files//:/ })
      if [[ "$expiry" != "" ]]; then
        expiryQuery="/?expires=$expiry"
      fi

      local posFiles=$(( ${#files[*]} - 1 ))
      local lastFile=${files[$posFiles]}
      for file in $files; do
        local url="https://file.io"
        local output=$(curl --silent -F "file=@$file" "$url$expiryQuery")
        if [[ $output =~ (\"success\"\:)(true|false) ]]; then
          if [[ ${BASH_REMATCH[2]} == true ]]; then
            if [[ $output =~ (\"link\"\:\")(.*)\", ]]; then
              url="${BASH_REMATCH[2]}"
              if [[ "$expiry" == "" ]]; then
                expiry="2w"
              fi
              echo "$(date) ($expiry) [$url] $file" >> "$Ash__ACTIVE_MODULE_DIRECTORY/extras/history.txt"
              Logger__success "Uploaded: [$url] $file"
              if [[ "${#fileSets[@]}" == 1 ]] && [[ "$file" == "$lastFile" ]]; then
                # Copy to clipboard
                echo $url | pbcopy
                Logger__success "Copied to clipboard."
              fi
            else
              Logger__alert "Unable to decode response: $output"
              return
            fi
          else
            Logger__alert "Failed to upload"
            if [[ $output =~ (\"error\"\:)(.*), ]]; then # error code
              local errorMsg="Error: (${BASH_REMATCH[2]})"
              if [[ $output =~ (\"message\":)(\")(.*)\" ]]; then
                errorMsg+=" ${BASH_REMATCH[3]}"
              fi
              Logger__alert "$errorMsg"
            elif [[ $output =~ (\"message\"\:)(\")(.*)\" ]]; then
              Logger__alert "Message: ${BASH_REMATCH[3]}"
            else
              Logger__alert "Unknown Issue: $output"
            fi
            return
          fi
        fi
      done
    fi
  done
}

FileIO__callable_help () {
  more "$Ash__ACTIVE_MODULE_DIRECTORY/help.txt"
}

FileIO__callable_history () {
  cat "$Ash__ACTIVE_MODULE_DIRECTORY/extras/history.txt"
}
