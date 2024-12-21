def android_jni_library(
        name,
        binary_name,
        **input_cc_library_kwargs):
    input_cc_library_name = name + "_input"
    native.cc_library(
        name = input_cc_library_name,
        **input_cc_library_kwargs
    )
    native.cc_binary(
        name = binary_name,
        linkshared = True,
        deps = [input_cc_library_name],
    )
    native.cc_library(
        name = name,
        srcs = [binary_name],
    )

def cc_lib_wrapper_for_android(
        name,
        lib_name,
        cc_library_target):
    native.cc_binary(
        name = lib_name,
        linkshared = True,
        deps = [cc_library_target],
    )
    native.cc_library(
        name = name,
        srcs = [lib_name],
    )
