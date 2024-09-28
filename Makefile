FAB_INSTALLED := $(shell pip freeze | grep sci-fab >/dev/null; echo $$?)

.PHONY: default
default: build_driver

.PHONY: prereq
prereq: fab_install

.PHONY: fab_install
fab_install:
ifeq (${FAB_INSTALLED},0)
	@echo "FAB is installed"
else
	@echo "FAB is not installed. Installing now"
	pip install sci-fab
endif

.PHONY: build_driver
build_driver:
	@echo "Building SBC40 Driver"
