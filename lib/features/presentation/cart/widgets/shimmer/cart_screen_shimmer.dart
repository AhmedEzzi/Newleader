import 'package:flutter/material.dart';
import 'cart_items_list_shimmer.dart';
import 'cart_cost_summary_shimmer.dart';
import 'checkout_button_shimmer.dart';

class CartScreenShimmer extends StatelessWidget {
  const CartScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [

          // Cart items list shimmer
          CartItemsListShimmer(),
          // Cost summary shimmer
          CartCostSummaryShimmer(),
          // Checkout button shimmer
          CheckoutButtonShimmer(),
        ],
      ),
    );
  }
}
