import 'package:store/FireBase/Models/images_model.dart';

class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? password;
  String? cPassword;
  ImagesModel? image;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.cPassword,
    this.image,
  });

  UserModel.formJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    cPassword = json['cPassword'];
    image = json['image'] != null ? ImagesModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['fullName'] = fullName;
    json['email'] = email;
    json['password'] = password;
    json['cPassword'] = cPassword;
    json['image'] = image != null ? image!.toJson() : null;
    return json;
  }
}
