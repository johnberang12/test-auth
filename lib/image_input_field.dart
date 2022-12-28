// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_input_field/image_editing_controller.dart';

// class NetworkImageTile extends StatefulWidget {
//   const NetworkImageTile({
//     super.key,
//     required this.controller,
//     required this.imageUrl,
//     required this.imageHeight,
//     required this.imageWidth,
//     required this.onNetworkImageDelete,
//     required this.onSelectNetwork,
//     required this.selectedImage,
//   });
//   final String imageUrl;
//   final double imageHeight;
//   final double imageWidth;
//   final void Function(String) onNetworkImageDelete;
//   final ImageEditingController controller;
//   final VoidCallback onSelectNetwork;
//   final String? selectedImage;

//   @override
//   State<NetworkImageTile> createState() => _NetworkImageTileState();
// }

// class _NetworkImageTileState extends State<NetworkImageTile> {
//   Future<void> _onDelete(String url) async {
//     widget.onNetworkImageDelete(url);
//     widget.controller.removeImage(url);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final onImagePressed = ref.watch(imagePressedProvider.state).state;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: InkWell(
//         onTap: widget.onSelectNetwork,
//         child: Stack(
//           alignment: Alignment.topRight,
//           clipBehavior: Clip.none,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: SizedBox(
//                   height: widget.imageHeight,
//                   width: widget.imageWidth,
//                   child: CustomImage(imageUrl: widget.imageUrl, clipRRect: 6)),
//             ),
//             Positioned(
//               top: -10,
//               right: -10,
//               child: Visibility(
//                 visible: widget.selectedImage != null &&
//                     widget.imageUrl == widget.selectedImage,
//                 child: InkWell(
//                   onTap: () => _onDelete(widget.imageUrl),
//                   child: Container(
//                     height: 24,
//                     width: 24,
//                     decoration: BoxDecoration(
//                         color: Colors.black45,
//                         borderRadius: BorderRadius.circular(100)),
//                     child: const Icon(
//                       Icons.close,
//                       size: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FileImageTile extends StatefulWidget {
//   const FileImageTile({
//     Key? key,
//     required this.controller,
//     required this.file,
//     required this.height,
//     required this.width,
//     required this.onDeleteImageFile,
//     required this.onPressFile,
//     required this.selectedFile,
//   }) : super(key: key);
//   final File file;

//   final double height;
//   final double width;
//   final ImageEditingController controller;
//   final void Function() onDeleteImageFile;
//   final VoidCallback onPressFile;
//   final File? selectedFile;

//   @override
//   State<FileImageTile> createState() => _FileImageTileState();
// }

// class _FileImageTileState extends State<FileImageTile> {
//   // void _onDeleteItem(File file)
//   //    {widget.onDeleteImageFile();
//   //      widget.controller.removeImage(file);}

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: InkWell(
//         onTap: widget.onPressFile,
//         child: Stack(
//           alignment: Alignment.topRight,
//           clipBehavior: Clip.none,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Container(
//                 height: widget.height,
//                 width: widget.width,
//                 decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(6),
//                     image: DecorationImage(
//                       image: FileImage(
//                         widget.file,
//                       ),
//                       fit: BoxFit.cover,
//                     )),
//               ),
//             ),
//             Positioned(
//               top: -10,
//               right: -10,
//               child: Visibility(
//                 visible: widget.selectedFile != null &&
//                     widget.file == widget.selectedFile,
//                 child: InkWell(
//                   onTap: widget.onDeleteImageFile,
//                   child: Container(
//                     height: 24,
//                     width: 24,
//                     decoration: BoxDecoration(
//                         color: Colors.black45,
//                         borderRadius: BorderRadius.circular(100)),
//                     child: const Icon(
//                       Icons.close,
//                       size: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// final imagePressedProvider = StateProvider.autoDispose<bool>((ref) => false);

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
      {super.key, this.imageUrl, required this.clipRRect, this.emptyFillColor});
  final String? imageUrl;
  final double clipRRect;
  final Color? emptyFillColor;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final valid = imageUrl != null && imageUrl!.contains('https://');
    return valid
        ? ClipRRect(
            borderRadius: BorderRadius.circular(clipRRect),
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              height: height,
              errorWidget: ((context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(clipRRect),
                    child: Container(
                      color: emptyFillColor ?? Colors.grey[200],
                      height: height,
                      child: const Center(
                          child: Text(
                        'No image available',
                        textAlign: TextAlign.center,
                      )),
                    ),
                  )),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(clipRRect),
            child: Container(
              color: emptyFillColor ?? Colors.grey[200],
              height: height,
              child: const Center(
                  child: Text(
                'No image available',
                textAlign: TextAlign.center,
              )),
            ),
          );
  }
}

// class TakeImageButton extends ConsumerWidget {
//   const TakeImageButton({Key? key, required this.height, required this.width})
//       : super(key: key);
//   final double height;
//   final double width;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final cameraService = ref.watch(cameraRepositoryProvider);
//     return InkWell(
//       onTap: () {},

//       //  => showCupertinoModalPopup(
//       //     context: context,
//       //     builder: (context) => CameraActionSheet(
//       //           context: context,
//       //           onPressCamera: () =>
//       //               Navigator.of(context).pop(cameraService.selectCamera()),
//       //           onPressGallery: () => Navigator.of(context)
//       //               .pop(cameraService.selectGalleryImages()),
//       //         )),
//       highlightColor: Colors.amber,
//       child: Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(width: 1, color: Colors.grey[600]!)),
//           child: AspectRatio(
//             aspectRatio: 1.0,
//             child: Icon(
//               Icons.camera_alt_outlined,
//               size: 28,
//               color: Colors.grey[600],
//             ),
//           )),
//     );
//   }
// }
