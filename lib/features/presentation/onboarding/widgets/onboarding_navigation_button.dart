import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';

class OnboardingNavigationButton extends StatelessWidget {
  const OnboardingNavigationButton({
    super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  final bool isLastPage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: Icon(
        isLastPage ? Icons.check : Icons.arrow_forward,
        color: Colors.white,
      ),
    );
  }
}