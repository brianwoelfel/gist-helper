#!/bin/bash

DESCRIPTION=$1
FILENAME=$2
public="true"
TEMPFILE=$(mktemp)

desc=$(echo "$DESCRIPTION" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
json=$(cat $FILENAME | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

curl --silent -v -H "Content-Type: text/json; charset=utf-8" \
        -H "Authorization: Token $GIT_TOKEN" \
        -X POST https://api.github.com/gists -d @- << EOF | tee $TEMPFILE
{ 
  "description": "$desc", 
  "public": "$public", 
  "files": { 
      "$FILENAME" : { 
          "content": "$json"
       } 
   } 
}
EOF

URL=$(cat $TEMPFILE | jq -r '.url')
echo "URL=$URL"
# That's not really the final URL, has to be reformatted

echo "---------------------------"
curl --user "$GIT_USER:$GIT_PASSWORD" --silent https://api.github.com/users/brianwoelfel/gists | jq -r '.[] | select (.description =="$DESCRIPTION") | .url'

