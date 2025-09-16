# Deep Linking Implementation Guide

This guide explains how deep linking works in the Leader Company app and how to test it.

## Overview

The app supports deep linking for product sharing, allowing users to share product links that open directly to the product detail screen when clicked.

## Supported URL Formats

### 1. HTTP/HTTPS URLs (App Links)
- `https://admin.leadercompany-eg.com/product/{slug}`
- `https://leadercompany-eg.com/product/{slug}`

### 2. Custom Scheme URLs
- `leadercompany://product/{slug}`

## Implementation Details

### Files Modified/Added

1. **`lib/core/utils/deep_link_helper.dart`** - New utility class for handling deep links
2. **`lib/main.dart`** - Updated deep link handler to use the helper
3. **`lib/features/presentation/product details/screens/product_screen.dart`** - Enhanced share functionality
4. **`ios/Runner/Info.plist`** - Added iOS app links configuration
5. **`android/app/src/main/AndroidManifest.xml`** - Already had Android configuration

### Key Features

- **Smart Link Generation**: Uses existing product link if available, otherwise generates a new one
- **Multiple URL Support**: Supports both HTTP and custom scheme URLs
- **Robust Parsing**: Handles various URL formats and edge cases
- **Cross-Platform**: Works on both iOS and Android

## How It Works

### 1. Sharing a Product
When a user taps the share icon on a product:
1. The app checks if the product has an existing link
2. If yes, uses that link; if no, generates a new one using the product slug
3. Shares the link using the system share sheet

### 2. Opening a Deep Link
When someone clicks a shared link:
1. The app receives the deep link
2. Extracts the product slug from the URL
3. Navigates to the product detail screen with the slug

## Testing

### Manual Testing

1. **Test Share Functionality**:
   - Open any product in the app
   - Tap the share icon
   - Share the link via any method (SMS, email, etc.)
   - Click the shared link to verify it opens the correct product

2. **Test Different URL Formats**:
   - Test with `https://admin.leadercompany-eg.com/product/{slug}`
   - Test with `leadercompany://product/{slug}`

### Automated Testing

Use the test function in `lib/core/utils/deep_link_test.dart`:

```dart
import 'package:leader_company/core/utils/deep_link_test.dart';

// Call this function to test deep linking
testDeepLinking();
```

### Testing URLs

You can test with these sample URLs:
- `https://admin.leadercompany-eg.com/product/sample-product`
- `leadercompany://product/sample-product`

## Configuration

### iOS Configuration
The app is configured to handle app links for:
- `admin.leadercompany-eg.com`
- `leadercompany-eg.com`

### Android Configuration
The app is configured to handle app links for:
- `admin.leadercompany-eg.com`
- `leadercompany-eg.com`
- Custom scheme: `leadercompany`

## Troubleshooting

### Common Issues

1. **Link doesn't open the app**:
   - Ensure the URL format is correct
   - Check if the app is installed
   - Verify the domain is configured in the app

2. **App opens but shows wrong product**:
   - Check if the slug is being extracted correctly
   - Verify the product exists in the app

3. **iOS specific issues**:
   - Ensure the associated domains are configured in Apple Developer Console
   - Check that the app links are properly set up

### Debug Information

The app logs deep link information to help with debugging:
- `Deep link received: {url}` - Shows the received URL
- `Navigating to product with slug: {slug}` - Shows the extracted slug
- `Invalid deep link format: {url}` - Shows invalid URLs

## Future Enhancements

Potential improvements for the deep linking system:

1. **Category Deep Links**: Support for category pages
2. **Search Deep Links**: Support for search results
3. **User Profile Deep Links**: Support for user profiles
4. **Analytics**: Track deep link usage
5. **Fallback Handling**: Better handling of invalid or expired links

## Security Considerations

- All deep links are validated before processing
- Only specific domains are allowed
- Product slugs are sanitized before use
- No sensitive data is exposed in URLs
