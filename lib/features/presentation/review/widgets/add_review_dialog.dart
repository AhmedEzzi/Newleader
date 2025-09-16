import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/cutsom_toast.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/extension/translate_extension.dart';
import '../controller/reviews_provider.dart';

class AddReviewDialog extends StatefulWidget {
  final int productId;

  const AddReviewDialog({
    super.key,
    required this.productId,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final TextEditingController reviewController = TextEditingController();
  int rating = 0;
  bool isSubmitting = false;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAddReviewDialog();
    });
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'rate_this_product'.tr(context),
                          style: context.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Icon(
                              Icons.star,
                              color: index < rating ? Colors.amber : Colors.grey.shade200,
                              size: 30,
                            ),
                            onTap: () {
                              setState(() {
                                rating = index + 1;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'write_your_opinion_here'.tr(context),
                          hintStyle: context.bodyLarge!.copyWith(color: AppTheme.darkDividerColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: isSubmitting ? null : _submitReview,
                      text: 'submit'.tr(context),
                      fullWidth: true,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      text: 'cancel'.tr(context),
                      isOutlined: true,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitReview() async {
    if (rating <= 0 || reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_rate_and_review'.tr(context)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final success = await Provider.of<ReviewProvider>(context, listen: false)
          .submitNewReview(widget.productId, rating.toDouble(), reviewController.text);

      if (success) {
        Navigator.pop(context);
        Navigator.pop(context);
        CustomToast.showToast(message: 'review_submitted_successfully'.tr(context),type: ToastType.success);
      } else {
        CustomToast.showToast(message: 'failed_to_submit_review'.tr(context),type: ToastType.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The dialog is shown via _showAddReviewDialog in initState
    // This scaffold is just a container
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(),
    );
  }
}