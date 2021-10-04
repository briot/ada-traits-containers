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

.PHONY: docs all install ada_test clean

all:
	${GPRBUILD} -P${GPR_CONTS} -XBUILD=${BUILD}

docs:
	cd docs_src; ${MAKE} html

install:
	${GPRINSTALL} -P${GPR_CONTS} --prefix=${PREFIX}

# Run Ada tests (not using gnatpython)
ada_test:
	cd tests/perfs; python3 ./generate_test.py && ${GPRBUILD} -XBUILD=${BUILD} && ./obj/main && open index.html

# Run all tests, except manual ones
test:
	cd tests; ${PPATH} python3 ./testsuite.py -j0 --enable-color

# Run all tests with valgrind
test_with_valgrind:
	cd tests; ${PPATH} python3 ./testsuite.py -j0 --enable-color --valgrind

# Verify memory leaks in tests
test_with_leaks:
	cd tests; ${PPATH} python3 ./testsuite.py -j0 --enable-color --leaks

# Run manual tests
perfs:
	${GPRBUILD} -P${GPR_CONTS} -XBUILD=Production
	cd tests; ${PPATH} python3 ./testsuite.py -j0 --enable-color $@
spark:
	${GPRBUILD} -P${GPR_CONTS} -XBUILD=Debug
	cd tests; ${PPATH} python3 ./testsuite.py -j0 --enable-color $@

# Create all project files, for use with GPS
projects:
	cd tests; python3 ./testsuite.py -c

clean:
	${PPATH} gprclean -P${GPR_ROOT} -XBUILD=Debug -r -q
	${PPATH} gprclean -P${GPR_ROOT} -XBUILD=Production -r -q
	-rm -f tests/*/auto_*.gpr
	-rm -rf tests/*/obj/

