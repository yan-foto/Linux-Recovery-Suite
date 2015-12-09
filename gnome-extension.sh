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

function store {
  exec_dir=$(pwd)
  dest_dir="$exec_dir/backup"
  echo "Saving backup file in $dest_dir"

  dest_file="$dest_dir/extensions.txt"
  ext_dirs_prefix=("$HOME/.local" "/usr")
  for prefix in "${ext_dirs_prefix[@]}"
  do
    path="${prefix}/share/gnome-shell/extensions"
    test -d $path && ls -1 $path >> $dest_file \
      || echo "'$path' does not exist!"
  done
  count=$(wc -l < $dest_file)
  echo "Total number of $count extension were found"

  exit 0
}

function restore {
  # To be implemented
  echo "Restoring"
}

function show_help {
  echo "Usage: [-s] [-r backup-file]"
}

while getopts ":sr:" opt
do
  case $opt in
    s)
      store
      ;;
    r)
      restore $OPTARG
      ;;
    :)
      echo "Option '$OPTARG' requires an argument."
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [$# -eq 0]
then
  show_help
fi
