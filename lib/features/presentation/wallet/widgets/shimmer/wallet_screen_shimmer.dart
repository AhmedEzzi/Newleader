import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'wallet_balance_shimmer.dart';
import 'club_points_shimmer.dart';
import 'transaction_item_shimmer.dart';

class WalletScreenShimmer extends StatelessWidget {
  const WalletScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Shimmer
              const WalletBalanceShimmer(),
              
              // Club Points Shimmer
              const ClubPointsShimmer(),
              
              // Transaction History Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 12.0),
                child: Shimmer.fromColors(
                  baseColor: AppTheme.primaryColor.withOpacity(0.1),
                  highlightColor: AppTheme.primaryColor.withOpacity(0.05),
                  child: Container(
                    width: 180,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Transaction List Shimmer
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const TransactionItemShimmer(),
            childCount: 5, // Show 5 transaction items
          ),
        ),
        
        // Add some bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }
} 