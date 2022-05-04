#!/bin/bash

. ./env.inc

query="$1"

PATH=$PATH:/usr/local/bin

cd ~/.password-store
echo '{"items":['

if pass index >/dev/null 2>&1; then
	PINENTRY_USER_DATA=gui pass index find $query | while IFS= read l; do
		echo "{ \"title\" : \"$l\", \"arg\": \"$l\", \"subtitle\":\"matching entry\"},"			

	done
else
	PINENTRY_USER_DATA=gui pass grep -l $query | grep -v standard | sed  -e 's/:$//'
fi
echo "]}"
