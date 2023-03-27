#!/bin/bash
echo 'This script will update all markdown files in the current folder and below with front-matter'
echo -n 'Continue? (Y/n) '
read RESP
[[ "$RESP" != 'y' ]] && echo 'Canceled' && exit 1

declare FILES=`find . -name '*.md'`

for FILE in $FILES; do
    echo "$FILE"
    declare HISTORY=`git log --pretty=tformat:'%cI' -- "$FILE"`
    declare UPDATED=`echo "$HISTORY" | head -1`
    declare CREATED=`echo "$HISTORY" | tail -1`
    declare YEAR=`echo "$CREATED" | cut -d '-' -f 1`
    declare TITLE=`basename "$FILE"`
    cat << EOFKEY > TMP.TXT
---
author: Levent Oz
title: $TITLE
# description:
draft: true
tag:
year: $YEAR
created: "$CREATED"
updated: "$UPDATED"
---
EOFKEY
    cat TMP.TXT "$FILE" > "$FILE.TMP"
    mv "$FILE.TMP" "$FILE"
    rm TMP.TXT
done


## Notes an additional tasks

## Once files have been updated, assuming they are in a git-controlled repo, you can do something like the following, assuming directories already exist
# for x in `git status --short | cut -d ' ' -f 3`; do cp "$x" "/new/path/$x"; done

## If you want to organize based on year, you can do something like the following, in each folder that has files with front-matter:
# for FILE in `ls -1`; do YEAR=`grep "$FILE" -e 'year: 20' | cut -d ' ' -f 2`; mv "$FILE" "/new/path/$YEAR"; done

