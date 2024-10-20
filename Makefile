O_DIR := $(shell pwd)

.PHONY: default
default: build_driver


.PHONY: prereq
prereq:
	${O_DIR}/bin/setup_prereqs ${O_DIR}


.PHONY: build_driver
build_driver: prereq
	@echo "Building SBC40 Driver"
	${O_DIR}/bin/launch_fab ${O_DIR} ./fab-sdc40_driver

.PHONY: fileinstall
fileinstall:
	sudo cp ./fab-workspace/sdc40_driver/main.exe /usr/bin/sensinghome_sdc40_driver
	sudo mkdir -p /usr/share/doc/sensinghome-sdc40-driver/
	sudo cp ./src/sdc40_driver/copyright /usr/share/doc/sensinghome-sdc40-driver/copyright
    
.PHONY: package
package:
	make build_driver
	./checkinstall/checkinstall-sdc40_driver
