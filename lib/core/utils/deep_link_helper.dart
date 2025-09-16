import 'package:flutter/foundation.dart';

class DeepLinkHelper {
  // Base URLs for different link types
  static const String baseUrl = 'https://admin.leadercompany-eg.com';
  static const String customScheme = 'leadercompany';

  /// Generates a shareable deep link for a product
  /// Returns both HTTP and custom scheme URLs
  static Map<String, String> generateProductShareLinks(String slug) {
    final httpLink = '$baseUrl/product/$slug';
    final customLink = '$customScheme://product/$slug';

    return {
      'http': httpLink,
      'custom': customLink,
      'primary': httpLink, // Use HTTP as primary for better compatibility
    };
  }

  /// Generates a shareable deep link for a product with fallback
  /// Uses the product's existing link if available, otherwise generates one
  static String generateProductShareLink(String slug, {String? existingLink}) {
    // If existing link is provided and looks valid, use it
    if (existingLink != null &&
        existingLink.isNotEmpty &&
        (existingLink.startsWith('http') || existingLink.startsWith('https'))) {
      return existingLink;
    }

    // Otherwise generate a new one
    return generateProductShareLinks(slug)['primary']!;
  }

  /// Parses a deep link URL to extract the product slug
  static String? extractProductSlugFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Handle HTTP/HTTPS URLs
      if (uri.scheme.startsWith('http')) {
        if ((uri.host == 'admin.leadercompany-eg.com' ||
                uri.host == 'leadercompany-eg.com') &&
            uri.pathSegments.isNotEmpty &&
            uri.pathSegments.first == 'product') {
          return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        }
      }
      // Handle custom scheme URLs
      else if (uri.scheme == customScheme &&
          uri.host == 'product' &&
          uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.first;
      }
    } catch (e) {
      debugPrint('Error parsing URL: $e');
    }

    return null;
  }

  /// Validates if a URL is a valid product deep link
  static bool isValidProductLink(String url) {
    return extractProductSlugFromUrl(url) != null;
  }

  /// Creates a fallback web URL for sharing
  static String createWebFallbackUrl(String slug) {
    return '$baseUrl/product/$slug';
  }
}
