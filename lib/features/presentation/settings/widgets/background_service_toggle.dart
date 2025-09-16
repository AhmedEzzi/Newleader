import 'package:flutter/material.dart';
import 'package:leader_company/core/services/background_status_service.dart';
import 'package:leader_company/core/services/notification_manager.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';

class BackgroundServiceToggle extends StatefulWidget {
  const BackgroundServiceToggle({Key? key}) : super(key: key);

  @override
  State<BackgroundServiceToggle> createState() =>
      _BackgroundServiceToggleState();
}

class _BackgroundServiceToggleState extends State<BackgroundServiceToggle> {
  bool _isServiceEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  /// Check if background service is currently running
  Future<void> _checkServiceStatus() async {
    setState(() => _isLoading = true);

    try {
      final isRunning = await BackgroundStatusService.isTaskRunning();
      setState(() {
        _isServiceEnabled = isRunning;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error checking service status: $e');
    }
  }

  /// Toggle background service
  Future<void> _toggleService(bool enabled) async {
    setState(() => _isLoading = true);

    try {
      if (enabled) {
        // Start the service
        await BackgroundStatusService.initialize();
        await BackgroundStatusService.setTaskStatus(true);

        // Check notification permissions
        final hasPermission = await NotificationManager.requestPermissions();
        if (!hasPermission) {
          _showPermissionDialog();
          setState(() => _isServiceEnabled = false);
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Background status checking enabled'.tr(context)),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      } else {
        // Stop the service
        await BackgroundStatusService.cancelTask();
        await BackgroundStatusService.setTaskStatus(false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Background status checking disabled'.tr(context)),
            backgroundColor: Colors.orange,
          ),
        );
      }

      setState(() {
        _isServiceEnabled = enabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show permission dialog
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Notification Permission Required'.tr(context)),
            content: Text(
              'To receive status updates, please enable notifications in your device settings.'
                  .tr(context),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr(context)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // You can add logic to open app settings here
                },
                child: Text('Open Settings'.tr(context)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Background Status Updates'.tr(context),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Get notified when your order status changes, even when the app is closed.'
                            .tr(context),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Switch(
                    value: _isServiceEnabled,
                    onChanged: _toggleService,
                    activeColor: AppTheme.primaryColor,
                  ),
              ],
            ),
            if (_isServiceEnabled) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Status updates will be checked every 15 minutes.'.tr(
                          context,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
