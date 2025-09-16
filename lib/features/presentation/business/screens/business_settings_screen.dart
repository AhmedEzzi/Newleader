import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/business/entities/business_setting.dart';
import '../controller/business_provider.dart';

class BusinessSettingsScreen extends StatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch business settings when the screen loads
    Future.microtask(() {
      context.read<BusinessProvider>().fetchBusinessSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Settings'),
      ),
      body: Consumer<BusinessProvider>(
        builder: (context, provider, child) {
          if (provider.businessSettingsState == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.businessSettingsState == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchBusinessSettings(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.businessSettings.isEmpty) {
            return const Center(child: Text('No business settings found'));
          }

          return _buildSettingsList(provider);
        },
      ),
    );
  }

  Widget _buildSettingsList(BusinessProvider provider) {
    // Get the frequently accessed settings
    final commonSettings = [
      _buildSettingItem('Website Name', provider.websiteName),
      _buildSettingItem('Contact Phone', provider.contactPhone),
      _buildSettingItem('Contact Email', provider.contactEmail),
      _buildSettingItem('Base Color', provider.baseColor),
      _buildSettingItem('Guest Checkout', provider.guestCheckoutActive ? 'Enabled' : 'Disabled'),
      _buildSettingItem('Wallet System', provider.walletSystem ? 'Enabled' : 'Disabled'),
      _buildSettingItem('Coupon System', provider.couponSystem ? 'Enabled' : 'Disabled'),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Common Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...commonSettings,
            const SizedBox(height: 24),
            const Text(
              'All Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...provider.businessSettings.map((setting) => _buildSettingCard(setting)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(BusinessSetting setting) {
    String displayValue = '';
    
    if (setting.value == null) {
      displayValue = 'null';
    } else if (setting.value is List) {
      displayValue = 'List with ${(setting.value as List).length} items';
    } else if (setting.value is Map) {
      displayValue = 'Map with ${(setting.value as Map).length} items';
    } else {
      displayValue = setting.value.toString();
    }

    // Limit the length of the display value
    if (displayValue.length > 50) {
      displayValue = '${displayValue.substring(0, 47)}...';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              setting.type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(displayValue),
          ],
        ),
      ),
    );
  }
} 