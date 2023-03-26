#!/bin/bash

# lists the created and last updated time for each file in a provided pattern, e.g. "*.md"
if [ -z "$1" ]; then
    echo 'Please specify a file pattern inside quotes, e.g. ''*.md'''    
    # quotes are necessary or zsh expands the glob into multiple args (try with echo *.md)
    exit 1
fi

declare FILES=`find . -name "$1"`
declare FILE

let X=0
for FILE in $FILES; do 
    let X++
    # skip node_modules in the path
    echo "$FILE" | grep 'node_modules' >/dev/null
    if [[ "$?" != "0" ]]; then
        declare HISTORY=`git log --pretty=tformat:'%cI' -- "$FILE"`
        declare UPDATED=`echo "$HISTORY" | head -1`
        declare CREATED=`echo "$HISTORY" | tail -1`
        echo "$FILE", "$CREATED", "$UPDATED"
    fi
done
echo "$X" Files Processed.