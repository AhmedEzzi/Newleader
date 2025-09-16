import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_assets.dart';

class CartAnimationOverlay extends StatefulWidget {
  const CartAnimationOverlay({super.key});

  @override
  State<CartAnimationOverlay> createState() => _CartAnimationOverlayState();
}

class _CartAnimationOverlayState extends State<CartAnimationOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _controller.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pop(); // Remove overlay after animation
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Lottie.asset(
            AppAnimations.successfullyCart,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// Helper method to show the cart animation overlay
void showCartAddedAnimation(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return const CartAnimationOverlay();
    },
  );
} 