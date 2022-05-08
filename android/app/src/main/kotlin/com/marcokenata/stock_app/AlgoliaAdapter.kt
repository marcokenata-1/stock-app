package com.marcokenata.stock_app

import android.util.Log
import com.algolia.search.client.ClientSearch
import com.algolia.search.helper.toIndexName
import com.algolia.search.model.APIKey
import com.algolia.search.model.ApplicationID
import com.algolia.search.model.IndexName
import com.algolia.search.model.response.ResponseSearch
import com.algolia.search.model.search.Query
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.json.Json
import java.lang.Exception

class AlgoliaAdapter(applicationID: ApplicationID, apiKey: APIKey) {

    val client = ClientSearch(applicationID, apiKey)

    suspend fun search(indexName: IndexName, query: Query, result: MethodChannel.Result){
        val index = client.initIndex(indexName)

        try {
            val search = index.search(query = query)
            result.success(Json.encodeToString(ResponseSearch.serializer(), search))
        } catch (e: Exception){
            result.error("AlgoliaNativeError", e.localizedMessage, e.cause)
        }
    }

    fun perform(call: MethodCall, result: MethodChannel.Result): Unit = runBlocking {
        Log.d("AlgoliaAPIAdapter", "method: ${call.method}")
        Log.d("AlgoliaAPIAdapter", "args: ${call.arguments}")
        val args = call.arguments as? List<String>
        if (args == null) {
            result.error("AlgoliaNativeError", "Missing arguments", null)
            return@runBlocking
        }

        when (call.method) {
            "search" -> search(indexName = args[0].toIndexName(), query = Query(args[1]), result = result)
            else -> result.notImplemented()
        }
    }

}