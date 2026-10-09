#!/bin/bash

if [ $# -ne 2 ]; then
        echo "Usage: $0 dir malicious_dir"
        exit 1
fi
dir="$1"
malicious_dir="$2"
sleep 23
malicious_ext=".exe .bat .vbs .scr .ps1"
malicious_words="virus trojan malware worm ransomware"
for file in "$dir"/*
        do
                if [ ! -f "$file" ]; then
                continue
                fi

                filename=$(basename "$file")
                malicious=false

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
