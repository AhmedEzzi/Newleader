import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import '../../../domain/wallet/entities/wallet_transaction.dart';

class TransactionItem extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = _isPositiveAmount();
    final iconData = _getTransactionIcon();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Transaction Icon
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isPositive 
                    ? AppTheme.primaryColor.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Icon(
                iconData,
                color: isPositive ? AppTheme.primaryColor : Colors.grey[700],
                size: 22,
              ),
            ),
            const SizedBox(width: 16.0),
            
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.paymentMethod,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.0,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        transaction.date,
                        style: context.bodyLarge.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (transaction.approvalString != 'N/A') ...[
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: isPositive ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        transaction.approvalString,
                        style: context.bodySmall.copyWith(
                          color: isPositive ? Colors.green[700] : Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Amount
            Text(
              transaction.amount,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: _isPositiveAmount() ? Colors.green[700] : Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransactionIcon() {
    if (transaction.paymentMethod.toLowerCase().contains('club point')) {
      return Icons.card_giftcard;
    } else if (transaction.paymentMethod.toLowerCase().contains('refund')) {
      return Icons.replay;
    } else if (transaction.paymentMethod.toLowerCase().contains('order')) {
      return Icons.shopping_bag;
    } else {
      return Icons.account_balance_wallet;
    }
  }

  bool _isPositiveAmount() {
    return !transaction.amount.contains('-');
  }
} 