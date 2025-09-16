import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_cached_image.dart';
import '../controller/profile_provider.dart';

class ProfileImagePickerWidget extends StatefulWidget {
  final ProfileProvider profileProvider;
  final Function(File?) onImageSelected;
  final File? selectedImage;

  const ProfileImagePickerWidget({
    super.key,
    required this.profileProvider,
    required this.onImageSelected,
    this.selectedImage,
  });

  @override
  State<ProfileImagePickerWidget> createState() => _ProfileImagePickerWidgetState();
}

class _ProfileImagePickerWidgetState extends State<ProfileImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                color: AppTheme.accentColor.withOpacity(0.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: widget.selectedImage != null
                    ? Image.file(
                  widget.selectedImage!,
                  fit: BoxFit.cover,
                )
                    : widget.profileProvider.profileImageUrl != null
                    ? CustomImage(
                  imageUrl:  widget.profileProvider.profileImageUrl!,
                  fit: BoxFit.cover,
                )
                    : const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _pickImage,
            child: Text(
              'change_photo'.tr(context),
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      widget.onImageSelected(File(image.path));
    }
  }
}