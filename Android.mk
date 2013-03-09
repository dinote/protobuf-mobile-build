# Copyright (C) 2009 The Android Open Source Project
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #      http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.
    #
    #

    LOCAL_PATH := $(call my-dir)
    include $(CLEAR_VARS)

    CC_LITE_SRC_FILES := \
        src/google/protobuf/stubs/common.cc                              \
        src/google/protobuf/stubs/once.cc                                \
        src/google/protobuf/extension_set.cc                             \
        src/google/protobuf/generated_message_util.cc                    \
        src/google/protobuf/message_lite.cc                              \
        src/google/protobuf/repeated_field.cc                            \
        src/google/protobuf/wire_format_lite.cc                          \
        src/google/protobuf/io/coded_stream.cc                           \
        src/google/protobuf/io/zero_copy_stream.cc                       \
        src/google/protobuf/io/zero_copy_stream_impl_lite.cc


    # C++ lite library
    # =======================================================    

    LOCAL_MODULE := protobuf_lite_static
    LOCAL_MODULE_FILENAME := libprotobuf_lite

    LOCAL_CPP_EXTENSION := .cc

    LOCAL_SRC_FILES := \
        $(CC_LITE_SRC_FILES)


    LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/android \
        bionic \
        $(LOCAL_PATH)/src \
        $(JNI_H_INCLUDE)

    LOCAL_SHARED_LIBRARIES := \
        libz libcutils libutils
    LOCAL_LDLIBS := -lz
    # stlport conflicts with the host stl library
    ifneq ($(TARGET_SIMULATOR),true)
    LOCAL_C_INCLUDES += external/stlport/stlport
    LOCAL_SHARED_LIBRARIES += libstlport
    endif

    LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/src

    LOCAL_CFLAGS := -DGOOGLE_PROTOBUF_NO_RTTI

    include $(BUILD_STATIC_LIBRARY)