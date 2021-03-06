package com.freechers.userfront;

import android.location.LocationManager;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.PowerManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "merchant/getGPS";
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
              if (call.method.equals("getGPS")) {
                boolean deviceStatus = getGPS();

                String myMessage =  Boolean.toString(deviceStatus);
                result.success(myMessage);


              }

            });
  }
  private boolean getGPS() {
    LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
    boolean isGpsOn = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

    System.out.println("getgsp"+isGpsOn );
    return isGpsOn;

  }
}
