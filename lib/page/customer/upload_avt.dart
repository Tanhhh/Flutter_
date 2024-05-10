import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUploaderWidget extends StatefulWidget {
  final VoidCallback? onImageSelected;

  ImageUploaderWidget({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _ImageUploaderWidgetState createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  final picker = ImagePicker();
  String? userId = UserRepository().getUserAuth()?.uid;
  String? imagePath;

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    } else {
      print('No image selected.');
    }

    if (widget.onImageSelected != null) {
      widget.onImageSelected!();
    }
  }

  Future<void> uploadImage() async {
    if (imagePath != null) {
      await uploadImageToFirebaseStorage(userId!, imagePath!);
      setState(() {
        imagePath = null;
      });
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/profile');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lưu thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<void> uploadImageToFirebaseStorage(
      String documentId, String imagePath) async {
    try {
      String storagePath = 'customers_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      final imageName = 'image.png';

      // Tải hình ảnh từ URL
      final http.Response response = await http.get(Uri.parse(imagePath));
      if (response.statusCode == 200) {
        // Lấy dữ liệu hình ảnh từ phản hồi HTTP
        final List<int> imageData = response.bodyBytes;

        // Tạo Uint8List từ dữ liệu hình ảnh
        final Uint8List uint8ImageData = Uint8List.fromList(imageData);

        // Tạo metadata cho hình ảnh
        final metadata =
            firebase_storage.SettableMetadata(contentType: 'image/png');

        // Tạo upload task và tải lên Firebase Storage
        await ref.child(imageName).putData(uint8ImageData, metadata);

        print('Uploaded $imageName');
      } else {
        print('Failed to load image from URL: $imagePath');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        if (imagePath == null)
          Center(
            child: ElevatedButton(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6342E8), // Màu nút
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.zero, // Hình dạng hình chữ nhật không bo góc
                ),
              ),
              child: Text(
                'Chọn ảnh',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        SizedBox(height: 20),
        if (imagePath != null)
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:
                      CachedNetworkImageProvider(imagePath!), // Sửa đổi ở đây
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        SizedBox(height: 20),
        if (imagePath != null)
          Center(
            child: ElevatedButton(
              onPressed: uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6342E8), // Màu nút
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.zero, // Hình dạng hình chữ nhật không bo góc
                ),
              ),
              child: Text(
                'Cập nhật',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
