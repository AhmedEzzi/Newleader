# 🔄 Background Status Service Implementation

## 📋 Overview

This implementation provides a complete background service system that:
- ✅ Runs every 15 minutes to check for status updates
- ✅ Shows local notifications even when the app is closed
- ✅ Handles multiple order status updates
- ✅ Provides user controls to enable/disable the service
- ✅ Includes comprehensive testing tools

## 🏗️ Architecture

### Core Components:

1. **`BackgroundStatusService`** - Main service controller
2. **`StatusCheckService`** - API integration for status checking
3. **`NotificationManager`** - Local notification handling
4. **`BackgroundServiceToggle`** - UI widget for user control
5. **`BackgroundServiceTestScreen`** - Testing interface

## 📁 Files Created/Modified:

### New Files:
- ✅ `lib/core/services/background_status_service.dart`
- ✅ `lib/core/services/status_check_service.dart`
- ✅ `lib/core/services/notification_manager.dart`
- ✅ `lib/features/presentation/settings/widgets/background_service_toggle.dart`
- ✅ `lib/features/presentation/settings/screens/background_service_test_screen.dart`

### Modified Files:
- ✅ `lib/main.dart` - Added service initialization

## 🚀 How It Works:

### 1. **Service Initialization**
```dart
// In main.dart
await BackgroundStatusService.initialize();
await NotificationManager.initialize();
```

### 2. **Background Task Registration**
- Registers a periodic task that runs every 15 minutes
- Uses WorkManager for reliable background execution
- Handles network connectivity requirements

### 3. **Status Checking Process**
1. **API Call** - Checks `/orders/status` endpoint
2. **Status Comparison** - Compares with last known status
3. **Notification Trigger** - Shows notification if status changed
4. **Data Storage** - Updates stored status for future comparisons

### 4. **Notification System**
- **Single Update** - Shows individual order status change
- **Multiple Updates** - Shows summary of all changes
- **Rich Notifications** - Includes order numbers and status details
- **User Interaction** - Tappable notifications with payload data

## 🛠️ Configuration:

### API Endpoint Setup:
Update the API endpoint in `StatusCheckService`:
```dart
final response = await apiProvider.get('/orders/status');
```

### Notification Channel:
The service uses channel ID: `com.services.fixman`
- **Android**: High importance, sound, vibration
- **iOS**: Alert, badge, sound

### Background Task Constraints:
- **Network**: Requires internet connection
- **Battery**: Not restricted by low battery
- **Charging**: Not restricted by charging state
- **Frequency**: Every 15 minutes

## 📱 User Interface:

### Settings Toggle Widget:
```dart
BackgroundServiceToggle()
```
- Shows current service status
- Allows users to enable/disable the service
- Displays helpful information about the service

### Test Screen:
```dart
BackgroundServiceTestScreen()
```
- Manual status checking
- Notification testing
- Service control
- Status information display

## 🧪 Testing:

### Manual Testing:
1. **Open Test Screen** - Navigate to `BackgroundServiceTestScreen`
2. **Test Notifications** - Use "Test Simple Notification" button
3. **Test Status Check** - Use "Test Manual Status Check" button
4. **Test Service** - Start/stop background service

### Background Testing:
1. **Enable Service** - Use the toggle widget
2. **Close App** - Minimize or close the app
3. **Wait 15 Minutes** - Service will run automatically
4. **Check Notifications** - Look for status update notifications

## 🔧 Customization:

### Change Check Frequency:
```dart
// In BackgroundStatusService.initialize()
frequency: const Duration(minutes: 15), // Change this value
```

### Modify API Endpoint:
```dart
// In StatusCheckService.checkForUpdates()
final response = await apiProvider.get('/your-endpoint');
```

### Customize Notifications:
```dart
// In NotificationManager
const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  _channelId,
  _channelName,
  importance: Importance.max, // Modify importance
  priority: Priority.high,    // Modify priority
  // ... other settings
);
```

## 📊 Status Data Structure:

### Expected API Response:
```json
{
  "success": true,
  "data": [
    {
      "id": "123",
      "order_number": "ORD-001",
      "status": "shipped",
      "updated_at": "2024-01-01T12:00:00Z"
    }
  ]
}
```

### Status Update Object:
```dart
StatusUpdate(
  orderId: "123",
  orderNumber: "ORD-001",
  oldStatus: "pending",
  newStatus: "shipped",
  timestamp: DateTime.now(),
)
```

## 🚨 Troubleshooting:

### Common Issues:

1. **Service Not Running**
   - Check if WorkManager is properly initialized
   - Verify device battery optimization settings
   - Ensure app has necessary permissions

2. **No Notifications**
   - Check notification permissions
   - Verify notification channel is created
   - Test with manual notification button

3. **API Errors**
   - Check network connectivity
   - Verify API endpoint is correct
   - Check API response format

4. **Background Execution**
   - Android: Check battery optimization settings
   - iOS: Background App Refresh must be enabled
   - Both: App must not be force-stopped

### Debug Information:
The service logs detailed information:
- `🔄 Background task started`
- `📊 Status check - Last: X, Latest: Y`
- `✅ Status notification sent`
- `❌ Error messages`

## 🔒 Permissions Required:

### Android:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.VIBRATE" />
```

### iOS:
- Background App Refresh
- Notifications permission
- Background processing capability

## 🎯 Usage Examples:

### Enable Service:
```dart
await BackgroundStatusService.initialize();
await BackgroundStatusService.setTaskStatus(true);
```

### Disable Service:
```dart
await BackgroundStatusService.cancelTask();
await BackgroundStatusService.setTaskStatus(false);
```

### Check Service Status:
```dart
final isRunning = await BackgroundStatusService.isTaskRunning();
```

### Manual Status Check:
```dart
final result = await StatusCheckService.checkForUpdates();
if (result.hasUpdate) {
  // Handle updates
}
```

## 🚀 Ready to Use!

The background service is now fully implemented and ready to use. Users will receive notifications about order status updates every 15 minutes, even when the app is closed!

**Next Steps:**
1. Test the service using the test screen
2. Add the toggle widget to your settings screen
3. Customize the API endpoint for your backend
4. Deploy and monitor the service performance

