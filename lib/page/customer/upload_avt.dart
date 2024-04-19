import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageUploaderWidget extends StatefulWidget {
  final VoidCallback? onImageSelected;

  ImageUploaderWidget({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _ImageUploaderWidgetState createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  File? _imageFile;
  String? _imageUrl;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    // Upload image to Firebase Storage and get the URL
    if (_imageFile != null) {
      _imageUrl = await uploadImageToFirebaseStorage(_imageFile!);
      // Now you have the image URL, you can save it to Firestore or perform any other action
    }

    // Call the callback function if provided
    if (widget.onImageSelected != null) {
      widget.onImageSelected!();
    }
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images') // Change this to your folder name
        .child(
            '${DateTime.now().millisecondsSinceEpoch}.png'); // Use a unique filename

    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: _imageFile == null
              ? Text('No image selected.')
              : Image.file(
                  _imageFile!,
                  height: 200,
                ),
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: getImage,
            child: Text('Select Image'),
          ),
        ),
        SizedBox(height: 20),
        _imageUrl != null
            ? Center(
                child: Text(
                  'Image URL: $_imageUrl',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
      ],
    );
  }
}
