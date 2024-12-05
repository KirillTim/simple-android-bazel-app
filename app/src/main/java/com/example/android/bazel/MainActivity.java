package com.example.android.bazel;

import android.os.Bundle;
import android.widget.TextView;
import android.app.Activity;

// it was AppCompatActivity
public class MainActivity extends Activity {

  // static {
  //     System.loadLibrary("app");
  // }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    // Example of a call to a native method
    TextView tv = (TextView) findViewById(R.id.sample_text);
    tv.setText("just a simple string, not from stringFromJNI()");
  }

  /**
   * A native method that is implemented by the 'native-lib' native library,
   * which is packaged with this application.
   */
  // public native String stringFromJNI();
}
