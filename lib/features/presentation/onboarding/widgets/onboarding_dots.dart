import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({
    super.key,
    required this.count,
    required this.currentPage,
  });

  final int count;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
            (index) => _buildDot(index: index),
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.black : Colors.black26,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}