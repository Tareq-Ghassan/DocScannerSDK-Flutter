package com.docscanner.flutter

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.docscanner.sdk.DocScannerActivity
import com.docscanner.sdk.DocScannerSDK
import com.docscanner.sdk.ScanOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/**
 * Flutter → Android bridge.
 *
 * Launches native [DocScannerActivity] which owns the camera, white crop
 * rectangle, and crop-on-capture. This class does not implement any of that.
 */
class DocScannerSdkPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    PluginRegistry.ActivityResultListener,
    PluginRegistry.RequestPermissionsResultListener {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingResult: Result? = null
    private var pendingPermissionResult: Result? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "doc_scanner_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        binding.addActivityResultListener(this)
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding?.removeRequestPermissionsResultListener(this)
        activity = null
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        onDetachedFromActivityForConfigChanges()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getVersion" -> result.success(DocScannerSDK.VERSION)
            "hasCameraPermission" -> result.success(hasCameraPermission())
            "requestCameraPermission" -> requestCameraPermission(result)
            "scanDocument" -> launchScanner(call, result)
            else -> result.notImplemented()
        }
    }

    private fun hasCameraPermission(): Boolean {
        val act = activity ?: return false
        return ContextCompat.checkSelfPermission(act, Manifest.permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
    }

    private fun requestCameraPermission(result: Result) {
        val act = activity
        if (act == null) {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }
        if (hasCameraPermission()) {
            result.success(true)
            return
        }
        pendingPermissionResult = result
        ActivityCompat.requestPermissions(act, arrayOf(Manifest.permission.CAMERA), REQ_PERM)
    }

    private fun launchScanner(call: MethodCall, result: Result) {
        val act = activity
        if (act == null) {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }
        if (pendingResult != null) {
            result.error("BUSY", "A scan is already in progress", null)
            return
        }
        val options = ScanOptions(
            showCropOverlay = call.argument<Boolean>("showCropOverlay") ?: true,
            overlayBorderColor = call.argument<Int>("overlayBorderColor") ?: Color.WHITE,
            overlayBorderWidthDp = (call.argument<Number>("overlayBorderWidthDp")?.toFloat()) ?: 3f,
            overlayCornerRadiusDp = (call.argument<Number>("overlayCornerRadiusDp")?.toFloat()) ?: 12f,
            overlayMarginHorizontalDp = (call.argument<Number>("overlayMarginHorizontalDp")?.toFloat()) ?: 32f,
            overlayHeightDp = (call.argument<Number>("overlayHeightDp")?.toFloat()) ?: 220f,
            scanBothSides = call.argument<Boolean>("scanBothSides") ?: false,
            jpegQuality = call.argument<Int>("jpegQuality") ?: 95,
            flashEnabled = call.argument<Boolean>("flashEnabled") ?: false,
        )
        pendingResult = result
        act.startActivityForResult(DocScannerActivity.createIntent(act, options), REQ_SCAN)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQ_SCAN) return false
        val pending = pendingResult ?: return false
        pendingResult = null
        if (resultCode != Activity.RESULT_OK) {
            pending.success(
                mapOf(
                    "isSuccess" to false,
                    "errorMessage" to "User cancelled",
                    "frontImagePath" to null,
                    "backImagePath" to null,
                )
            )
            return true
        }
        pending.success(
            mapOf(
                "isSuccess" to true,
                "frontImagePath" to data?.getStringExtra(DocScannerSDK.EXTRA_FRONT_IMAGE_PATH),
                "backImagePath" to data?.getStringExtra(DocScannerSDK.EXTRA_BACK_IMAGE_PATH),
                "errorMessage" to null,
            )
        )
        return true
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode != REQ_PERM) return false
        val pending = pendingPermissionResult ?: return false
        pendingPermissionResult = null
        pending.success(
            grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
        )
        return true
    }

    companion object {
        private const val REQ_SCAN = 9911
        private const val REQ_PERM = 9912
    }
}
