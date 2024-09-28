FAB_INSTALLED := $(shell pip freeze | grep sci-fab >/dev/null; echo $$?)
PIP_INSTALLED := $(shell dpkg -l | grep -E 'python3-pip\s' >/dev/null; echo $$?)
CLANGPY_INSTALLED := $(shell pip freeze | grep clang >/dev/null; echo $$?)
ifeq (${CLANGPY_INSTALLED},0)
LIBCLANG_VER := $(shell pip freeze | grep clang | sed -E 's/.*==([1234567890]*)..*/\1/g')
LIBCLANG_INSTALLED := $(shell dpkg -l | grep -E "libclang-${LIBCLANG_VER}-dev\s" >/dev/null; echo $$?)
endif

.PHONY: default
default: build_driver


.PHONY: prereq
prereq: fab_install


.PHONY: fab_install
fab_install: pip_install clangpy_install
ifeq (${FAB_INSTALLED},0)
	@echo "FAB is installed"
else
	@echo "FAB is not installed. Installing now"
	pip install sci-fab
endif


.PHONY: clangpy_install
clangpy_install: pip_install
ifeq (${CLANGPY_INSTALLED},0)
	@echo "Clang python bindings are installed"
else
	@echo "Clang python bindings are not installed. Installing now"
	pip install clang
endif
	make libclang_install


.PHONY: libclang_install
libclang_install: 
ifeq (${CLANGPY_INSTALLED},0)
ifeq (${LIBCLANG_INSTALLED},0)
	@echo "libclang is installed"
else
	@echo "libclang is not installed. Installing now"
	sudo apt-get install libclang-${LIBCLANG_VER}-dev
endif
else
	make clangpy_install
endif
    

.PHONY: pip_install
pip_install:
ifeq (${PIP_INSTALLED},0)
	@echo "pip is installed"
else
	@echo "pip is not installed. Installing now"
	sudo apt-get install python3-pip
endif


.PHONY: build_driver
build_driver: prereq
	@echo "Building SBC40 Driver"
	cd fab && ./fab-sdc40_driver
