import 'package:flutter/material.dart';
import 'package:thanos_snap_effect/thanos_snap_effect.dart';
import 'package:leader_company/features/domain/cart/entities/cart.dart';
import 'custom_product_in_cart.dart';

class SnappableCartItem extends StatefulWidget {
  final CartItem item;
  final int index;
  final Function(int) onDelete;
  final Function(int)? onQuantityChanged;
  final bool isFavorite;

  const SnappableCartItem({
    Key? key,
    required this.item,
    required this.index,
    required this.onDelete,
    this.onQuantityChanged,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<SnappableCartItem> createState() => _SnappableCartItemState();
}

class _SnappableCartItemState extends State<SnappableCartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isDeleting && mounted) {
        // Ensure we're mounted before calling callback
        widget.onDelete(widget.item.id);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDelete(int itemId) {
    setState(() {
      _isDeleting = true;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Snappable(
      key: ValueKey('cart_item_${widget.item.id}'),
      animation: _animationController,
      style: const SnappableStyle(
        particleLifetime: 0.8,
        fadeOutDuration: 0.4,
        particleSpeed: 1.0,
        particleSize: SnappableParticleSize.squareFromRelativeWidth(0.01),
      ),
      child: ProductItemInCart(
        item: widget.item,
        index: widget.index,
        onDelete: _handleDelete,
        isFavorite: widget.isFavorite,
        onQuantityChanged: widget.onQuantityChanged,
      ),
    );
  }
} 