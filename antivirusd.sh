#!/bin/bash

if [ $# -ne 3 ]; then
	echo "Usage: $0 dir malicious_dir interval-secs"
	exit 1
fi
dir="$1"
malicious_dir="$2"
interval_secs="$3"
whitelist="whitelist.txt"
last="directory-info.last"
new="directory-info.new"
malicious_ext=".exe .bat .vbs .scr .ps1"
malicious_words="virus trojan malware worm ransomware"
scan_files(){
	for file in "$dir"/*
	do
		if [ ! -f "$file" ]; then
		continue
		fi

		filename=$(basename "$file")
		malicious=false
		if grep -Fxq "$filename" "whitelist" 2>/dev/null; then
			continue
		fi
		for extension in $malicious_ext
		do
			if [[ "$filename" == *"$extension" ]]; then
			malicious=true
			break
			fi
		done
			if [ "$malicious" = false ]; then
				for keyword in $malicious_words
				do
					if grep -qi "$keyword" "$file";then
					malicious=true
					break
					fi
				done
			fi
		if [ "$malicious" = true ]; then
		echo "$filename is malicious and is deleted"
		cp "$file" "$malicious_dir/$filename"
		rm "$file"
		fi
		done
 }

if [ ! -f "last" ]; then
scan_files
ls -l "$dir" > "$last"
fi
while true
do
ls -l "$dir" > "$new"
if ! cmp -s "$last" "$new"; then
scan_files
ls -l "$dir" "$last"
fi
sleep "$interval_secs"
done
