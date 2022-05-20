package de.PascalReinmuth.smarthome;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterFragmentActivity;
import android.view.WindowManager.LayoutParams;

public class MainActivity extends FlutterFragmentActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(LayoutParams.FLAG_SECURE);
    }
}