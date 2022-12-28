library image_input_field;

import 'package:flutter/material.dart';
import 'package:image_input_field/grid_layout.dart';
import 'image_editing_controller.dart';

enum ImageDisplay {
  horizontal,
  grid,
}

enum ImageType {
  file,
  network,
}

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ImageInputField<T> extends StatefulWidget {
  const ImageInputField({
    super.key,
    this.child,
    required this.controller,
    this.display = ImageDisplay.horizontal,
    this.maxCount = 10,
    this.deleteBuilder,
    required this.imageBuilder,
    required this.onNetworkImageDelete,
    this.gridRows = 3,
    this.rowGap = -10,
    this.columnGap = -200,
  });

  final Widget? child;
  final ImageEditingController controller;
  final ImageDisplay display;
  final int maxCount;
  final void Function(T) onNetworkImageDelete;
  final ItemWidgetBuilder<T>? deleteBuilder;
  final ItemWidgetBuilder<T> imageBuilder;
  final int gridRows;
  final double rowGap;
  final double columnGap;

  @override
  State<ImageInputField<T>> createState() => _ImageInputFieldState<T>();
}

class _ImageInputFieldState<T> extends State<ImageInputField<T>> {
  T? _selectedImage;
  void _onSelectImage(T url) => setState(() {
        if (_selectedImage == url) {
          _selectedImage = null;
        } else {
          _selectedImage = url;
        }
      });

  void _onDeleteFile(T image) => setState(() {
        widget.onNetworkImageDelete(image);
        widget.controller.removeImage(image);
      });
  @override
  Widget build(BuildContext context) {
    final items = widget.controller.value;
    return widget.display == ImageDisplay.horizontal
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                widget.child ?? const SizedBox(),
                for (var i = 0; i < items.length; i++)
                  // widget.imageType == ImageType.network
                  ImageTile<T>(
                    image: items[i],
                    onNetworkImageDelete: widget.onNetworkImageDelete,
                    onImageTap: () => _onSelectImage(
                      items[i],
                    ),
                    selectedImage: _selectedImage,
                    deleteBuilder: widget.deleteBuilder,
                    imageBuilder: widget.imageBuilder,
                    onDelete: (() => _onDeleteFile(items[i])),
                  )
                // : const SizedBox(),
              ],
            ),
          )
        : items.isNotEmpty
            ? Wrap(
                children: [
                  GridLayout(
                    rowsCount: widget.gridRows,
                    columnGap: widget.columnGap,
                    rowGap: widget.rowGap,
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final image = items[index];
                      return ImageTile<T>(
                        image: image,
                        onNetworkImageDelete: widget.onNetworkImageDelete,
                        onImageTap: () => _onSelectImage(
                          image,
                        ),
                        selectedImage: _selectedImage,
                        deleteBuilder: widget.deleteBuilder,
                        imageBuilder: widget.imageBuilder,
                        onDelete: (() => _onDeleteFile(image)),
                      );
                    },
                  )
                ],
              )
            : const SizedBox();
  }
}

class ImageTile<T> extends StatelessWidget {
  const ImageTile(
      {super.key,
      required this.image,
      required this.onNetworkImageDelete,
      required this.onImageTap,
      required this.selectedImage,
      this.deleteBuilder,
      required this.imageBuilder,
      required this.onDelete});
  final T image;
  final void Function(T) onNetworkImageDelete;
  final VoidCallback onImageTap;
  final T? selectedImage;
  final ItemWidgetBuilder<T>? deleteBuilder;
  final ItemWidgetBuilder<T> imageBuilder;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onImageTap,
        child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: imageBuilder(context, image),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: Visibility(
                visible: selectedImage != null && image == selectedImage,
                child: InkWell(
                  onTap: onDelete,
                  child: deleteBuilder != null
                      ? deleteBuilder!(context, image)
                      : defaultDelete(context, image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultDelete(context, image) => Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
            color: Colors.black45, borderRadius: BorderRadius.circular(100)),
        child: const Icon(
          Icons.close,
          size: 18,
          color: Colors.white,
        ),
      );
}
