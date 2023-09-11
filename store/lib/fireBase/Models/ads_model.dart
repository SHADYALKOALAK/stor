import 'package:store/FireBase/Models/images_model.dart';

class AdsModel {
  ImagesModel? image;
  String? titel;
  String? time;
  String? id;

  AdsModel({
    this.image,
    this.titel,
    this.time,
    this.id,
  });

  AdsModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? ImagesModel.fromJson(json['image']): null;
    titel = json['titel'];
    time = json['time'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['image'] = image?.toJson();
    json['titel'] = titel;
    json['time'] = time;
    json['id'] = id;
    return json;
  }
}
