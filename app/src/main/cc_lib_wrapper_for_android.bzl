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
