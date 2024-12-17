package com.example.android.bazel.test;

import androidx.test.runner.AndroidJUnit4;
import org.junit.Test;
import org.junit.runner.RunWith;
@RunWith(AndroidJUnit4.class)
public class SimpleInstrumentationTest {
    @Test
    public void fooTest() {}

    @Test
    public void barTest() {
        if (getClass() != null) {
            throw new IllegalStateException("WTF");
        }
    }
}