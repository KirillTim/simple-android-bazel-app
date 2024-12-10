#include <jni.h>
#include "jni_dep.h"

extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_android_bazel_JniLib_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    return env->NewStringUTF(sayHi("JNI user").c_str());
}