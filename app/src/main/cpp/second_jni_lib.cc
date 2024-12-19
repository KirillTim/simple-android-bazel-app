#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_android_bazel_SecondJniLib_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    std::string msg = "Hi from second JNI Lib";
    return env->NewStringUTF(msg.c_str());
}