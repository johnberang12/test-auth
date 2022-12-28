import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageEditingController<T> extends StateNotifier<List<dynamic>> {
  ImageEditingController() : super([]);

  List get value => [...state];

  int get length => state.length;

  void addImage(T item) {
    state = [...state, item];
  }

  void addAllImages(List<T> items) {
    state = [...state, ...items];
  }

  void removeImage(T removeItem) {
    state = [
      for (final item in state)
        if (item != removeItem) item,
    ];
  }

  void clearAll() {
    state = [];
  }

  @override
  void dispose() {
    super.dispose();
  }
}
