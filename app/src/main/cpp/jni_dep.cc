#include "jni_dep.h"
#ifdef __ANDROID__
#include <android/log.h>
#endif

std::string sayHi(std::string name) {
  std::string msg = "Hi, " + name;
#ifdef __ANDROID__
  __android_log_write(ANDROID_LOG_DEBUG, "JNI_DEP", msg.c_str());
#endif
  return msg;
}