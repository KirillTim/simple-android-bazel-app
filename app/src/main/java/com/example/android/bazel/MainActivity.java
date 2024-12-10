package com.example.android.bazel;

import android.os.Bundle;
import android.widget.TextView;
import android.app.Activity;
import com.example.android.bazel.JniLib;

// it was AppCompatActivity
public class MainActivity extends Activity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    // Example of a call to a native method
    TextView tv = (TextView) findViewById(R.id.sample_text);
    // tv.setText("just a simple string, not from stringFromJNI()");
    String message = new JniLib().stringFromJNI();
    tv.setText("String from JNI: " + message);
  }

}
