package com.asgl.s_timesheet_mobile

import android.content.Intent
import android.content.pm.ApplicationInfo
import android.os.Bundle
import androidx.annotation.NonNull;
import com.asgl.s_timesheet_mobile.fingerprint.FingerPrintHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    companion object {
        val CHANNEL_NAME: String = "com.asgl.s_timesheet_mobile"
        val GET_DATA: String = "com.asgl.s_timesheet_mobile.getDataOpenApp"
        val OPEN_APP: String = "com.asgl.s_timesheet_mobile.openOtherApp"
        val CHECK_APP_OPEN_LIST_OPEN: String = "com.asgl.s_timesheet_mobile.checkAppInstalled"
        val NEW_INTENT_DATA: String = "com.asgl.s_timesheet_mobile.new_intent_jwt"
        val FINGER_PRINT: String = "com.asgl.s_timesheet_mobile.fingerprints"
        //===========================================================//
        const val JWT = "jwt"
        const val PK_NAME = "pkName"
        const val PASSWORD = "password"
        const val USER_NAME = "userName"
    }

    var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initMethodChannel()
    }

    /**
     * Khởi tạo method channel
     * */
    private fun initMethodChannel() {
        methodChannel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler { call, result ->
            when {
                call.method == CHECK_APP_OPEN_LIST_OPEN -> getPgkNameInstalled(call, result)
                call.method == OPEN_APP -> openApp(call, result)
                call.method == GET_DATA -> getDataOnNewIntent(result)
                call.method == FINGER_PRINT -> authenticateWithFingerprint(call, result)
                else -> result.success("")
            }
        }
    }

    /**
     * Kiểm tra xem package đã được cài đặt hay chưa?
     * @param call
     * @see MethodCall
     * */
    private fun getPgkNameInstalled(call: MethodCall, result: MethodChannel.Result) {
        val listPackage: List<ApplicationInfo> = activity.packageManager.getInstalledApplications(0)
        var isHasPackageName = false
        listPackage.forEach {
            if (it.packageName == call.argument<String>("pkName")) isHasPackageName = true
        }
        result.success(isHasPackageName)
    }

    /**
     * Mở ứng dụng với package name
     * */
    private fun openApp(call: MethodCall, result: MethodChannel.Result) {
        val intentLaunchApp = packageManager?.getLaunchIntentForPackage(call.argument(PK_NAME)!!)?.apply {
            putExtra(JWT, call.argument<String>(JWT))
            putExtra(PASSWORD, call.argument<String>(PASSWORD))
            putExtra(USER_NAME, call.argument<String>(USER_NAME))
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        applicationContext?.startActivity(intentLaunchApp)
        result.success(true)
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

    }

    //Lấy dữ liệu JWT trong Intent nếu có
    private fun getDataOnNewIntent(result: MethodChannel.Result) {
        val intent = this.intent
        if (intent != null && intent.hasExtra(JWT) && intent.hasExtra(PASSWORD) && intent.hasExtra(USER_NAME)) {
            val jwt = intent.getStringExtra(JWT)
            val password = intent.getStringExtra(PASSWORD)
            val userName = intent.getStringExtra(USER_NAME)
            if (jwt == null || jwt == "" || password == null || password == "" || userName == null || userName == "") {
                result.success("")
            } else result.success(mapOf(JWT to jwt, PASSWORD to password, USER_NAME to userName))
        } else {
            result.success("")
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.hasExtra(JWT) && intent.hasExtra(PASSWORD) && intent.hasExtra(USER_NAME)) {
            val jwt = intent.getStringExtra(JWT)
            val password = intent.getStringExtra(PASSWORD)
            val userName = intent.getStringExtra(USER_NAME)
            if (jwt != null && jwt != "" && password != null && password != "" && userName != null && userName != "") {
                val mapData = mapOf(JWT to jwt, PASSWORD to password, USER_NAME to userName)
                methodChannel?.invokeMethod(NEW_INTENT_DATA, mapData)
            }
        }
    }

    //Xác thực vân tay
    private fun authenticateWithFingerprint(call: MethodCall, result: MethodChannel.Result) {
        val obligatoryCreateKey = call.argument<Boolean>("obligatoryCreateKey") ?: false
        result.success(true)
        val helper = FingerPrintHelper(this)
        helper.initFingerPrint(flutterEngine!!, obligatoryCreateKey = obligatoryCreateKey)
    }
}
