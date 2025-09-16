import 'package:flutter/material.dart';
import 'package:leader_company/core/services/background_status_service.dart';
import 'package:leader_company/core/services/status_check_service.dart';
import 'package:leader_company/core/services/notification_manager.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';

class BackgroundServiceTestScreen extends StatefulWidget {
  const BackgroundServiceTestScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundServiceTestScreen> createState() =>
      _BackgroundServiceTestScreenState();
}

class _BackgroundServiceTestScreenState
    extends State<BackgroundServiceTestScreen> {
  bool _isLoading = false;
  String _lastCheckTime = 'Never';
  String _lastStatus = 'Unknown';
  List<StatusUpdate> _recentUpdates = [];

  @override
  void initState() {
    super.initState();
    _loadStatusInfo();
  }

  /// Load current status information
  Future<void> _loadStatusInfo() async {
    setState(() => _isLoading = true);

    try {
      final lastCheck = await StatusCheckService.getLastCheckTime();
      final lastStatus = await StatusCheckService.getLastKnownStatus();

      setState(() {
        _lastCheckTime = lastCheck?.toString() ?? 'Never';
        _lastStatus = lastStatus ?? 'Unknown';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error loading status info: $e');
    }
  }

  /// Test manual status check
  Future<void> _testManualCheck() async {
    setState(() => _isLoading = true);

    try {
      final result = await StatusCheckService.checkForUpdates();

      if (result.hasUpdate && result.updates != null) {
        setState(() {
          _recentUpdates = result.updates!;
        });

        // Show notifications for updates
        if (result.updates!.length == 1) {
          await NotificationManager.showStatusUpdateNotification(
            result.updates!.first,
          );
        } else if (result.updates!.length > 1) {
          await NotificationManager.showMultipleUpdatesNotification(
            result.updates!,
          );
        }

        _showSuccess('Found ${result.updates!.length} status updates!');
      } else if (result.hasError) {
        _showError('Error: ${result.error}');
      } else {
        _showInfo('No status updates found');
      }

      await _loadStatusInfo();
    } catch (e) {
      _showError('Test failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Test simple notification
  Future<void> _testSimpleNotification() async {
    try {
      await NotificationManager.showSimpleStatusNotification('Test Status');
      _showSuccess('Test notification sent!');
    } catch (e) {
      _showError('Failed to send notification: $e');
    }
  }

  /// Start background service
  Future<void> _startBackgroundService() async {
    setState(() => _isLoading = true);

    try {
      await BackgroundStatusService.initialize();
      await BackgroundStatusService.setTaskStatus(true);
      _showSuccess('Background service started!');
    } catch (e) {
      _showError('Failed to start service: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Stop background service
  Future<void> _stopBackgroundService() async {
    setState(() => _isLoading = true);

    try {
      await BackgroundStatusService.cancelTask();
      await BackgroundStatusService.setTaskStatus(false);
      _showSuccess('Background service stopped!');
    } catch (e) {
      _showError('Failed to stop service: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Clear stored data
  Future<void> _clearStoredData() async {
    try {
      await StatusCheckService.clearStoredData();
      await _loadStatusInfo();
      _showSuccess('Stored data cleared!');
    } catch (e) {
      _showError('Failed to clear data: $e');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Service Test'.tr(context)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Information Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status Information'.tr(context),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              'Last Check Time'.tr(context),
                              _lastCheckTime,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Last Known Status'.tr(context),
                              _lastStatus,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Test Buttons
                    Text(
                      'Test Actions'.tr(context),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTestButton(
                      'Test Manual Status Check'.tr(context),
                      Icons.refresh,
                      _testManualCheck,
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      'Test Simple Notification'.tr(context),
                      Icons.notifications,
                      _testSimpleNotification,
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      'Start Background Service'.tr(context),
                      Icons.play_arrow,
                      _startBackgroundService,
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      'Stop Background Service'.tr(context),
                      Icons.stop,
                      _stopBackgroundService,
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      'Clear Stored Data'.tr(context),
                      Icons.clear,
                      _clearStoredData,
                      isDestructive: true,
                    ),

                    const SizedBox(height: 24),

                    // Recent Updates
                    if (_recentUpdates.isNotEmpty) ...[
                      Text(
                        'Recent Updates'.tr(context),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._recentUpdates.map(
                        (update) => Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.update,
                              color: AppTheme.primaryColor,
                            ),
                            title: Text('Order #${update.orderNumber}'),
                            subtitle: Text(update.statusChangeText),
                            trailing: Text(
                              '${update.timestamp.hour}:${update.timestamp.minute.toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildTestButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDestructive ? Colors.red : AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
