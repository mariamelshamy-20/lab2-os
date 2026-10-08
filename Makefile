DIR=testdir
MALICIOUS_DIR=malicious_dir
INTERVAL=5
.PHONY: antivirus restore prepare
antivirus: prepare
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)
restore: prepare
	./restore.sh $(DIR) $(MALICIOUS_DIR)
prepare:
	mkdir -p $(MALICIOUS_DIR)
