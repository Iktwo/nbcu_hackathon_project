package com.azerothearth;

import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.io.ByteArrayOutputStream;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.Resources;
import android.util.Log;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Environment;
import android.os.Bundle;
import android.graphics.drawable.Drawable;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.app.WallpaperManager;
import android.provider.Settings;
import android.util.DisplayMetrics;
import android.view.View;
import android.content.pm.ResolveInfo;

public class MainActivity extends org.qtproject.qt5.android.bindings.QtActivity {
    private static final String TAG = MainActivity.class.getSimpleName();
    private static MainActivity m_instance;

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onStart() {
        super.onStart();
        m_instance = this;
    }

    @Override
    protected void onDestroy() {
        System.exit(0);
    }

    public static MainActivity getInstance() {
        return m_instance;
    }

    public MainActivity() {
        m_instance = this;
    }

    public static void shareImage() {
        Log.d(TAG, "shareImage jni");
        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND_MULTIPLE);
        ArrayList<Uri> imageUris = new ArrayList<Uri>();
        imageUris.add(Uri.parse("/sdcard/test.png"));
        shareIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, imageUris);
        shareIntent.setType("image/*");
        m_instance.startActivity(Intent.createChooser(shareIntent, "Share images to.."));
    }
}
