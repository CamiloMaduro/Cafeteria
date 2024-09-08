import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImageFromCamera() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile == null) {
    throw Exception('No image taken');
  }

  File imageFile = File(pickedFile.path);

  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref =
      storage.ref().child('images/${DateTime.now().toIso8601String()}');

  UploadTask uploadTask = ref.putFile(imageFile);
  TaskSnapshot snapshot = await uploadTask;

  String imageUrl = await snapshot.ref.getDownloadURL();
  return imageUrl;
}
