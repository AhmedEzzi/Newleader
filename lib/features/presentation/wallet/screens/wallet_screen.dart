import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../../club_point/controller/club_point_provider.dart';
import '../controller/wallet_provider.dart';
import '../widgets/transaction_item.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/shimmer/wallet_balance_shimmer.dart';
import '../widgets/shimmer/club_points_shimmer.dart';
import '../widgets/shimmer/transaction_item_shimmer.dart';
import '../widgets/shimmer/wallet_screen_shimmer.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    // Initial data loading
    Future.microtask(() {
      context.read<WalletProvider>().fetchWalletBalance();
      context.read<WalletProvider>().fetchWalletHistory();
      context.read<ClubPointProvider>().fetchClubPoints();
    });

    // Setup pagination scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.9) {
      _isLoadingMore = true;
      context.read<WalletProvider>().fetchWalletHistory().then((_) {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final isInitialLoading = (walletProvider.balanceState == LoadingState.loading ||
        walletProvider.historyState == LoadingState.loading) &&
        walletProvider.transactions.isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        leading: const CustomBackButton(),
        title: Text(
          'my_wallet'.tr(context),
          style: context.displaySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: () async {
          await context.read<WalletProvider>().refreshWallet();
          await context.read<ClubPointProvider>().fetchClubPoints(refresh: true);
        },
        child: isInitialLoading
            ? const WalletScreenShimmer()
            : CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _buildWalletBalance(),
            ),
            SliverToBoxAdapter(
              child: _buildClubPointsSection(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 12.0),
                child: Text(
                  'transaction_history'.tr(context),
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            _buildTransactionsList(),
            // Add some padding at the bottom
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletBalance() {
    return Consumer<WalletProvider>(
      builder: (context, provider, child) {
        switch (provider.balanceState) {
          case LoadingState.loading:
            return const WalletBalanceShimmer();
          case LoadingState.loaded:
            return provider.walletBalance != null
                ? WalletBalanceCard(
              balance: provider.walletBalance!.balance,
              lastRecharged: provider.walletBalance!.lastRecharged,
            )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'no_wallet_data_available'.tr(context),
                        style: context.titleMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  );
          case LoadingState.error:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${provider.errorMessage}',
                  style: context.titleMedium.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildClubPointsSection() {
    return Consumer<ClubPointProvider>(
      builder: (context, provider, child) {
        switch (provider.clubPointsState) {
          case LoadingState.loading:
            return const ClubPointsShimmer();
          case LoadingState.loaded:
            return Container(
              margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: const Icon(
                                Icons.card_giftcard,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              'your_club_points'.tr(context),
                              style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          provider.totalPoints,
                          style: context.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: provider.clubPoints.isEmpty
                            ? null
                            : () => _convertPointsToWallet(context, provider),
                        child: provider.convertState == LoadingState.loading
                            ? const CustomLoadingWidget()
                            : Text(
                                'convert_to_wallet'.tr(context),
                                textAlign: TextAlign.center,
                                style: context.titleLarge.copyWith(
                                  color: AppTheme.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          case LoadingState.error:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${provider.errorMessage}',
                  style: context.titleMedium.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildTransactionsList() {
    return Consumer<WalletProvider>(
      builder: (context, provider, child) {
        if (provider.historyState == LoadingState.loading && provider.transactions.isEmpty) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => const TransactionItemShimmer(),
              childCount: 5,
            ),
          );
        }

        if (provider.historyState == LoadingState.error && provider.transactions.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                'Error: ${provider.errorMessage}',
                style: context.titleMedium.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (provider.transactions.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 60,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'no_transactions_available'.tr(context),
                    style: context.titleMedium.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index < provider.transactions.length) {
                return TransactionItem(
                  transaction: provider.transactions[index],
                );
              } else if (provider.hasMoreTransactions) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: provider.historyState == LoadingState.loading
                        ? const CustomLoadingWidget()
                        : Text(
                            'no_more_transactions'.tr(context),
                            style: context.bodyLarge.copyWith(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
            childCount: provider.transactions.length + (provider.hasMoreTransactions ? 1 : 0),
          ),
        );
      },
    );
  }

  void _convertPointsToWallet(BuildContext context, ClubPointProvider provider) async {
    showCustomConfirmationDialog(
      context: context,
      title: 'convert_points'.tr(context),
      message: 'are_you_sure_you_want_to_convert_all_your_club_points_to_wallet_balance'.tr(context),
      confirmText: 'convert'.tr(context),
      cancelText: 'cancel'.tr(context),
      confirmButtonColor: AppTheme.primaryColor,
      icon: Icons.swap_horiz,
      onConfirm: () async {
        await provider.convertPointsToWallet();
        if (!context.mounted) return;
        if (provider.convertState == LoadingState.loaded) {
          // Refresh wallet data after conversion
          context.read<WalletProvider>().refreshWallet();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'success'.tr(context),
            text: 'points_successfully_converted_to_wallet!'.tr(context),
            confirmBtnColor: AppTheme.primaryColor,
          );
        }
      },
    );
  }
}