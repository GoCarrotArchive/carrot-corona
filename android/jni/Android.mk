# Copyright (C) 2012 Corona Labs Inc.
#

# TARGET_PLATFORM := android-14

LOCAL_PATH:= $(call my-dir)
CORONA_ENTERPRISE:=/Applications/CoronaEnterprise
CORONA_ROOT:=$(CORONA_ENTERPRISE)/Corona

# -----------------------------------------------------------------------------

include $(CLEAR_VARS)
LOCAL_MODULE := corona
LOCAL_SRC_FILES := $(CORONA_ENTERPRISE_RELATIVE)/Corona/android/lib/Corona/libs/armeabi-v7a/libcorona.so
include $(PREBUILT_SHARED_LIBRARY)

# -----------------------------------------------------------------------------

include $(CLEAR_VARS)
LOCAL_MODULE := lua
LOCAL_SRC_FILES := $(CORONA_ENTERPRISE_RELATIVE)/Corona/android/lib/Corona/libs/armeabi-v7a/liblua.so
include $(PREBUILT_SHARED_LIBRARY)

# -----------------------------------------------------------------------------

include $(CLEAR_VARS)

LOCAL_MODULE    := $(TARGET_NAME)

PLUGIN_DIR      := ../..
CORONA_API_DIR  := $(CORONA_ROOT)/shared/include/Corona
LUA_API_DIR     := $(CORONA_ROOT)/shared/include/lua

LOCAL_C_INCLUDES := \
	$(PLUGIN_DIR) \
	$(CORONA_API_DIR) \
	$(LUA_API_DIR)

LOCAL_SRC_FILES  := \
	$(PLUGIN_DIR)/shared/LuaLibraryShim.cpp \
	$(PLUGIN_DIR)/android/$(TARGET_NAME).c

LOCAL_CFLAGS     := \
	-DANDROID_NDK \
	-DNDEBUG \
	-D_REENTRANT \
	-DRtt_ANDROID_ENV

LOCAL_SHARED_LIBRARIES := corona lua
LOCAL_LDLIBS := -llog

ifeq ($(TARGET_ARCH),arm)
LOCAL_CFLAGS+= -D_ARM_ASSEM_
endif

LOCAL_ARM_MODE := arm

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
#	LOCAL_CFLAGS := $(LOCAL_CFLAGS) -DHAVE_NEON=0
#	LOCAL_ARM_NEON  := true	
endif

include $(BUILD_SHARED_LIBRARY)
