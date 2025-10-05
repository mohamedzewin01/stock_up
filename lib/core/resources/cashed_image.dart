// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:qassimha/core/resources/color_manager.dart';
//
// import '../api/api_constants.dart';
//
// String getFileExtensionFromUrl(String url) {
//   List<String> parts = url.split('.');
//   String lastPart = parts.last;
//   List<String> extensionParts = lastPart.split('?');
//   String extension = extensionParts.first;
//   return extension;
// }
//
// class CustomImage extends StatelessWidget {
//   const CustomImage({
//     super.key,
//     required this.url,
//     this.height,
//     this.width,
//     this.sizeIndicator,
//     this.boxFit, this.loadingBuilder,
//   });
//
//   final String url;
//   final double? height;
//   final double? width;
//   final double? sizeIndicator;
//   final BoxFit? boxFit;
//   final Widget? loadingBuilder;
//
//   @override
//   Widget build(BuildContext context) {
//     // log('${ApiConstants.baseUrlImage}$url');
//     return getFileExtensionFromUrl(url) == 'svg'
//         ? SvgPicture.network(
//           Uri.encodeFull(
//             url.isNotEmpty ? '${ApiConstants.urlImage}$url' : '',
//           ),
//
//           fit: BoxFit.fill,
//           placeholderBuilder:
//               (context) => Center(
//                 child: SizedBox(
//                   width: sizeIndicator ?? 20,
//                   height: sizeIndicator ?? 20,
//
//                   child: const CircularProgressIndicator(
//                     color: ColorManager.primaryColor,
//                   ),
//                 ),
//               ),
//         )
//         : CachedNetworkImage(
//           height: height,
//           width: width ?? MediaQuery.sizeOf(context).width,
//           imageUrl: Uri.encodeFull(
//             url.isNotEmpty ? '${ApiConstants.urlImage}$url' : '',
//           ),
//           fit: boxFit ?? BoxFit.fill,
//
//           placeholder:
//               (context, url) => Skeletonizer(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: AspectRatio(
//                     aspectRatio: 1,
//                     child: Container(
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                         color: ColorManager.textPlaceholder.withAlpha(50),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           errorWidget:
//               (context, url, error) => const Center(child: Icon(Icons.error)),
//         );
//   }
// }
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:skeletonizer/skeletonizer.dart';


import '../api/api_constants.dart';
import 'color_manager.dart';

String getFileExtensionFromUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.path.contains('.')) return '';
  final parts = uri.path.split('.');
  return parts.last.split('?').first.toLowerCase();
}

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.sizeIndicator,
    this.boxFit,
    this.loadingBuilder,
    this.errorWidget,
  });

  final String url;
  final double? height;
  final double? width;
  final double? sizeIndicator;
  final BoxFit? boxFit;
  final Widget? loadingBuilder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final fullUrl = url.isNotEmpty ? '${ApiConstants.urlImage}$url' : '';

    if (getFileExtensionFromUrl(url) == 'svg') {
      return SvgPicture.network(
        Uri.encodeFull(fullUrl),
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.fill,
        placeholderBuilder: (context) => Center(
          child: SizedBox(
            width: sizeIndicator ?? 24,
            height: sizeIndicator ?? 24,
            child: const CircularProgressIndicator(
              color: ColorManager.primaryColor,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: Uri.encodeFull(fullUrl),
      height: height,
      width: width ?? MediaQuery.sizeOf(context).width,
      fit: boxFit ?? BoxFit.fill,
      placeholder: (context, url) =>
      loadingBuilder ??
          Skeletonizer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.textPlaceholder.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
      errorWidget: (context, url, error) =>
      errorWidget ??
          const Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
    );
  }
}
