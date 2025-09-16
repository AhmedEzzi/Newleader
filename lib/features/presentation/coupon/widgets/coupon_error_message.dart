import 'package:flutter/material.dart';

class CouponErrorMessage extends StatelessWidget {
  final String error;

  const CouponErrorMessage({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        error,
        style: TextStyle(color: Colors.red.shade800),
      ),
    );
  }
}