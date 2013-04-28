#!/bin/bash

path=`dirname $0`

OUTPUT_DIR=$1
TARGET_NAME=$2
OUTPUT_SUFFIX=a
CONFIG=Release

if [ -z "$OUTPUT_DIR" ]
then
	echo "No OUTPUT_DIR"
	exit -1
fi

if [ -z "$TARGET_NAME" ]
then
	echo "No TARGET_NAME"
	exit -1
fi


#
# Checks exit value for error
# 
checkError() {
    if [ $? -ne 0 ]
    then
        echo "Exiting due to errors (above)"
        exit -1
    fi
}

# 
# Canonicalize relative paths to absolute paths
# 
pushd $path > /dev/null
dir=`pwd`
path=$dir
popd > /dev/null

pushd $OUTPUT_DIR > /dev/null
dir=`pwd`
OUTPUT_DIR=$dir
popd > /dev/null

echo "OUTPUT_DIR: $OUTPUT_DIR"

# Clean
xcodebuild -project "$path/Plugin.xcodeproj" -target ${TARGET_NAME} -configuration $CONFIG clean
checkError

# iOS
xcodebuild -project "$path/Plugin.xcodeproj" -target ${TARGET_NAME} -configuration $CONFIG -sdk iphoneos
checkError

# iOS-sim
xcodebuild -project "$path/Plugin.xcodeproj" -target ${TARGET_NAME} -configuration $CONFIG -sdk iphonesimulator
checkError

# create universal binary
lipo -create "$path"/build/$CONFIG-iphoneos/lib${TARGET_NAME}.$OUTPUT_SUFFIX "$path"/build/$CONFIG-iphonesimulator/lib${TARGET_NAME}.$OUTPUT_SUFFIX -output "$OUTPUT_DIR"/lib${TARGET_NAME}.$OUTPUT_SUFFIX
checkError

echo "$OUTPUT_DIR"/lib${TARGET_NAME}.$OUTPUT_SUFFIX
