#!/bin/bash

#hist_filename=~/.bash_history
bm_filename=~/.command_bookmarks
#HISTFILE=$hist_filename
#set -o history

if [[ "$1" = "-a" ]]; then
  # "Add" option
  #last_command=`history | tail -n 2 | head -n 1 | sed -e 's/ \{1,\}[0-9]\{1,\} \{1,\}//'`
  if [ -n "$2" ]; then
    echo "${@:2}" >> $bm_filename
    echo "Added a new command bookmark."
  else
    echo "No bookmark command specified."
    exit 1
  fi
elif [[ "$1" = "-l" ]]; then
  # "List" option
  line_num=1
  cat $bm_filename | while read line
  do
    echo $line_num: $line
    line_num=$(($line_num + 1))
  done
elif [[ "$1" = "-m" ]]; then
  # "Modify" option
  vi $bm_filename
elif [[ "$1" = "-D" ]]; then
  # "Delete" option
  if [[ ! "$2" =~ ^[0-9]+$ ]]; then
    echo "Invalid command number specified."
    exit 1
  fi
  sed -i -e "${2},${2}d" ~/.command_bookmarks
elif [[ "$1" =~ ^[0-9]+$ ]]; then
  # "Run specified command" option
  exec_command=`sed -n ${1}p $bm_filename`
#echo $exec_command
  eval $exec_command
else
  echo "Invalid option specified."
  exit 1
fi
