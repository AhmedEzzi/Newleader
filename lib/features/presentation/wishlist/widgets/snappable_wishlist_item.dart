import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thanos_snap_effect/thanos_snap_effect.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/cutsom_toast.dart';
import 'package:leader_company/core/widgets/custom_confirmation_dialog.dart';
import 'package:leader_company/features/domain/wishlist/entities/wishlist_details.dart';
import 'package:provider/provider.dart';
import '../controller/wishlist_provider.dart';

class SnappableWishlistItem extends StatefulWidget {
  final Widget child;
  final String slug;

  const SnappableWishlistItem({
    Key? key,
    required this.child,
    required this.slug,
  }) : super(key: key);

  @override
  State<SnappableWishlistItem> createState() => SnappableWishlistItemState();
}

class SnappableWishlistItemState extends State<SnappableWishlistItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDeleting = false;
  bool _isCompleted = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isDeleting && !_isCompleted) {
        _isCompleted = true;
        final provider = context.read<WishlistProvider>();
        // Remove from wishlist immediately after animation completes for smooth UX
        provider.removeFromWishlist(widget.slug);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startSnap() {
    if (!_isDeleting) {
      setState(() {
        _isDeleting = true;
      });
      _animationController.forward();
      CustomToast.showToast(message: 'item_removed_from_wishlist'.tr(context), type: ToastType.success);
    }
  }


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Snappable(
          animation: _animationController,
          style: const SnappableStyle(
            particleLifetime: 0.8,
            fadeOutDuration: 0.4,
            particleSpeed: 1.0,
            particleSize: SnappableParticleSize.squareFromRelativeWidth(0.01),
          ),
          child: widget.child,
        ),
      ),
    );
  }
} 