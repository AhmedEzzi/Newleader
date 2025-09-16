import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_appBar.dart';
import '../../../../core/utils/widgets/custom_back_button.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../controller/reviews_provider.dart';
import '../widgets/add_review_dialog.dart';
import '../widgets/review_card.dart';
import '../widgets/shimmer/review_shimmer.dart';

class AllReviewsScreen extends StatefulWidget {
  final int productId;

  const AllReviewsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Fetch reviews when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewProvider>(
        context,
        listen: false,
      ).fetchReviews(widget.productId);
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      Provider.of<ReviewProvider>(
        context,
        listen: false,
      ).loadMoreReviews(widget.productId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'all_reviews'.tr(context),
        leading: const CustomBackButton(),
        toolbarHeight: kToolbarHeight,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReviewDialog(),
        child: const Icon(Icons.rate_review),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        if (reviewProvider.reviewState == LoadingState.loading) {
          return const ReviewShimmer();
        }

        if (reviewProvider.reviewState == LoadingState.error) {
          return _buildErrorState(reviewProvider.reviewError);
        }

        if (reviewProvider.reviews.isEmpty) {
          return _buildEmptyState();
        }

        return _buildReviewsList(reviewProvider);
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('error_occurred'.tr(context)),
          const SizedBox(height: 8),
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Provider.of<ReviewProvider>(
                context,
                listen: false,
              ).fetchReviews(widget.productId);
            },
            child: Text('try_again'.tr(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'no_reviews_yet'.tr(context),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: _showAddReviewDialog,
            child: Text(
              'write_first_review'.tr(context),
              textAlign: TextAlign.center,
              style: context.titleMedium!.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(ReviewProvider reviewProvider) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          reviewProvider.reviews.length +
          (reviewProvider.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == reviewProvider.reviews.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomLoadingWidget(),
            ),
          );
        }

        final review = reviewProvider.reviews[index];
        return ReviewCard(review: review);
      },
    );
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(productId: widget.productId),
    );
  }
}
