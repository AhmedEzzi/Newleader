import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/domain/product/entities/product.dart';
import '../../features/presentation/home/controller/home_provider.dart';

// Keys for shared preferences
const String widgetProductsKey = 'widget_products';
const String currentProductIndexKey = 'current_product_index';

class WidgetService {
  static final WidgetService _instance = WidgetService._internal();

  factory WidgetService() => _instance;

  WidgetService._internal();

  // Initialize the widget service
  Future<void> initialize() async {
    // Initialize HomeWidget with your group ID (important for iOS)
    await HomeWidget.setAppGroupId('group.com.leadercompany.widget');
    
    // Register for widget clicks
    await registerInteractivity();
    
    // Initial widget update
    await updateWidgets();
  }

  // Update widget data from the home provider
  Future<void> updateWidgetDataFromProvider(HomeProvider homeProvider) async {
    try {
      final products = homeProvider.bestSellingProducts;
      if (products.isEmpty) {
        debugPrint('No best selling products available for widget');
        return;
      }

      debugPrint('Updating widget with ${products.length} products');
      await saveProductsForWidget(products);
      await updateWidgets();
    } catch (e) {
      debugPrint('Error updating widget data: $e');
    }
  }

  // Save product data to shared preferences for the widget
  Future<void> saveProductsForWidget(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert products to a simple format that can be easily serialized
      final widgetProducts = products.map((product) => {
        'id': product.id,
        'name': product.name,
        'image': product.thumbnailImage,
        'price': product.hasDiscount ? product.discountedPrice : product.mainPrice,
        // Include regular price if the product has a discount
        if (product.hasDiscount) 'regularPrice': product.mainPrice,
      }).toList();
 
      debugPrint('Widget product data: ${widgetProducts[0]}');
  
      // Save as JSON string
      await prefs.setString(widgetProductsKey, jsonEncode(widgetProducts));

      // Ensure we have a current index
      if (!prefs.containsKey(currentProductIndexKey)) {
        await prefs.setInt(currentProductIndexKey, 0);
      }

      debugPrint('Saved ${widgetProducts.length} products for widget');
    } catch (e) {
      debugPrint('Error saving products for widget: $e');
    }
  }

  // Update the widget with new data
  Future<void> updateWidgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getString(widgetProductsKey);
      final currentIndex = prefs.getInt(currentProductIndexKey) ?? 0;

      if (productsJson == null) {
        debugPrint('No product data found for widget');
        return;
      }

      final List<dynamic> products = jsonDecode(productsJson);
      if (products.isEmpty) {
        debugPrint('Empty product list for widget');
        return;
      }

      // Get the current product to display
      final currentProduct = products[currentIndex];

      // Calculate next index for rotation
      final nextIndex = (currentIndex + 1) % products.length;
      await prefs.setInt(currentProductIndexKey, nextIndex);

      // Update widgets on Android (iOS will be handled separately)
      if (Platform.isAndroid) {
        await _updateAndroidWidget(currentProduct);
      }

      debugPrint('Widget updated with product: ${currentProduct['name']}');
    } catch (e) {
      debugPrint('Error updating widgets: $e');
    }
  }

  // Update Android Widget
  Future<void> _updateAndroidWidget(Map<String, dynamic> product) async {
    try {
      final productKey = 'product_info';
      // Save the whole product data as JSON for better reliability
      final productJson = jsonEncode(product);
      await HomeWidget.saveWidgetData<String>(productKey, productJson);
      
      // Direct keys for Android widget
      final directData = <String, dynamic>{
        'product_id': product['id'].toString(),
        'product_name': product['name'],
        'product_image': product['image'],
        'product_price': product['price'].toString(),
        'product_has_discount': false,
      };
      
      // Save discount information if available
      if (product.containsKey('regularPrice') && 
          product['regularPrice'] != null && 
          product['regularPrice'].toString().isNotEmpty) {
        directData['product_regular_price'] = product['regularPrice'].toString();
        directData['product_has_discount'] = true;
      }

      // Log what we're saving
      debugPrint('Saving widget data: $directData');
      
      // Save all data
      for (final entry in directData.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (value is String) {
          await HomeWidget.saveWidgetData<String>(key, value);
        } else if (value is bool) {
          await HomeWidget.saveWidgetData<bool>(key, value);
        } else if (value is int) {
          await HomeWidget.saveWidgetData<int>(key, value);
        } else if (value is double) {
          await HomeWidget.saveWidgetData<double>(key, value);
        }
      }
      
      // Update the widget
      await HomeWidget.updateWidget(
        name: 'ProductWidgetProvider',
        androidName: 'ProductWidgetProvider',
      );
      
      // Also save data directly to shared preferences as a fallback
      await _saveToSharedPreferences(directData);
      
    } catch (e) {
      debugPrint('Error updating Android widget: $e');
    }
  }
  
  // Save data directly to shared preferences in multiple formats for reliability
  Future<void> _saveToSharedPreferences(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save to multiple locations to ensure the widget can find the data
      final locations = [
        '', // Direct key
        'flutter.', // Flutter prefix
      ];
      
      for (final prefix in locations) {
        for (final entry in data.entries) {
          final key = '$prefix${entry.key}';
          final value = entry.value;
          
          // Save based on type
          if (value is String) {
            await prefs.setString(key, value);
          } else if (value is bool) {
            await prefs.setBool(key, value);
          } else if (value is int) {
            await prefs.setInt(key, value);
          } else if (value is double) {
            await prefs.setDouble(key, value);
          } else {
            // Convert other types to string
            await prefs.setString(key, value.toString());
          }
        }
      }
      
      debugPrint('Saved all data to SharedPreferences');
      
      // Also save raw data to a special key for easier access
      final rawData = jsonEncode(data);
      await prefs.setString('widget_raw_data', rawData);
      await prefs.setString('flutter.widget_raw_data', rawData);
      
      // Also force a direct broadcast to update widgets
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: 'ProductWidgetProvider',
          androidName: 'ProductWidgetProvider',
        );
        
        // Force a direct update to any installed widgets
        try {
          // Use platform channel to force broadcast intent
          await HomeWidget.saveWidgetData<String>('widget_force_update', DateTime.now().toString());
          await HomeWidget.updateWidget(
            name: 'WidgetUpdateReceiver',
            androidName: 'WidgetUpdateReceiver',
            qualifiedAndroidName: 'com.melamine_elsherif.WidgetUpdateReceiver',
          );
        } catch (e) {
          debugPrint('Error forcing widget update: $e');
        }
      }
    } catch (e) {
      debugPrint('Error saving to SharedPreferences: $e');
    }
  }

  // Launch the app when widget is tapped
  Future<void> registerInteractivity() async {
    HomeWidget.widgetClicked.listen((uri) {
      // Handle the interaction
      debugPrint('Widget clicked with URI: $uri');
      // You can add navigation logic here if needed
    });
  }
}