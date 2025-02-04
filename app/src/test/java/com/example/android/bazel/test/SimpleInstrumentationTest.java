package com.example.android.bazel.test;

import static org.junit.Assert.assertNotNull;

import androidx.test.runner.AndroidJUnit4;
import org.junit.Test;
import org.junit.runner.RunWith;
@RunWith(AndroidJUnit4.class)
public class SimpleInstrumentationTest {
    @Test
    public void fooTest() {
        String message = new com.example.android.bazel.JniLib().stringFromJNI();
        System.out.println("SimpleInstrumentationTest, message: " + message);
        assertNotNull(message);
    }

    @Test
    public void barTest() {
        if (getClass() != null) {
            throw new IllegalStateException("WTF");
        }
    }
}