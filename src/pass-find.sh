#!/bin/bash


query="$1"

PATH=$PATH:/usr/local/bin

cd ~/.password-store
echo '{"items":['

PINENTRY_USER_DATA=gui pass index find $query | while IFS= read l; do
	echo "{ \"title\" : \"$l\", \"arg\": \"pass $l\", \"subtitle\":\"matching entry\"},"			

done
echo "]}"
