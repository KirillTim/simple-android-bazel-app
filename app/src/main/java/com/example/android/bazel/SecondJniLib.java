package com.example.android.bazel;

public class SecondJniLib {
    static {
        System.loadLibrary("second_jni_lib");
    }
    public native String stringFromJNI();
}
