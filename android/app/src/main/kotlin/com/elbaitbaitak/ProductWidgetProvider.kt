package com.leadercompany

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent
import android.util.Log
import android.view.View
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.io.IOException
import java.net.URL

/**
 * Product Widget Provider for Android
 * Displays product information in a home screen widget
 */
class ProductWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "ProductWidgetProvider"
        private const val HOME_WIDGET_DATA_PREF = "home_widget"
        private const val FLUTTER_SHARED_PREFS = "FlutterSharedPreferences"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // Update all widgets
        Log.d(TAG, "onUpdate called for ${appWidgetIds.size} widgets")
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Called when an instance of the widget is created
        Log.d(TAG, "Widget provider enabled")
    }

    override fun onDisabled(context: Context) {
        // Called when the last instance of the widget is removed
        Log.d(TAG, "Widget provider disabled")
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        Log.d(TAG, "onReceive: ${intent.action}")
        
        // Handle custom actions if needed
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val appWidgetIds = intent.getIntArrayExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS)
            if (appWidgetIds != null && appWidgetIds.isNotEmpty()) {
                onUpdate(context, AppWidgetManager.getInstance(context), appWidgetIds)
            }
        }
    }

    /**
     * Update a single widget instance
     */
    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        try {
            // Create remote views for our widget layout
            val views = RemoteViews(context.packageName, R.layout.product_widget)
            
            // Try get raw data first (preferred method)
            val rawData = readRawWidgetData(context)
            
            if (rawData != null) {
                updateWidgetFromRawData(rawData, views, appWidgetManager, appWidgetId, context)
                return
            }
            
            // Fallback: Try multiple shared preference files to find our data
            var productId = ""
            var productName = ""
            var productImageUrl = ""
            var productPrice = ""
            var regularPrice = ""
            var hasDiscount = false
            
            // Check each possible shared preferences location
            val prefLocations = listOf(
                HOME_WIDGET_DATA_PREF,                      // home_widget default
                "home_widget_data",                         // alternative home_widget location
                "com.leadercompany.home_widget",        // app-specific home_widget
                FLUTTER_SHARED_PREFS                        // flutter shared prefs
            )
            
            for (prefName in prefLocations) {
                val prefs = context.getSharedPreferences(prefName, Context.MODE_PRIVATE)
                Log.d(TAG, "Checking SharedPreferences: $prefName")
                
                // Log all available keys in this preference file
                val allPrefs = prefs.all
                Log.d(TAG, "Keys in $prefName: ${allPrefs.keys.joinToString()}")
                
                // Try different key patterns based on the preference file
                val keyPrefixes = if (prefName == FLUTTER_SHARED_PREFS) listOf("flutter.") else listOf("", "flutter.")
                
                for (prefix in keyPrefixes) {
                    // Try to get product data with different key prefixes
                    val tempId = prefs.getString("${prefix}product_id", null)
                    val tempName = prefs.getString("${prefix}product_name", null)
                    val tempImage = prefs.getString("${prefix}product_image", null)
                    val tempPrice = prefs.getString("${prefix}product_price", null)
                    
                    // If we found valid data, use it
                    if (tempName != null && tempName.isNotEmpty()) {
                        productName = tempName
                        Log.d(TAG, "Found product name: $productName in $prefName with prefix '$prefix'")
                    }
                    
                    if (tempId != null && tempId.isNotEmpty()) {
                        productId = tempId
                    }
                    
                    if (tempImage != null && tempImage.isNotEmpty()) {
                        productImageUrl = tempImage
                    }
                    
                    if (tempPrice != null && tempPrice.isNotEmpty()) {
                        productPrice = tempPrice
                    }
                    
                    // Check for discount data
                    val tempRegularPrice = prefs.getString("${prefix}product_regular_price", null)
                    if (tempRegularPrice != null && tempRegularPrice.isNotEmpty()) {
                        regularPrice = tempRegularPrice
                        hasDiscount = true
                    } else {
                        hasDiscount = prefs.getBoolean("${prefix}product_has_discount", false)
                    }
                }
            }
            
            Log.d(TAG, "Final product data: id=$productId, name='$productName', price='$productPrice', image=$productImageUrl")
            
            // Set product name and price
            views.setTextViewText(R.id.widget_product_name, productName)
            views.setTextViewText(R.id.widget_product_price, productPrice)
            
            // Handle discount price display
            if (hasDiscount && regularPrice.isNotEmpty()) {
                views.setViewVisibility(R.id.widget_product_regular_price, View.VISIBLE)
                views.setTextViewText(R.id.widget_product_regular_price, regularPrice)
            } else {
                views.setViewVisibility(R.id.widget_product_regular_price, View.GONE)
            }
            
            // Load image asynchronously
            if (productImageUrl.isNotEmpty()) {
                loadProductImage(productImageUrl, views, appWidgetManager, appWidgetId, context)
            } else {
                // No image URL available, use placeholder
                views.setImageViewResource(R.id.widget_product_image, R.mipmap.launcher_icon)
            }
            
            // Create pending intent to open the app when widget is clicked
            val pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                context.packageManager.getLaunchIntentForPackage(context.packageName),
                pendingIntentFlags
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            
            // Update the widget immediately with text data (image will load asynchronously)
            appWidgetManager.updateAppWidget(appWidgetId, views)
            
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget: ${e.message}")
            e.printStackTrace()
        }
    }
    
    /**
     * Read raw widget data from various possible locations
     */
    private fun readRawWidgetData(context: Context): JSONObject? {
        try {
            // First try to get the product info directly
            val homeWidgetPrefs = context.getSharedPreferences(HOME_WIDGET_DATA_PREF, Context.MODE_PRIVATE)
            val productInfoJson = homeWidgetPrefs.getString("product_info", null)
            if (productInfoJson != null) {
                Log.d(TAG, "Found product_info: $productInfoJson")
                return JSONObject(productInfoJson)
            }
            
            // Try the raw data key
            val prefLocations = listOf(
                "home_widget_data",                         // alternative home_widget location 
                FLUTTER_SHARED_PREFS,                       // flutter shared prefs
                context.packageName                         // app-specific prefs
            )
            
            for (prefName in prefLocations) {
                val prefs = context.getSharedPreferences(prefName, Context.MODE_PRIVATE)
                
                // Try with and without flutter prefix
                val rawDataKeys = listOf("widget_raw_data", "flutter.widget_raw_data")
                for (key in rawDataKeys) {
                    val rawData = prefs.getString(key, null)
                    if (rawData != null) {
                        Log.d(TAG, "Found raw widget data in $prefName with key '$key': $rawData")
                        return JSONObject(rawData)
                    }
                }
            }
            
            return null
        } catch (e: Exception) {
            Log.e(TAG, "Error reading raw data: ${e.message}")
            return null
        }
    }
    
    /**
     * Update widget with product data from JSON
     */
    private fun updateWidgetFromRawData(
        data: JSONObject,
        views: RemoteViews,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        context: Context
    ) {
        try {
            // Extract product data
            val productName = data.optString("product_name", "Product")
            val productPrice = data.optString("product_price", "$0.00")
            val productImageUrl = data.optString("product_image", "")
            val hasDiscount = data.optBoolean("product_has_discount", false)
            val regularPrice = data.optString("product_regular_price", "")
            
            Log.d(TAG, "Raw data product: name='$productName', price='$productPrice', hasDiscount=$hasDiscount")
            
            // Set product name and price
            views.setTextViewText(R.id.widget_product_name, productName)
            views.setTextViewText(R.id.widget_product_price, productPrice)
            
            // Handle discount price display
            if (hasDiscount && regularPrice.isNotEmpty()) {
                views.setViewVisibility(R.id.widget_product_regular_price, View.VISIBLE)
                views.setTextViewText(R.id.widget_product_regular_price, regularPrice)
            } else {
                views.setViewVisibility(R.id.widget_product_regular_price, View.GONE)
            }
            
            // Load image asynchronously
            if (productImageUrl.isNotEmpty()) {
                loadProductImage(productImageUrl, views, appWidgetManager, appWidgetId, context)
            } else {
                // No image URL available, use placeholder
                views.setImageViewResource(R.id.widget_product_image, R.mipmap.launcher_icon)
            }
            
            // Create pending intent to open the app when widget is clicked
            val pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                context.packageManager.getLaunchIntentForPackage(context.packageName),
                pendingIntentFlags
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            
            // Update the widget immediately with text data (image will load asynchronously)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget from raw data: ${e.message}")
        }
    }
    
    /**
     * Helper method to load product image
     */
    private fun loadProductImage(
        imageUrl: String, 
        views: RemoteViews,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        context: Context
    ) {
        if (imageUrl.isNotEmpty()) {
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    Log.d(TAG, "Starting image download: $imageUrl")
                    val bitmap = loadImageFromUrl(imageUrl)
                    withContext(Dispatchers.Main) {
                        Log.d(TAG, "Image download complete, setting in widget")
                        views.setImageViewBitmap(R.id.widget_product_image, bitmap)
                        // Update the widget with the new image
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error loading image: ${e.message}")
                    withContext(Dispatchers.Main) {
                        // Set default image if loading fails
                        views.setImageViewResource(R.id.widget_product_image, R.mipmap.launcher_icon)
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                }
            }
        } else {
            // No image URL available, use placeholder
            views.setImageViewResource(R.id.widget_product_image, R.mipmap.launcher_icon)
        }
    }
    
    /**
     * Load image from URL
     */
    private suspend fun loadImageFromUrl(imageUrl: String): Bitmap = withContext(Dispatchers.IO) {
        try {
            Log.d(TAG, "Loading image from URL: $imageUrl")
            val url = URL(imageUrl)
            return@withContext BitmapFactory.decodeStream(url.openConnection().getInputStream())
        } catch (e: IOException) {
            Log.e(TAG, "Error loading image: ${e.message}")
            throw e
        }
    }
} 