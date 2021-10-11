BUILD=Production

# Installation directory
PREFIX=

# In our automatic nightly builds, we want to consider the source
# directory as read-only, and build in another directory.
ifeq (${SOURCE_DIR},)
GPR_CONTS=src/containers.gpr
GPR_ROOT=root.gpr
SOURCE_DIR=$(shell pwd)
RBD=
else
GPR_CONTS=$(SOURCE_DIR)/src/containers.gpr
GPR_ROOT=${SOURCE_DIR}/root.gpr
RBD=--relocate-build-tree
endif

# The project path, when compiling tests
PPATH=GPR_PROJECT_PATH="${SOURCE_DIR}/src:${GPR_PROJECT_PATH}"

# Add support for passing extra switches to gprbuild, like -d
GPRBUILD_OPTIONS=

GPRBUILD=gprbuild ${RBD} -p -m -j0 ${GPRBUILD_OPTIONS}
GPRINSTALL=gprinstall ${RBD} -p -m ${GPRBUILD_OPTIONS} \
			  --install-name='containers' \
			  --project-subdir=lib/gnat

.PHONY: docs all build install ada_test clean

all:  build generate docs ada_test


generate:
	-python3 ./generate.py

build: generate
	${GPRBUILD} -P${GPR_CONTS} -XBUILD=${BUILD}

docs:
	cd docs_src; ${MAKE} html

install:
	${GPRINSTALL} -P${GPR_CONTS} --prefix=${PREFIX}

# Run Ada tests (not using gnatpython)
test: build
	@echo "==== Running tests in Debug mode ===="
	@${GPRBUILD} -q -XBUILD=Debug tests/tests.gpr && \
		tests/obj/Debug/main
	@echo "==== Running tests in Production mode ===="
	@${GPRBUILD} -q -XBUILD=Production tests/tests.gpr && \
		tests/obj/Production/main
	@echo "==== Running performance tests ===="
	@cd tests/perfs; \
		python3 ./generate_test.py && \
		${GPRBUILD} -q -XBUILD=Production && \
		./obj/Production/main

clean:
	${PPATH} gprclean -P${GPR_ROOT} -XBUILD=Debug -r -q
	${PPATH} gprclean -P${GPR_ROOT} -XBUILD=Production -r -q
	-rm -f tests/*/auto_*.gpr
	-rm -rf tests/*/obj/
	-rm -f docs/perfs/data.js
