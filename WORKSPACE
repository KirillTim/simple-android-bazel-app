load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

android_sdk_repository(
    name = "androidsdk",
)

http_archive(
    name = "robolectric",
    sha256 = "bea2aaad74171fa011e39937c2e8ba2f3885614b1364bccba9ecbb51c5acbde0",
    strip_prefix = "robolectric-bazel-4.14.1",
    urls = ["https://github.com/robolectric/robolectric-bazel/releases/download/4.14.1/robolectric-bazel-4.14.1.tar.gz"],
)

load("@robolectric//bazel:robolectric.bzl", "robolectric_repositories")

robolectric_repositories()

RULES_JVM_EXTERNAL_TAG = "6.6"
RULES_JVM_EXTERNAL_SHA = "3afe5195069bd379373528899c03a3072f568d33bd96fe037bd43b1f590535e7"

http_archive(
    name = "rules_jvm_external",
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    sha256 = RULES_JVM_EXTERNAL_SHA,
    url = "https://github.com/bazel-contrib/rules_jvm_external/releases/download/%s/rules_jvm_external-%s.tar.gz" % (RULES_JVM_EXTERNAL_TAG, RULES_JVM_EXTERNAL_TAG)
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "androidx.appcompat:appcompat:1.0.2",
        "androidx.test.ext:junit:1.1.0",
        "org.robolectric:robolectric:4.14.1",
        "org.assertj:assertj-core:3.12.1",
    ],
    repositories = [
        "https://maven.google.com",
        "https://repo1.maven.org/maven2",
    ],
)

http_archive(
    name = "rules_android_ndk",
    sha256 = "65aedff0cd728bee394f6fb8e65ba39c4c5efb11b29b766356922d4a74c623f5",
    strip_prefix = "rules_android_ndk-0.1.2",
    url = "https://github.com/bazelbuild/rules_android_ndk/releases/download/v0.1.2/rules_android_ndk-v0.1.2.tar.gz",
)

load("@rules_android_ndk//:rules.bzl", "android_ndk_repository")

android_ndk_repository(name = "androidndk")

register_toolchains("@androidndk//:all")
