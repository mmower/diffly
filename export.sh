#!/bin/sh
#
# expects name of patch-file and a list of files to include
#
SVN_PATH=$1
shift
OUTPUT_FILE=$1
shift
${SVN_PATH} diff $* > ${OUTPUT_FILE}