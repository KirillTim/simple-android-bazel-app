load("@rules_android//android:rules.bzl", "ApkInfo", "StarlarkApkInfo")

def _get_apk_info(apk):
    if StarlarkApkInfo in apk:
        return apk[StarlarkApkInfo].signed_apk
    return apk[ApkInfo].signed_apk

def _label_to_string(ctx, label):
    return "@{}//{}:{}".format(
        "" if label.workspace_name == ctx.workspace_name else label.workspace_name,
        label.package,
        label.name,
    )

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

def _my_runfile_rule_test_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name + "_script.sh")
    print("ctx.executable._aapt2_exe: {}".format(ctx.executable._aapt2_exe.path))
    print("ctx.executable._aapt2_exe: {}".format(ctx.executable._aapt2_exe.short_path))
    aapt2_str_label = _label_to_string(ctx, ctx.attr._aapt2_exe.label)
    print("ctx.attr._aapt2_exe[DefaultInfo]: {}".format(ctx.attr._aapt2_exe[DefaultInfo]))
    expanded_aapt2_label = ctx.expand_location("$(locations {})".format(aapt2_str_label), [ctx.attr._aapt2_exe])
    print("expanded_aapt2_label: {}".format(expanded_aapt2_label))
#    aapt2_str_label = _label_to_string(ctx, ctx.attr._aapt2_exe.label)
    adb_str_label = _label_to_string(ctx, ctx.attr._adb_exe.label)
    expanded_adb_label = ctx.expand_location("$(location {})".format(adb_str_label), [ctx.attr._adb_exe])
    print("expanded_adb_label: {}".format(expanded_adb_label))
    print("ctx.attr._adb_exe[DefaultInfo]: {}".format(ctx.attr._adb_exe[DefaultInfo]))
    adb = ctx.attr._adb_exe.files_to_run.executable
    aapt2 = ctx.attr._aapt2_exe.files_to_run.executable
    apk_file = _get_apk_info(ctx.attr.app)
    ctx.actions.write(
        output = out,
        is_executable = True,
        content = """
#        RUNFILES_DIR="$0.runfiles"
#        echo "$RUNFILES_DIR"
#        echo "$PWD"
#        echo "$TEST_SRCDIR"
        find $PWD -name "*.apk"
        find $PWD -name "aapt2*"
        find $PWD -name "adb"
        {adb} --version
        {aapt2} version
        file {apk}
        """.format(apk = apk_file.short_path, adb = adb.short_path, aapt2 = aapt2.short_path),
    )
#    apk_file = _get_apk_info(ctx.attr.app)
#    adb_files = ctx.attr._adb_exe[DefaultInfo].files
#    runfiles = ctx.runfiles(files = [ctx.executable._aapt2_exe, apk_file] + adb_files.to_list())
    runfiles = ctx.runfiles(files = [apk_file], transitive_files = ctx.attr._adb_exe.files).merge(ctx.attr._aapt2_exe.default_runfiles)
    return [DefaultInfo(executable = out, runfiles = runfiles)]

my_runfile_rule_test = rule(
    implementation = _my_runfile_rule_test_impl,
    attrs = {
        "_adb_exe": attr.label(
            allow_single_file = True,
            cfg = "exec",
            default = Label("@androidsdk//:platform-tools/adb"),
        ),
        "app": attr.label(
            providers = [[ApkInfo], [StarlarkApkInfo]],
            allow_files = True,
        ),
        "_aapt2_exe": attr.label(
            executable = True,
            cfg = "exec",
            default = Label("@androidsdk//:aapt2_binary"),
        ),
    },
    test = True,
)
