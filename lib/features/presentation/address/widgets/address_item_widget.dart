import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../domain/address/entities/address.dart';

class AddressItemWidget extends StatefulWidget {
  final Address address;
  final bool isSelectable;
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(int, Function(bool))? onSetDefault;
  final VoidCallback? onSelect;
  final int index;

  const AddressItemWidget({
    super.key,
    required this.address,
    this.isSelectable = false,
    this.showActions = true,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
    this.onSelect,
    required this.index,
  });

  @override
  State<AddressItemWidget> createState() => _AddressItemWidgetState();
}

class _AddressItemWidgetState extends State<AddressItemWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isSelectable ? widget.onSelect : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and default badge
            Row(
              children: [
                Text(
                  widget.address.title.isNotEmpty
                      ? widget.address.title
                      : 'address_number'.tr(context).replaceAll('{number}', '${widget.index + 1}'),
                  style: context.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _isLoading || widget.address.isDefault || widget.onSetDefault == null 
                      ? null 
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          widget.onSetDefault!(widget.address.id, (success) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.address.isDefault
                              ? const Color(0xFFE6F4FF)
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isLoading 
                      ? SizedBox(
                          width: 50,
                          height: 14,
                          child: Center(
                            child: SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          widget.address.isDefault ? 'default'.tr(context) : 'make_default'.tr(context),
                          style: context.bodySmall!.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight:
                                widget.address.isDefault ? FontWeight.w800 : FontWeight.w300,
                            fontSize: widget.address.isDefault ? 12 : 10,
                          ),
                        ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: widget.onEdit,
                  child: const Icon(
                    Icons.edit,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Address details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(widget.address.address, style: context.bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Location details
            Row(
              children: [
                const Icon(Icons.map, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${widget.address.cityName}, ${widget.address.stateName}, ${widget.address.countryName}'.tr(context),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                InkWell(
                  onTap: widget.onDelete,
                  child: const CustomImage(assetPath: AppSvgs.delete_icon),
                ),
              ],
            ),
            const Divider(color: AppTheme.lightDividerColor),

            // // Contact details
            // Row(
            //   children: [
            //     const Icon(Icons.phone, color: Colors.grey, size: 20),
            //     const SizedBox(width: 8),
            //     Text(address.phone, style: const TextStyle(fontSize: 14)),
            //   ],
            // ),

            // Action buttons

            // Select button for selectable mode
            // if (isSelectable && !showActions) ...[
            //   const SizedBox(height: 16),
            //   const Divider(),
            //   Center(
            //     child: ElevatedButton(
            //       onPressed: onSelect,
            //       style: ElevatedButton.styleFrom(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 24,
            //           vertical: 12,
            //         ),
            //       ),
            //       child: const Text('Use This Address'.tr(context)),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
