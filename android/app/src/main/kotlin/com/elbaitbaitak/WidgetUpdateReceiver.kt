package com.leadercompany

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log

/**
 * Receiver for widget update requests
 * This helps trigger widget updates when the app updates data
 */
class WidgetUpdateReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "WidgetUpdateReceiver"
        const val ACTION_UPDATE_WIDGET = "com.leadercompany.UPDATE_WIDGET"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_UPDATE_WIDGET) {
            Log.d(TAG, "Received widget update broadcast")
            
            // Delay slightly to ensure data is saved
            Handler(Looper.getMainLooper()).postDelayed({
                updateWidgets(context)
            }, 500)
        }
    }

    private fun updateWidgets(context: Context) {
        try {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(context, ProductWidgetProvider::class.java)
            )
            
            if (appWidgetIds.isNotEmpty()) {
                Log.d(TAG, "Updating ${appWidgetIds.size} widgets")
                
                // Create an explicit update intent
                val updateIntent = Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                updateIntent.component = ComponentName(context, ProductWidgetProvider::class.java)
                updateIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
                context.sendBroadcast(updateIntent)
            } else {
                Log.d(TAG, "No widgets found to update")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widgets: ${e.message}")
        }
    }
} 