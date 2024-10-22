import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';

class ImagePickerService {
  Future<Uint8List?> pickImage() async {
    final imageBytes = await ImagePickerWeb.getImageAsBytes();
    return imageBytes;
  }
}
