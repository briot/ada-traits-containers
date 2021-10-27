BUILD=Production

# Installation directory
PREFIX=

# In our automatic nightly builds, we want to consider the source
# directory as read-only, and build in another directory.
ifeq (${SOURCE_DIR},)
GPR_CONTS=src/gal.gpr
GPR_ROOT=root.gpr
SOURCE_DIR=$(shell pwd)
RBD=
else
GPR_CONTS=$(SOURCE_DIR)/src/gal.gpr
GPR_ROOT=${SOURCE_DIR}/root.gpr
RBD=--relocate-build-tree
endif

# The project path, when compiling tests
PPATH=GPR_PROJECT_PATH="${SOURCE_DIR}/src:${GPR_PROJECT_PATH}"

# Add support for passing extra switches to gprbuild, like -d
GPRBUILD_OPTIONS=

GPRBUILD=gprbuild -p -m -j0 -q ${RBD} ${GPRBUILD_OPTIONS}
GPRINSTALL=gprinstall -p -m ${RBD} ${GPRBUILD_OPTIONS} \
			  --install-name='gal' \
			  --project-subdir=lib/gnat

.PHONY: docs all build install ada_test clean

all:  build generate docs ada_test


generate: ./generate.py
	-python3 ./generate.py

build: generate
	${GPRBUILD} -P${GPR_CONTS} -XBUILD=${BUILD}

build_test_debug: generate
	${GPRBUILD} -XBUILD=Debug tests/tests.gpr
	${GPRBUILD} -XBUILD=Debug tests/perfs/tests_perfs.gpr

build_test_production: generate
	${GPRBUILD} -XBUILD=Production tests/tests.gpr
	${GPRBUILD} -XBUILD=Production tests/perfs/tests_perfs.gpr

docs:
	cd docs_src; ${MAKE} html

install:
	${GPRINSTALL} -P${GPR_CONTS} --prefix=${PREFIX}

test: build build_test_debug build_test_production
	tests/obj/Debug/main
	tests/obj/Production/main
	tests/perfs/obj/Production/main_perf -o docs/perfs/data.js

clean:
	-rm -rf tests/perfs/obj/
	-rm -rf tests/perfs/lib/
	-rm -rf src/obj/
	-rm -rf src/lib/
	-rm -rf tests/obj
	-rm -f docs/perfs/data.js
	-rm -rf src/generated
	-rm -rf tests/generated
	-rm -rf tests/perfs/generated
