#!/bin/bash

# set -x 

# Ensure that at least two arguments are passed to the script
if [ $# -lt 2 ]; then
    echo "Need at least two files to merge!"
    exit 1
fi

unset TEMPDIR
trap '[ "$TEMPDIR" ] && rm -rf "$TEMPDIR"' EXIT
TEMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/XXXXXXXXXXXXXXXXXXXXXXXXXXXXX") ||
  { printf 'ERROR creating a temporary file\n' >&2; exit 1; }

echo "Writing output to: ${!#}"

# Extract the header (all files should have the same header
# ToDo: Compare headers from all files, generate error if mismatched
HEADER=$(head -n 1 $1)

# Write the CSV header out to the temp file, strip out all of the CSV
# data from the input files, sort it and remove duplicates, then write
# it to the temp file.
echo $HEADER > $TEMPDIR/sorted.csv
tail -q -n +2 "$@" | sort -d -u --field-separator=";" --key=2,2 --key=1,1 >> $TEMPDIR/sorted.csv
cat $TEMPDIR/sorted.csv > ${!#}
