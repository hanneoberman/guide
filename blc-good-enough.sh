#!/bin/bash
# usage, e.g. if you find 10 an acceptable number of broken links
# bash blc-good-enough 10

# get the maximum allowed number of broken links
broken_max="$1"

# run the link checker
node_modules/.bin/blc --recursive --ordered http://localhost:4000 2>/dev/null | tee stdout.txt

# get the actual number of broken links
broken=$(cat stdout.txt | tail -n 2 | head -n 1 | grep --word-regexp --only-matching --extended-regexp --regexp='[0-9]{1,}' | tail -n 1)

echo
echo "-------------------------------------------------------------------------------------------"
echo "--                                     SUMMARY                                           --"
echo "-------------------------------------------------------------------------------------------"
echo
cat stdout.txt | grep --only-matching --extended-regexp --regexp='^(Getting links from.*)|(.*BROKEN.*)'

if [ "$broken" -gt "$broken_max" ]; then
    echo "Number of broken links (${broken}) exceeds maximum allowed number (${broken_max})." >&2
    exit 1
else
    echo "Number of broken links (${broken}) less than or equal to maximum allowed number (${broken_max})."
    exit 0
fi

