package com.marcokenata.stock_app

import com.algolia.search.model.APIKey
import com.algolia.search.model.ApplicationID
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val algoliaAdapter = AlgoliaAdapter(ApplicationID("BJ7UU4JCT2"), APIKey("f83d253a7ca0486adaef3b1183983cae"))

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.algolia/api").setMethodCallHandler { call, result ->
            algoliaAdapter.perform(call, result)
        }
    }
}
