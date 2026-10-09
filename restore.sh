#!/bin/bash
if [ $# -ne 2 ]; then
	echo "Usage: $0 dir malicious_dir"
	exit 1
fi
dir="$1"
malicious_dir="$2"
whitelist="whitelist.txt"
if [ -z "$(ls "$malicious_dir")" ]; then
	echo "no malicious files to review"
	exit 0
fi
while true
do
	files=()
	for file in "$malicious_dir"/*
	do
		if [ -f "$file" ]; then
		files+=("$file")
		fi
	done
	if [ ${#files[@]} -eq 0 ]; then
		echo "no malicious files to review"
		exit 0
	fi
echo "malicious files:"
for i in "${!files[@]}"
do
	filename=$(basename "${files[$i]}")
	echo "$((i+1)).$filename"
done
echo " choose a file by number"
read choice
selected="${files[$((choice -1))]}"
filename=$(basename "$selected")
echo "1.restore this file"
echo "2.permanently delete file"
echo "3.leave file as it is"
echo "choose option"
read option
if [ "$option" -eq 1 ]; then
	cp "$selected" "$dir/$filename"
	rm "$selected"
	if ! grep -Fxq "$filename" "$whitelist" 2>/dev/null; then
	echo "$filename" >> "$whitelist"
	fi
	echo "restored $filename to $dir"
elif [ "$option" -eq 2 ]; then
	rm "$selected"
	echo "$filename permanently deleted"
elif [ "$option" -eq 3 ]; then
	continue
else echo "invalid option"
fi
done
