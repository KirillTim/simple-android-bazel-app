load("@rules_android//android:rules.bzl", "StarlarkApkInfo", "ApkInfo")

def _label_to_string(ctx, label):
    return "@{}//{}:{}".format(
        "" if label.workspace_name == ctx.workspace_name else label.workspace_name,
        label.package,
        label.name,
    )

def _get_apk_info(apk):
    if StarlarkApkInfo in apk:
        return apk[StarlarkApkInfo].signed_apk
    return apk[ApkInfo].signed_apk

def _run_ait_with_adb_impl(ctx):
    print("ctx.attr: {}".format(ctx.attr))
    print("ctx.attr.adb_exe_path_file: {}".format(type(ctx.attr.adb_exe_path_file)))
#    print("ctx.executable.adb_exe: {}".format(ctx.executable.adb_exe))
#    print("type(ctx.executable.adb_exe): {}".format(type(ctx.executable.adb_exe))
    subst = dict()
    subst["%%adb_tool_path%%"] = "adb"
    subst["%%appt2_tool_path%%"] = ctx.executable.aapt2_exe.path
    subst["%%apk_path%%"] = _get_apk_info(ctx.attr.app).path
    subst["%%test_apk_path%%"] = _get_apk_info(ctx.attr.test_app).path
    print(subst)
    out = ctx.actions.declare_file(ctx.label.name + "_script.sh")
    ctx.actions.expand_template(
        template = ctx.file._sh_script_template,
#        is_executable = True,
        substitutions = subst,
        output = out
    )
#    print("ctx.executable.aapt2_exe: {}".format(ctx.executable.aapt2_exe))
#    print("type(ctx.executable.aapt2_exe): {}".format(type(ctx.executable.aapt2_exe)))
#    print("ctx.executable.aapt2_exe.path: {}".format(ctx.executable.aapt2_exe.path))

#    expanded = [ctx.expand_location("$(location {})".format(adb_exe_label_str), [ctx.attr.adb_exe])]
#    expanded += [ctx.expand_location("$(execpath {})".format(adb_exe_label_str), [ctx.attr.adb_exe])]
#    expanded += [ctx.expand_location("$(rootpath {})".format(adb_exe_label_str), [ctx.attr.adb_exe])]
#    print("expanded: {}".format(expanded))
#    ctx.actions.write(output = out, content = "\n".join([]))
    return [DefaultInfo(files = depset([out]))]

run_ait_with_adb = rule(
    implementation = _run_ait_with_adb_impl,
    attrs = {
        "app": attr.label(providers = [[ApkInfo], [StarlarkApkInfo]], allow_files = True),
        "test_app": attr.label(providers = [[ApkInfo], [StarlarkApkInfo]], allow_files = True),
        "adb_exe_path_file": attr.label(allow_single_file = True),
        "aapt2_exe": attr.label(executable = True, cfg = "exec"),
        "_sh_script_template": attr.label(allow_single_file = True, default = Label(":run_ait_with_adb.sh"))
    },
)

def _get_signed_apk_path_from_info(ctx):
    print("ctx.attr: {}".format(ctx.attr))
    print("ctx.outputs.output: {}".format(ctx.outputs.output))

    apk_path = _get_apk_info(ctx.attr.apk).path
    ctx.actions.write(output = ctx.outputs.output, content = apk_path)


get_signed_apk_path_from_info = rule(
    implementation = _get_signed_apk_path_from_info,
    attrs = {
        "apk": attr.label(providers = [[ApkInfo], [StarlarkApkInfo]], allow_files = True),
        "output": attr.output(mandatory = True)
    }
)

def run_ait_with_adb_macro_macro(name, app, test_app, adb_tool, aapt2_tool):
    app_path_file = name + "_app_path.txt"
    test_app_path_file = name + "_test_app_path.txt"
    get_signed_apk_path_from_info(name = name + "_get_app_path", apk = app, output = app_path_file)
    get_signed_apk_path_from_info(name = name + "_get_test_app_path", apk = test_app, output = test_app_path_file)
    run_ait_sh = ":run_ait_with_adb.sh"
    native.genrule(
        name = name,
        outs = [name+"_script.sh"],
        srcs = [run_ait_sh, app_path_file, test_app_path_file],
        tools = [aapt2_tool],
        cmd = """
        app_path=$$(cat $(location {}))
        test_app_path=$$(cat $(location {}))
        aapt2_tool=$(location {})
        cat $(location {}) |
        sed "s@%%apk_path%%@$$app_path@g" |
        sed "s@%%test_apk_path%%@$$test_app_path@g" |
        sed "s@%%adb_tool_path%%@adb@g" |
        sed "s@%%appt2_tool_path%%@$$aapt2_tool@g" > $@
        """.format(app_path_file, test_app_path_file, aapt2_tool, run_ait_sh)
    )


def run_ait_with_adb_macro(name, app, test_app, adb_tool, aapt2_tool):
    print("run_ait_with_adb_macro, app: {}".format(app))
    print("run_ait_with_adb_macro, test_app: {}".format(test_app))
    print("run_ait_with_adb_macro, adb_tool: {}".format(adb_tool))
    print("run_ait_with_adb_macro, aapt2_tool: {}".format(aapt2_tool))
    adb_abs_path_file = name + "_adb_abs_path_file.txt"
    write_adb_abs_path_to_file_2(
        name+"_adb_abs_path_file", adb_tool = adb_tool, out = adb_abs_path_file)
    run_ait_with_adb(name = name, app = app, test_app = test_app, adb_exe_path_file = adb_abs_path_file, aapt2_exe = aapt2_tool)

def write_adb_abs_path_to_file_2(name, adb_tool, out):
    print("adb_tool_label: " + adb_tool)
    print("type(adb_tool_label): " + type(adb_tool))
    native.genrule(
        name = name,
        outs = [out],
        srcs = [],
        tools = [adb_tool],
        cmd = "$(location {}) --version 2>&1 | grep 'Installed as' | cut -d ' ' -f3 > $@".format(adb_tool),
    )

def my_gen_script_that_prints_version(name):
    native.genrule(
        name = name,
        outs = [name+"_gen.sh"],
        srcs = [],
        tools = ["@androidsdk//:platform-tools/adb"],
        executable = True,
        cmd = """
        echo "new_path=$(BINDIR)" >> $@
        echo "PATH=new_path" >> $@
        echo "$(location @androidsdk//:platform-tools/adb) --version" >> $@
        """
    )

def my_run_aapt_macro(name):
    native.genrule(
        name = name,
        outs = [name+"_out.txt"],
        srcs = [],
        tools = ["@androidsdk//:aapt2_binary"],
        cmd = "$(location @androidsdk//:aapt2_binary) version 2> $@",
    )

def my_run_adb_macro(name):
    native.genrule(
        name = name,
        outs = [name+"_out.txt"],
        srcs = [],
        tools = ["@androidsdk//:platform-tools/adb"],
        cmd = """
        echo "# $(location @androidsdk//:platform-tools/adb) --version" >> $@
        $(location @androidsdk//:platform-tools/adb) --version >> $@
        """,
    )

def make_appt2_version_executable(name):
    native.genrule(
        name = name,
        outs = [name+"_gen.sh"],
        srcs = [],
        tools = ["@androidsdk//:aapt2_binary"],
        cmd = "echo '$(location @androidsdk//:aapt2_binary) version' > $@",
        executable = True,
    )

def _my_run_adb_impl(ctx):
    pass

my_run_adb = rule(
    implementation = _my_run_adb_impl,
#    attrs = {
#            "test_app": attr.Label(),
#        },
)