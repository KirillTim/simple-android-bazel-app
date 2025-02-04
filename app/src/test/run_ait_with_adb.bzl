load("@rules_android//android:rules.bzl", "ApkInfo", "StarlarkApkInfo")

def _get_apk_info(apk):
    if StarlarkApkInfo in apk:
        return apk[StarlarkApkInfo].signed_apk
    return apk[ApkInfo].signed_apk

def _my_android_instrumentation_test_impl(ctx):
    # struct(_aapt2_exe = <target @@androidsdk//:aapt2_binary>, ...
    # _adb_exe = <input file target @@androidsdk//:platform-tools/adb>, ...)
    print("ctx.attr: {}".format(ctx.attr))
    adb_tool_path = "adb"  #ctx.attr._adb_exe.path
    _aapt2_exe = ctx.executable._aapt2_exe
    print("type(_aapt2_exe): {}, _aapt2_exe: {}".format(type(_aapt2_exe), _aapt2_exe))
    subst = dict()
    subst["%%adb_tool_path%%"] = adb_tool_path
    subst["%%appt2_tool_path%%"] = _aapt2_exe.path
    subst["%%apk_path%%"] = _get_apk_info(ctx.attr.app).path
    subst["%%test_apk_path%%"] = _get_apk_info(ctx.attr.test_app).path
    out = ctx.actions.declare_file(ctx.label.name + "_script.sh")
    ctx.actions.expand_template(
        template = ctx.file._sh_script_template,
        is_executable = True,
        substitutions = subst,
        output = out,
    )

    runfiles = ctx.runfiles(files = [ctx.executable._aapt2_exe])
    return [DefaultInfo(executable = out, runfiles = runfiles)]

my_android_instrumentation_test = rule(
    implementation = _my_android_instrumentation_test_impl,
    attrs = {
        "app": attr.label(
            providers = [[ApkInfo], [StarlarkApkInfo]],
            allow_files = True,
        ),
        "test_app": attr.label(
            providers = [[ApkInfo], [StarlarkApkInfo]],
            allow_files = True,
        ),
        "_adb_exe": attr.label(
            allow_single_file = True,
            cfg = "exec",
            default = Label("@androidsdk//:platform-tools/adb"),
        ),
        "_aapt2_exe": attr.label(
            executable = True,
            cfg = "exec",
            default = Label("@androidsdk//:aapt2_binary"),
        ),
        "_sh_script_template": attr.label(
            allow_single_file = True,
            default = Label(":run_ait_with_adb.sh"),
        ),
    },
    test = True,
)
