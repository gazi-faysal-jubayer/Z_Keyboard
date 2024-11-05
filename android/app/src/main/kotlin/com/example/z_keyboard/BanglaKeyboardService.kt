package com.example.z_keyboard

import android.inputmethodservice.InputMethodService
import android.view.View
import android.widget.LinearLayout
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class BanglaKeyboardService : InputMethodService() {
    private var flutterView: FlutterView? = null
    private var flutterEngine: FlutterEngine? = null
    private val CHANNEL = "bangla_keyboard/ime"

    override fun onCreate() {
        super.onCreate()
        initializeFlutterEngine()
    }

    private fun initializeFlutterEngine() {
        flutterEngine = FlutterEngine(this).apply {
            dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        }

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "commitText" -> {
                        val text = call.argument<String>("text") ?: ""
                        currentInputConnection?.commitText(text, 1)
                        result.success(null)
                    }
                    "deleteText" -> {
                        currentInputConnection?.deleteSurroundingText(1, 0)
                        result.success(null)
                    }
                    "performEnter" -> {
                        currentInputConnection?.commitText("\n", 1)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onCreateInputView(): View {
        flutterView = FlutterView(this).apply {
            attachToFlutterEngine(flutterEngine!!)
        }

        return LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            addView(flutterView)
        }
    }

    override fun onDestroy() {
        flutterEngine?.destroy()
        super.onDestroy()
    }
}