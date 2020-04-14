#!/bin/bash

DESCRIPTION=$1

URL=$(curl --user "$GIT_USER:$GIT_PASSWORD" https://api.github.com/users/$GIT_USER/gists \
  | jq -r ".[] | select(.description == \"${DESCRIPTION}\") | .url")

echo "DESCRIPTION=$DESCRIPTION"
echo "URL=$URL"

if [ ! -z "${URL}" ]; then
	curl --silent -v -H "Content-Type: text/json; charset=utf-8" \
        -H "Authorization: Token $GIT_TOKEN" \
        -X DELETE "${URL}"
fi


