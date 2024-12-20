package com.example.android.bazel;

public class JniLib {
  static {
    System.loadLibrary("jni_lib");
  }
  public native String stringFromJNI();
}