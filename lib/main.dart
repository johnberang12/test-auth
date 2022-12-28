// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_auth/firebase_initializer.dart';
import 'package:test_auth/landing_page.dart';

//* this app is linked to test app and test auth firebase projects
//* it is used for data base testing purposes

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(firebaseInitializerFutureProvider.future);

  // await Firebase.initializeApp(

  //   options: TestAppFirebaseOptions.currentPlatform,
  // );
  // await Firebase.initializeApp(

  //   options: TestAuthFirebaseOptions.currentPlatform
  //   );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(documentIdFromCurrentDate());
    return const MaterialApp(
      home: LandingPage(),
    );
  }
}

class ImageClassificationScreen extends StatefulWidget {
  const ImageClassificationScreen({super.key});

  @override
  State<ImageClassificationScreen> createState() =>
      _ImageClassificationScreenState();
}

class _ImageClassificationScreenState extends State<ImageClassificationScreen> {
  static String labels() => 'assets/ml/image_classification/labels.txt';
  static String model() => 'assets/ml/image_classification/mobilenet.tflite';
  String selectedUrl = '';
  Uint8List? _byteUint8;
  bool _loading = false;
  final String _prediction = 'Error';
  List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/muraita-market.appspot.com/o/products%2F2022-11-15T10:52:56.743271%2F4721.jpg?alt=media&token=dedd7c3c-a5f4-4a76-970f-6e84fd85eb0d',
    'https://firebasestorage.googleapis.com/v0/b/muraita-market.appspot.com/o/products%2F2022-11-15T10:52:56.743271%2F198.jpg?alt=media&token=5f78def6-78a4-4717-a5ed-d4812e32d0d8',
    'https://firebasestorage.googleapis.com/v0/b/muraita-market.appspot.com/o/products%2F2022-11-15T10:52:56.743271%2F164.jpg?alt=media&token=2640ea46-d8b9-49ed-93ef-589dbd42789f',
    'https://firebasestorage.googleapis.com/v0/b/muraita-market.appspot.com/o/products%2F2022-11-15T10:52:56.743271%2F3513.jpg?alt=media&token=b1ed9651-4d8d-4afd-bb6e-03acb191b4d1',
  ];

  @override
  void initState() {
    super.initState();
    selectedUrl = images[1];
    _loading = true;
  }

  // Future<void> _startPrediction() async {
  //   final success = await _loadModel();
  //   if (success) {
  //     _recognizeImage();
  //   } else {
  //     print('Failed to load model...');
  //   }
  // }

  // Future<img.Image?> urlToImage(String url) async {
  //   try {
  //     final client = HttpClient();
  //     final request = await client.getUrl(Uri.parse(url));
  //     final response = await request.close();
  //     if (response.statusCode == 200) {
  //       final bytes = await response.toList();
  //       final data = Uint8List.fromList(bytes.expand((e) => e).toList());
  //       return img.decodeImage(data);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return null;
  // }

  // Future<bool> _loadModel() async {
  //   try {
  //     final res = await Tflite.loadModel(
  //       model: model(),
  //       labels: labels(),
  //     );
  //     if (res == 'success') {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<void> urlToByteListUint8(String url) async {
  //   final uri = Uri.parse(url);
  //   final http.Response response = await http.get(uri);
  //   if (response.statusCode == 200) {
  //     final result = response.bodyBytes;

  //     _byteUint8 = result;
  //     if (mounted) {
  //       setState(() {});
  //       _recognizeImage();
  //     }
  //   } else {
  //     if (mounted) {
  //       setState(() => _loading = false);
  //     }
  //   }
  // }

  // img.Image _resizeImage(img.Image sneakerImage) {
  //   sneakerImage = img.grayscale(sneakerImage);
  //   sneakerImage = img.copyResize(sneakerImage,
  //       width: 224, height: 224, interpolation: img.Interpolation.nearest);
  //   return sneakerImage;
  // }

  // Uint8List grayscaleToByteListFloat32(img.Image image, int inputSize) {
  //   var convertedBytes = Float32List(inputSize * inputSize);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       var pixel = image.getPixel(j, i);
  //       buffer[pixelIndex++] = img.getLuminance(pixel) / 255.0;
  //     }
  //   }
  //   return convertedBytes.buffer.asUint8List();
  // }

  // Future<void> _recognizeImage() async {
  //   print('recognizing image...');
  //   try {
  //     final image = await urlToImage(selectedUrl);

  //     if (image != null) {
  //       final resizedImage = _resizeImage(image);
  //       final recognition = await Tflite.runModelOnBinary(
  //           binary: grayscaleToByteListFloat32(resizedImage, 224));
  //       if (recognition != null) {
  //         for (var i = 0; i < recognition.length; i++) {
  //           print('label: ${recognition[i]}');
  //         }
  //       }
  //     }

  //     setState(() => _loading = false);
  //   } catch (e, st) {
  //     print('error: ${e.toString()}');
  //     print('stack trace: ${st.toString()}');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image recognition')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    color: _loading ? Colors.grey[100] : null,
                    image: _byteUint8 != null
                        ? DecorationImage(image: MemoryImage(_byteUint8!))
                        : null),
                child: _loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : null),
            const SizedBox(
              height: 16,
            ),
            Text(_loading ? 'Detecting...' : _prediction)
          ],
        ),
      ),
    );
  }
}
