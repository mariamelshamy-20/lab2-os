Overview:
This project represents an antivirus system written using bash on debian .
The system monitors changes in the directory and scans the path and contents of file with every change for malicious files. When a malicious file is detected , it is moved to malicious directory and deleted from main directory , you can later restore it if you want .
Project files:
1-	Antivirusd.sh: monitors directory and scans it when a change is detected 
2-	Restore.sh: for reviewing files in malicious directory , and user can either restore them , permanently delete them or leave them.
3-	Antivirus-cron.sh: does an automatic antivirus scan and runs automatically with cron. (bonus 1)
4-	Makefile: gives commands for running the program .
5-	Whitelist.txt:  stores the filenames of restored files by user. (bonus 2)
6-	directory-info.last: Stores the most recent status of the required directory.
7-	directory-info.new: Stores a new state for comparison with the previous one.
8-	•  README.md: for documentation .

Packages needed to be installed or updated (used):
sudo apt update
sudo apt install make (to install make)
sudo apt install cron (to install cron)
sudo systemctl enable --now cron (to start cron)
systemctl status cron (for cron debugging)

to make the files executable :
run this in terminal inside folder : chmod +x filename
running the antivirus:
antivirusd acceots 3 parameters , (./antivirusd.sh dir malicious_dir interval-secs)
The parameters are:
•	test_dir: The directory to monitor.
•	malicious_dir: The directory where malicious files are quarantined.
•	5: The interval, in seconds, between checks.
In the first run, If directory-info.last does not exist, it scans the monitored directory then creates directory-info.last using the contents of the monitored directory.
Then periodically , it creates directory-info.new and compares it with directory-info.last then 
•	If they are identical, it does not scan the directory.
•	If they are different, it scans the directory and updates directory-info.last using the state after scanning.
Malicious file detection:
The antivirus uses two lists to identify potentially malicious files: a list of flagged extensions and a list of flagged keywords.
The list is defined in the script as:
Malicious_ext=".exe .bat .vbs .scr .ps1"
Malicious_words="virus trojan malware worm ransomware"
And they are case insensitive .
A file is malicious if its extension is one of the flagged or it contains a word from the flagged words.
 Quarantining Malicious Files
When a malicious file is detected, the program prints:
<file> is malicious and is deleted.
The file is copied to malicious_dir using its original filename. The original file is then removed from the monitored directory. The malicious directory is created automatically if it does not exist.
The restoring:
Restore accepts two parameters (./restore.sh dir malicious_dir)
The program shows a list of malicious files and the user chooses which file to review , then the user has 3 options restore , delete , leave it.
Option 1: restore
File is copied back to its directory and removed from malaiciou directory.
Option 2: delete
Permanently deletes the file from the dir
Option 3: leave it 
Returns to file list
Makefile:
Gives commands for running the project , commands used :
make antivirus  runs the antivirus using the written directories and interval.
make restore  starts the restore tool using the written directories.
make cron  executes antivirus-cron.sh once. 
The .PHONY declaration ensures that the action targets run as commands not files.

Bonus 1:
Antivirus-cron.sh is an antivirus scan run by cron , it performs one scan and exits.
it waits 23 seconds and then scans the directory once and it uses the same flagged extensions, keywords, and quarantine behavior as the main antivirus script.
Bonus 2:
whitelist.txt file.
The whitelist prevents restored files from being quarantined again in every scan.
Before checking the extension or contents of a file, the antivirus checks if it is in the whitelist.
•	If it is found, the file is skipped.
•	If it is not found, scanning happens



