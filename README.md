To build an Apk do `bazelisk build //app/src/main:app  --android_platforms=//:arm64-v8a,//:x86`.

To run:
```
adb install bazel-bin/app/src/main/app.apk
adb shell am start -n com.example.android.bazel/com.example.android.bazel.MainActivity
```

use bazel version 7.4.1, won't work with fresh 8.0.
