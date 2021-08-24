#!/bin/bash
cmd=$1
query="$2"
idx=""
pass index >/dev/null 2>&1 && idx="index"
PATH=$PATH:/usr/local/bin
if [ "$cmd" == "pinfo" ]; then
   #starts with pinfo
   osascript -e "tell application \"Alfred\" to search \"pinfo $query\""
elif [ "$cmd" == "clipPass" ]; then
   query=${query#/}
   PINENTRY_USER_DATA=gui pass show --clip=$3 "$query"
   osascript -e "display notification \"Entry#$3 for $query copied to clipboard\" with title \"Passwordstore\""

elif [ "$cmd" == "remove" ]; then
   query=${query#/}
   PINENTRY_USER_DATA=gui pass $idx rm $query
   osascript -e "display notification \"Entry $query removed\" with title \"Passwordstore\""

elif [ "$cmd" == "pgen" ]; then
   query=${query#/}
   PINENTRY_USER_DATA=gui pass $idx generate -c -f "$query" 32
   osascript -e "display notification \"Password for $query generated and copied to clipboard\" with title \"Passwordstore\""
else 
   osascript -e "tell application \"Alfred\" to search \"$cmd $query\""
fi