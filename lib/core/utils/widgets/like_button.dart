import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;
  final double size;
  final Color iconColor;

  const LikeButton({
    Key? key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 26.0, // Defaulted to original size
    required this.iconColor,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
        // Play the animation: pop out and in
        _controller.reverse().then((_) {
          if (mounted) { // Check if the widget is still in the tree
            _controller.forward();
          }
        });
      },
      child: ScaleTransition(
        scale: Tween(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: widget.size,
          color: widget.iconColor,
        ),
      ),
    );
  }
} 