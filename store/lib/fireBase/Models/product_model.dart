import 'package:store/FireBase/Models/images_model.dart';

class ProductModel {
  String? id;
  String? titel;
  String? price;
  String? oldPrice;
  String? offer;
  String? description;
  String? idCategory;
  String? isCategory;
  int? count;
  List<dynamic>? images;

  ProductModel({
    this.id,
    this.titel,
    this.price,
    this.oldPrice,
    this.offer,
    this.description,
    this.idCategory,
    this.count,
    this.isCategory,
    this.images,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titel = json['titel'];
    price = json['price'];
    oldPrice = json['oldPrice'];
    description = json['description'];
    offer = json['offer'];
    idCategory = json['idCategory'];
    isCategory = json['isCategory'];
    count = json['count'];
    images = (json['images']).map((e) => ImagesModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['titel'] = titel;
    json['price'] = price;
    json['oldPrice'] = oldPrice;
    json['offer'] = offer;
    json['description'] = description;
    json['idCategory'] = idCategory;
    json['isCategory'] = isCategory;
    json['count'] = count;
    json['images'] = images!.map((e) => e.toJson()).toList();
    return json;
  }
}
