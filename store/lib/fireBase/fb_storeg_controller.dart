import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:store/FireBase/Models/images_model.dart';

class FbStorageController {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<ImagesModel> insertFiles(String path, File file) async {
    var data = await storage
        .ref()
        .child('$path/${DateTime.now().toString()}')
        .putFile(file);
    var link = await data.ref.getDownloadURL();
    var fullPth = data.ref.fullPath;
    //
    return ImagesModel(link: link, path: fullPth);
  }

  Future<void> delete(String path) async {
    await storage.ref().child(path).delete();
  }

  Future<ImagesModel> insertFile(String path, File file) async {
    var data = await storage
        .ref()
        .child('$path/${DateTime.now().toString()}')
        .putFile(file);
    var link = await data.ref.getDownloadURL();
    var fullPth = data.ref.fullPath;
    //
    return ImagesModel(link: link, path: fullPth);
  }
}
