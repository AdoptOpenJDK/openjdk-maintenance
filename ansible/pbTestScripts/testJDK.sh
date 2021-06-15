#!/bin/bash

export MAKE_COMMAND="make"
if [[ $(uname) == "FreeBSD" ]]; then
	export MAKE_COMMAND="gmake"
	cp -r $HOME/openjdk-build/workspace/build/src/build/*/jdk* $HOME
	export TEST_JDK_HOME=$HOME/jdk
else
	export TEST_JDK_HOME=$(ls -1d "$HOME/openjdk-build/workspace/build/src/build/*/images/jdk*" |grep -v ".*jre.*"|grep -v ".*-image")
	echo SXA: TEST_JDK_HOME = "$TEST_JDK_HOME"
	ls -ld $HOME/openjdk-build/workspace/build/src/build/*/images/*
fi

mkdir -p $HOME/testLocation
[ ! -d $HOME/testLocation/openjdk-tests ] && git clone https://github.com/adoptopenjdk/openjdk-tests $HOME/testLocation/openjdk-tests
$HOME/testLocation/openjdk-tests/get.sh -t $HOME/testLocation/openjdk-tests
cd $HOME/testLocation/openjdk-tests/TKG || exit 1
export BUILD_LIST=functional
$MAKE_COMMAND compile
# Runs this test to check for prerequisite perl modules
$MAKE_COMMAND _MBCS_Tests_pref_ja_JP_linux_0
