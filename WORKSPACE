# We already have the same setup for 'rules_android', see 'MODULE.bazel' file,
# however, 'rules_jvm_external' don't support Android SDK being set by 'rules_android'.
# So we need to set it here as well.
android_sdk_repository(
    name = "androidsdk",
)

# Order for 'load' and 'setup' statements is important, do not change!
load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "androidx.test:runner:1.6.2",
        "junit:junit:4.13.2",
    ],
    repositories = [
        "https://maven.google.com",
        "https://repo1.maven.org/maven2",
    ],
)
