import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';

class CategoryCacheManager {
  // Keys for shared preferences
  static const String _categoriesKey = 'cached_categories';
  static const String _featuredCategoriesKey = 'cached_featured_categories';
  static const String _topCategoriesKey = 'cached_top_categories';
  static const String _filterPageCategoriesKey = 'cached_filter_page_categories';
  static const String _subCategoriesKeyPrefix = 'cached_sub_categories_';
  static const String _timestampSuffix = '_timestamp';

  // Cache duration (2 days in milliseconds)
  static const int cacheDuration = 2 * 24 * 60 * 60 * 1000; // 2 days

  // Save categories to cache
  static Future<void> saveCategories(CategoryResponseModel data, {String? parentId}) async {
    final prefs = await SharedPreferences.getInstance();
    String key = parentId != null ? '${_categoriesKey}_$parentId' : _categoriesKey;

    await prefs.setString(key, jsonEncode(data.toJson()));
    await prefs.setInt('$key$_timestampSuffix', DateTime.now().millisecondsSinceEpoch);
  }

  // Get categories from cache
  static Future<CategoryResponseModel?> getCategories({String? parentId}) async {
    final prefs = await SharedPreferences.getInstance();
    String key = parentId != null ? '${_categoriesKey}_$parentId' : _categoriesKey;

    final String? data = prefs.getString(key);
    final int? timestamp = prefs.getInt('$key$_timestampSuffix');

    if (data != null && timestamp != null && _isCacheValid(timestamp)) {
      return CategoryResponseModel.fromJson(jsonDecode(data));
    }

    return null;
  }

  // Save featured categories to cache
  static Future<void> saveFeaturedCategories(CategoryResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_featuredCategoriesKey, jsonEncode(data.toJson()));
    await prefs.setInt('$_featuredCategoriesKey$_timestampSuffix', DateTime.now().millisecondsSinceEpoch);
  }

  // Get featured categories from cache
  static Future<CategoryResponseModel?> getFeaturedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_featuredCategoriesKey);
    final int? timestamp = prefs.getInt('$_featuredCategoriesKey$_timestampSuffix');

    if (data != null && timestamp != null && _isCacheValid(timestamp)) {
      return CategoryResponseModel.fromJson(jsonDecode(data));
    }

    return null;
  }

  // Save top categories to cache
  static Future<void> saveTopCategories(CategoryResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_topCategoriesKey, jsonEncode(data.toJson()));
    await prefs.setInt('$_topCategoriesKey$_timestampSuffix', DateTime.now().millisecondsSinceEpoch);
  }

  // Get top categories from cache
  static Future<CategoryResponseModel?> getTopCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_topCategoriesKey);
    final int? timestamp = prefs.getInt('$_topCategoriesKey$_timestampSuffix');

    if (data != null && timestamp != null && _isCacheValid(timestamp)) {
      return CategoryResponseModel.fromJson(jsonDecode(data));
    }

    return null;
  }

  // Save filter page categories to cache
  static Future<void> saveFilterPageCategories(CategoryResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_filterPageCategoriesKey, jsonEncode(data.toJson()));
    await prefs.setInt('$_filterPageCategoriesKey$_timestampSuffix', DateTime.now().millisecondsSinceEpoch);
  }

  // Get filter page categories from cache
  static Future<CategoryResponseModel?> getFilterPageCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_filterPageCategoriesKey);
    final int? timestamp = prefs.getInt('$_filterPageCategoriesKey$_timestampSuffix');

    if (data != null && timestamp != null && _isCacheValid(timestamp)) {
      return CategoryResponseModel.fromJson(jsonDecode(data));
    }

    return null;
  }

  // Save sub categories to cache
  static Future<void> saveSubCategories(String mainCategoryId, CategoryResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = _subCategoriesKeyPrefix + mainCategoryId;

    await prefs.setString(key, jsonEncode(data.toJson()));
    await prefs.setInt('$key$_timestampSuffix', DateTime.now().millisecondsSinceEpoch);
  }

  // Get sub categories from cache
  static Future<CategoryResponseModel?> getSubCategories(String mainCategoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = _subCategoriesKeyPrefix + mainCategoryId;

    final String? data = prefs.getString(key);
    final int? timestamp = prefs.getInt('$key$_timestampSuffix');

    if (data != null && timestamp != null && _isCacheValid(timestamp)) {
      return CategoryResponseModel.fromJson(jsonDecode(data));
    }

    return null;
  }

  // Check if cache is still valid
  static bool _isCacheValid(int timestamp) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) < cacheDuration;
  }

  // Clear all category caches
  static Future<void> clearAllCategoryCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith('cached_')) {
        await prefs.remove(key);
      }
    }
  }
}