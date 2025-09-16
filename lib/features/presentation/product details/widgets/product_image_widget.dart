import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import 'package:leader_company/features/presentation/product%20details/controller/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/utils/widgets/custom_image_view.dart';

class ProductImageWidget extends StatefulWidget {
  final ProductDetails product;
  final double height;

  const ProductImageWidget({
    super.key,
    required this.product,
    required this.height,
  });

  @override
  State<ProductImageWidget> createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        // Update page controller to show correct variant image when changed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients &&
              _pageController.page?.round() != provider.currentPhotoIndex) {
            _pageController.animateToPage(
              provider.currentPhotoIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        return FadeIn(
          duration: const Duration(milliseconds: 800),
          child: Stack(
            children: [
              // Main image carousel
              SlideInDown(
                duration: const Duration(milliseconds: 800),
                from: 30,
                child: SizedBox(
                  height: widget.height,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.product.photos.length,
                    onPageChanged: (index) {
                      provider.currentPhotoIndex = index;
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => _openGallery(context, provider),
                        child: CustomImage(
                          imageUrl: widget.product.photos[index].path,
                          fit: BoxFit.cover,
                          height: widget.height,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Dots indicator positioning at bottom of image
              if (widget.product.photos.length > 1)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 800),
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.product.photos.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Colors.white.withOpacity(0.8),
                          spacing: 8,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          provider.currentPhotoIndex = index;
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _openGallery(BuildContext context, ProductDetailsProvider provider) {
    // Convert the Photo objects to URL strings for the GalleryImagePreview
    final List<String> imageUrls = widget.product.photos.map((photo) => photo.path).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImagePreview(
          imageUrls: imageUrls,
          initialIndex: provider.currentPhotoIndex,
        ),
      ),
    );
  }
}