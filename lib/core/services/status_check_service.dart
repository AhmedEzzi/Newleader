import 'dart:convert';
import 'package:leader_company/core/di/injection_container.dart';
import 'package:leader_company/core/api/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class StatusCheckService {
  static const String _lastStatusKey = 'last_checked_status';
  static const String _lastCheckTimeKey = 'last_check_time';

  /// Check for status updates
  static Future<StatusCheckResult> checkForUpdates() async {
    try {
      final apiProvider = sl<ApiProvider>();

      // Get user's orders or status endpoint
      final response = await apiProvider
          .get('/orders/status')
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        return _parseStatusResponse(data);
      } else {
        return StatusCheckResult(
          hasUpdate: false,
          error: 'API returned status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Status check error: $e');
      return StatusCheckResult(hasUpdate: false, error: e.toString());
    }
  }

  /// Parse API response to check for status updates
  static StatusCheckResult _parseStatusResponse(Map<String, dynamic> data) {
    try {
      if (data['success'] != true || data['data'] == null) {
        return StatusCheckResult(
          hasUpdate: false,
          error: 'Invalid API response format',
        );
      }

      final orders = data['data'] as List<dynamic>;
      bool hasUpdate = false;
      List<StatusUpdate> updates = [];

      for (final order in orders) {
        final orderId = order['id']?.toString();
        final currentStatus = order['status']?.toString();
        final orderNumber = order['order_number']?.toString() ?? 'Unknown';

        if (orderId != null && currentStatus != null) {
          // Check if this order has a status update
          final lastKnownStatus = _getLastKnownStatus(orderId);

          if (lastKnownStatus != currentStatus) {
            hasUpdate = true;
            updates.add(
              StatusUpdate(
                orderId: orderId,
                orderNumber: orderNumber,
                oldStatus: lastKnownStatus,
                newStatus: currentStatus,
                timestamp: DateTime.now(),
              ),
            );

            // Update stored status
            _updateStoredStatus(orderId, currentStatus);
          }
        }
      }

      return StatusCheckResult(
        hasUpdate: hasUpdate,
        updates: updates,
        lastCheckTime: DateTime.now(),
      );
    } catch (e) {
      return StatusCheckResult(
        hasUpdate: false,
        error: 'Error parsing response: $e',
      );
    }
  }

  /// Get last known status for an order
  static String? _getLastKnownStatus(String orderId) {
    // This would typically be stored in SharedPreferences or local database
    // For now, return null to indicate no previous status
    return null;
  }

  /// Update stored status for an order
  static Future<void> _updateStoredStatus(String orderId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('order_status_$orderId', status);
    await prefs.setString(_lastStatusKey, status);
    await prefs.setInt(
      _lastCheckTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get last check time
  static Future<DateTime?> getLastCheckTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastCheckTimeKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Get last known status
  static Future<String?> getLastKnownStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastStatusKey);
  }

  /// Clear stored status data
  static Future<void> clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastStatusKey);
    await prefs.remove(_lastCheckTimeKey);
  }
}

/// Result of status check
class StatusCheckResult {
  final bool hasUpdate;
  final List<StatusUpdate>? updates;
  final String? error;
  final DateTime? lastCheckTime;

  StatusCheckResult({
    required this.hasUpdate,
    this.updates,
    this.error,
    this.lastCheckTime,
  });

  bool get isSuccess => hasUpdate && error == null;
  bool get hasError => error != null;
}

/// Represents a status update
class StatusUpdate {
  final String orderId;
  final String orderNumber;
  final String? oldStatus;
  final String newStatus;
  final DateTime timestamp;

  StatusUpdate({
    required this.orderId,
    required this.orderNumber,
    this.oldStatus,
    required this.newStatus,
    required this.timestamp,
  });

  String get statusChangeText {
    if (oldStatus == null) {
      return 'Order #$orderNumber status: $newStatus';
    }
    return 'Order #$orderNumber status changed from $oldStatus to $newStatus';
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderNumber': orderNumber,
      'oldStatus': oldStatus,
      'newStatus': newStatus,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
