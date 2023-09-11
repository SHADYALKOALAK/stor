import 'package:store/FireBase/Models/images_model.dart';

class CategoryModel {
  String? id;
  String? name;
  ImagesModel? image;

  CategoryModel({
    this.id,
    this.name,
    this.image,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? ImagesModel.fromJson(json['image']) : null;
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['image'] = image?.toJson();
    json['id'] = id;
    json['name'] = name;
    return json;
  }
}
