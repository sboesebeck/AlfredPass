#!/bin/bash
PATH=$PATH:/usr/local/bin

query="$1"
query=${query#pass }
p=~/.password-store/$query
q=""
ff=0
d=0
if [ ! -e "$p.gpg"  ] && [ ! -e "$p" ]; then
     q="$(basename $query)"
     query=$(dirname $query)
     ff=0
else 
	if file $p | grep -v "No such" | grep "directory" >/dev/null 2>&1; then
	   #query is a dir... go ahead
	   q=""
           d=1
	else
          ff=1
	   q="$(basename $query)"
	   query=$(dirname $query)
	fi
     
fi
query=${query%/}

cd ~/.password-store/$query
echo '<?xml version="1.0"?>'
echo "<items>"
found=0
for i in $(find . -iname "*$q*" -type d -depth 1 | grep -v git); do
    let found=found+1
    i=$(basename $i)
    if [ "${i#.}" == "$i" ]; then
       # does not start with .
      
    arg="$query/$i"
    arg=${arg#./}
    echo "<item arg=\"pass $arg/\" autocomplete=\"$i\">"
    echo "    <title>$i/</title>"
    echo "    <subtitle>dir</subtitle>"
    echo "</item>"
    fi
done

if [ $ff -eq 0 ]; then
for i in $(find . -iname "*$q*.gpg" -type f -depth 1); do
    if [ "$i" == "*$q*.gpg" ]; then
        break;
    fi
    i=$(basename $i)
    it=${i%%.gpg}
    
    let found=found+1
    echo "<item uid=\"$it\" arg=\"pass $query/$it\" autocomplete=\"$i\">"
    echo "    <title>$it</title>"
    echo "    <subtitle>Entry</subtitle>"
    echo "</item>"
done
fi
if [ $d -eq 0 ]; then 
	if [ $ff -eq 0 ]; then
	    echo "<item uid=\"create\" arg=\"pgen $query/$q\" autocomplete=\"\">"
	    echo "    <title>create $query/$q</title>"
	    echo "    <subtitle>create new random password and store to clipboard</subtitle>"
	    echo "</item>"
	elif [ $ff -eq 1 ]; then
	    entry=$(PINENTRY_USER_DATA=gui pass show "$query/$q" 2>/dev/null)
            line=0
	    echo "$entry" | while IFS= read l; do
			let line=line+1
			k=$(echo $l | cut -f1 -d:)
			v=$(echo $l | cut -f2- -d:)
			v="${v# }"
			v2="$v"
			
			if [ "$v" == "$k" ]; then
				if [ "${k%>}" == "$k" ]; then
				v="********"
				k="password"
				else
					continue
				fi
			fi
			echo "<item arg=\"clipPass $query/$q $line\" autocomplete=\"$k\">"
			echo "    <title>$v</title>"
			echo "    <subtitle>copy $k to clipboard</subtitle>"
			echo "</item>"
	    done
	    echo "<item arg=\"pgen $query/$q\" autocomplete=\"\">"
	    echo "    <title>OVERWRITE: $query/$q</title>"
	    echo "    <subtitle>overwrite existing with new random password and store to clipboard</subtitle>"
	    echo "    <icon>save_icon.png</icon>"
	    echo "</item>"
	    echo "<item arg=\"remove $query/$q\" autocomplete=\"\">"
	    echo "    <title>REMOVE: $query/$q</title>"
	    echo "    <subtitle>DELETE ENTRY</subtitle>"
	    echo "    <icon>del_icon.png</icon>"
	    echo "</item>"
  
	fi
fi
echo "</items>"


