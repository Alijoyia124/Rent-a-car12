import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<String> uploadImageAndGetUrl(File imageFile, String storagePath) async {
  try {
    Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);
    await storageReference.putFile(imageFile);
    return await storageReference.getDownloadURL();
  } catch (e) {
    print('Error uploading image: $e');
    return ''; // Return an empty string or handle the error accordingly
  }
}
