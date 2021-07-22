#!/bin/bash

# set -x 

unset TEMPDIR
trap '[ "$TEMPDIR" ] && rm -rf "$TEMPDIR"' EXIT
TEMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/XXXXXXXXXXXXXXXXXXXXXXXXXXXXX") ||
  { printf 'ERROR creating a temporary file\n' >&2; exit 1; }

echo "Writing output to: ${!#}"

# Extract the header (all files should have the same header
# ToDo: Compare headers from all files, generate error if mismatched
HEADER=$(head -n 1 $1)

# Output all text after the first line of each file,
# Sort the output by artist and title, skipping any duplicate lines
# tail -q -n +2 "$@" | sort -d -u --field-separator=";" --key=2,2 --key=1,1 | sed "1i $HEADER"

tail -q -n +2 "$@" | sort -d -u --field-separator=";" --key=2,2 --key=1,1 | sed "1i $HEADER" > $TEMPDIR/sorted.csv
cat $TEMPDIR/sorted.csv > ${!#}
