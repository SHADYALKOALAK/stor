import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/FireBase/Models/product_model.dart';

class FavoriteModel {
  String? id;
  String? idUser;
  ProductModel? productModel;
  Timestamp? timestamp;

  FavoriteModel({
    this.id,
    this.idUser,
    this.productModel,
    this.timestamp,
  });

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['idUser'];
    productModel = json['productModel'] != null
        ? ProductModel.fromJson(json['productModel'])
        : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['idUser'] = idUser;
    json['productModel'] = productModel?.toJson();
    json['timestamp'] = timestamp;
    return json;
  }
}
