package com.example.android.bazel;

public class JniLib {
  static {
    System.loadLibrary("app");
  }
  public native String stringFromJNI();
}