#!/bin/bash

path=`dirname $0`

BUILD_DIR=$1
LIBRARY_NAME="carrot"
PRODUCT=sdk

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

#
# Defaults
#

if [ ! "$BUILD_DIR" ]
then
	BUILD_DIR=$path/build
fi

#
# OUTPUT_DIR
# 
OUTPUT_DIR=$BUILD_DIR/$PRODUCT

# Clean build
if [ -e "$OUTPUT_DIR" ]
then
	rm -rf "$OUTPUT_DIR"
fi

# Plugins
OUTPUT_PLUGINS_DIR=$OUTPUT_DIR/plugins
OUTPUT_DIR_IOS=$OUTPUT_PLUGINS_DIR/iphone
OUTPUT_DIR_IOS_SIM=$OUTPUT_PLUGINS_DIR/iphone-sim
OUTPUT_DIR_MAC=$OUTPUT_PLUGINS_DIR/mac-sim
OUTPUT_DIR_ANDROID=$OUTPUT_PLUGINS_DIR/android
OUTPUT_DIR_WIN32=$OUTPUT_PLUGINS_DIR/win32-sim

# Docs
OUTPUT_DIR_DOCS=$OUTPUT_DIR/docs

# Samples
OUTPUT_DIR_SAMPLES=$OUTPUT_DIR/samples

# Create directories
mkdir -p "$OUTPUT_DIR"
checkError

mkdir -p "$OUTPUT_DIR_IOS"
checkError

mkdir -p "$OUTPUT_DIR_IOS_SIM"
checkError

mkdir -p "$OUTPUT_DIR_MAC"
checkError

mkdir -p "$OUTPUT_DIR_ANDROID"
checkError

mkdir -p "$OUTPUT_DIR_WIN32"
checkError

mkdir -p "$OUTPUT_DIR_SAMPLES"
checkError

#
# Build
#

echo "------------------------------------------------------------------------"
echo "[ios]"
cd "$path/ios"
	./build.sh "$OUTPUT_DIR_IOS" plugin_${LIBRARY_NAME}
	checkError

	cp -v metadata.lua "$OUTPUT_DIR_IOS"
	checkError

	cp -rv "$OUTPUT_DIR_IOS/" "$OUTPUT_DIR_IOS_SIM"

	# Remove i386 from ios build
	find "$OUTPUT_DIR_IOS" -name \*.a | xargs -n 1 -I % lipo -remove i386 % -output %

	# Remove armv7 from ios-sim build
	find "$OUTPUT_DIR_IOS_SIM" -name \*.a | xargs -n 1 -I % lipo -remove armv7 % -output %
cd -

echo "------------------------------------------------------------------------"
echo "[android]"
cd "$path/android"
	./build.sh "$OUTPUT_DIR_ANDROID" plugin_${LIBRARY_NAME}
	checkError

	cp -v metadata.lua "$OUTPUT_DIR_ANDROID"
	checkError

cd -

echo "------------------------------------------------------------------------"
echo "[mac]"
cp $path/shared/plugin_${LIBRARY_NAME}.lua "$OUTPUT_DIR_MAC"
checkError

echo "------------------------------------------------------------------------"
echo "[win32]"
cp $path/shared/plugin_${LIBRARY_NAME}.lua "$OUTPUT_DIR_WIN32"
checkError

echo "------------------------------------------------------------------------"
echo "[docs]"
cp -vrf "$path/docs" "$OUTPUT_DIR"
checkError

echo "------------------------------------------------------------------------"
echo "[samples]"
cp -vrf "$path/Corona/" "$OUTPUT_DIR_SAMPLES"
checkError

echo "------------------------------------------------------------------------"
echo "Generating plugin zip"
ZIP_FILE=$BUILD_DIR/${PRODUCT}-${LIBRARY_NAME}.zip
cd "$OUTPUT_DIR"
	zip -rv "$ZIP_FILE" *
cd -

echo "------------------------------------------------------------------------"
echo "Plugin build succeeded."
echo "Zip file located at: '$ZIP_FILE'"
