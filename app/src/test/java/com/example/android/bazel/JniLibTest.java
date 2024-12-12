package com.example.android.bazel;

import static org.assertj.core.api.Assertions.assertThat;

import androidx.test.ext.junit.runners.AndroidJUnit4;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;

/** Junit Test using Robolectric with AssertJ matchers. */
@RunWith(AndroidJUnit4.class)
public class JniLibTest {
  @Test
  public void testStringFromJNI() {
    String message = new JniLib().stringFromJNI();
    assertThat(message).isNotNull();
    //System.err.println("FOO BAR BAZ !!!");
    //ActivityController<MainActivity> controller = Robolectric.buildActivity(MainActivity.class);
    //Activity activity = controller.create().destroy().get();
    //if (activity != null) {
    //  throw new IllegalStateException("WTF");
    //}
    //assertThat(activity).isNotNull();
  }
}
