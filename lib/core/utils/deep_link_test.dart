import 'deep_link_helper.dart';

/// Test function to verify deep linking functionality
/// This can be called from anywhere in the app for testing
void testDeepLinking() {
  print('=== Deep Link Testing ===');

  // Test 1: Generate share links
  final shareLinks = DeepLinkHelper.generateProductShareLinks(
    'test-product-123',
  );
  print('Generated share links:');
  print('HTTP: ${shareLinks['http']}');
  print('Custom: ${shareLinks['custom']}');
  print('Primary: ${shareLinks['primary']}');

  // Test 2: Extract slug from various URL formats
  final testUrls = [
    'https://admin.leadercompany-eg.com/product/test-product-123',
    'https://leadercompany-eg.com/product/test-product-456',
    'leadercompany://product/test-product-789',
    'https://admin.leadercompany-eg.com/product/test-product-123?param=value',
    'https://example.com/product/invalid', // Should return null
  ];

  print('\nTesting URL parsing:');
  for (final url in testUrls) {
    final slug = DeepLinkHelper.extractProductSlugFromUrl(url);
    final isValid = DeepLinkHelper.isValidProductLink(url);
    print('URL: $url');
    print('  Slug: $slug');
    print('  Valid: $isValid');
    print('');
  }

  // Test 3: Generate share link with existing link
  final existingLink =
      'https://admin.leadercompany-eg.com/product/existing-product';
  final generatedLink = DeepLinkHelper.generateProductShareLink(
    'fallback-slug',
    existingLink: existingLink,
  );
  print('Share link with existing: $generatedLink');

  // Test 4: Generate share link without existing link
  final fallbackLink = DeepLinkHelper.generateProductShareLink('fallback-slug');
  print('Share link fallback: $fallbackLink');

  print('=== End Testing ===');
}
