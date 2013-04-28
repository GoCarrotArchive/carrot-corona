#!/bin/sh

path=`dirname $0`

OUTPUT_DIR=$1
TARGET_NAME=$2

CONFIG=Release
DEVICE_TYPE=all
BUILD_TYPE=clean

CORONA_ENTERPRISE=/Applications/CoronaEnterprise

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

if [ -z "$ANDROID_NDK" ]
then
	echo "ERROR: ANDROID_NDK environment variable must be defined"
	exit 0
fi

# Canonicalize paths
pushd $path > /dev/null
dir=`pwd`
path=$dir
popd > /dev/null

NDK_MODULE_PATH=$path/../../../plugins/
pushd $NDK_MODULE_PATH > /dev/null
dir=`pwd`
NDK_MODULE_PATH=$dir
popd > /dev/null

#####################
# Lua Bytecodes     #
#####################

BIN_DIR=$CORONA_ENTERPRISE/Corona/mac/bin

$BIN_DIR/lua2c.sh $path/../shared/${TARGET_NAME}.lua $path/. $CONFIG
checkError

######################
# Build .so          #
######################

pushd $path/jni > /dev/null

if [ "Release" == "$CONFIG" ]
then
	echo "Building RELEASE"
	OPTIM_FLAGS="release"
else
	echo "Building DEBUG"
	OPTIM_FLAGS="debug"
fi

if [ "clean" == "$BUILD_TYPE" ]
then
	echo "== Clean build =="
	rm -r $path/obj/ $path/libs/
	FLAGS="-B"
else
	echo "== Incremental build =="
	FLAGS=""
fi

CFLAGS=

if [ "$OPTIM_FLAGS" = "debug" ]
then
	CFLAGS="${CFLAGS} -DRtt_DEBUG -g"
	FLAGS="$FLAGS NDK_DEBUG=1"
fi

#
# Export environment vars to Android.mk
#

CORONA_ENTERPRISE_RELATIVE=`"$CORONA_ENTERPRISE"/Corona/mac/bin/relativePath.sh . "$CORONA_ENTERPRISE"`
export CORONA_ENTERPRISE_RELATIVE=$CORONA_ENTERPRISE_RELATIVE
echo $CORONA_ENTERPRISE_RELATIVE

export TARGET_NAME=$TARGET_NAME
echo $TARGET_NAME

export NDK_MODULE_PATH=$NDK_MODULE_PATH
echo $NDK_MODULE_PATH

# # Copy .so files
# LIBS_SRC_DIR=$CORONA_ENTERPRISE/Corona/android/lib/Corona/libs/armeabi-v7a
# LIBS_DST_DIR=$path
# mkdir -p "$LIBS_DST_DIR"
# checkError
# 
# cp -v "$LIBS_SRC_DIR"/libcorona.so "$LIBS_DST_DIR"/.
# checkError
# 
# cp -v "$LIBS_SRC_DIR"/liblua.so "$LIBS_DST_DIR"/.
# checkError

if [ -z "$CFLAGS" ]
then
	echo "----------------------------------------------------------------------------"
	echo "$ANDROID_NDK/ndk-build $FLAGS V=1 APP_OPTIM=$OPTIM_FLAGS"
	echo "----------------------------------------------------------------------------"

	$ANDROID_NDK/ndk-build $FLAGS V=1 APP_OPTIM=$OPTIM_FLAGS
	checkError
else
	echo "----------------------------------------------------------------------------"
	echo "$ANDROID_NDK/ndk-build $FLAGS V=1 MY_CFLAGS="$CFLAGS" APP_OPTIM=$OPTIM_FLAGS"
	echo "----------------------------------------------------------------------------"

	$ANDROID_NDK/ndk-build $FLAGS V=1 MY_CFLAGS="$CFLAGS" APP_OPTIM=$OPTIM_FLAGS
	checkError
fi

popd > /dev/null

######################
# Post-compile Steps #
######################

# Copy .so files over to the Android SDK (Java) side of things
cp -rv $path/libs/armeabi-v7a/lib${TARGET_NAME}.so $OUTPUT_DIR
checkError

