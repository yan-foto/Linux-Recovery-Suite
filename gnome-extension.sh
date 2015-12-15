#!/bin/bash

: '
The MIT License (MIT)

Copyright (c) 2015 Yan Foto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'

# Find and sort installed extensions
home_exts=~/.local/share/gnome-shell/extensions
sys_exts=/usr/share/gnome-shell/extensions
extensions=$({ test "$home_exts" && ls -1 "$home_exts"; \
               test "$sys_exts" && ls -1 "$sys_exts"; })
# Is it sorted? Let me sort it!
extensions=$(echo "$extensions" | sort)

function store {
  exec_dir=$(pwd)
  dest_dir="$exec_dir/backup"
  echo "Saving backup file in $dest_dir"
  mkdir -p "$dest_dir"

  dest_file="$dest_dir/extensions.txt"
  echo "$extensions" > "$dest_file"
  count=$(wc -l < "$dest_file")
  echo "Total number of $count extension were found"

  exit 0
}

function restore {
  # To be implemented
  echo "Restoring"
}

function different {
  target=$(<"$1")
  difference=$(comm -23 <(echo "$target") <(echo "$extensions"))
  if [ "$difference" ]
  then
    diff_count=$(wc -l <(echo "$difference"))
    echo -e "Following extensions are not installed:\n$difference"
  else
    echo "All extensions in given file are installed!"
  fi

  exit 0
}

function show_help {
  echo "Usage: [-s] [-r backup-file] [-d backup-file]"
}

while getopts ":srd:" opt
do
  case $opt in
    s)
      store
      ;;
    r)
      restore $OPTARG
      ;;
    d)
      different $OPTARG
      ;;
    :)
      echo "Option '$OPTARG' requires an argument."
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ $# -eq 0 ]
then
  show_help
fi
