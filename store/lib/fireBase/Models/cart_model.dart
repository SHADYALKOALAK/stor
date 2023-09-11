import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/FireBase/Models/product_model.dart';

class CartModel {
  String? id;
  String? idUser;
  ProductModel? model;
  Timestamp? timestamp;
  int? qyn;

  CartModel({
    this.id,
    this.idUser,
    this.qyn,
    this.model,
    this.timestamp,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['idUser'];
    qyn = json['qyn'];
    model = json['model'] != null ? ProductModel.fromJson(json['model']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['idUser'] = idUser;
    json['model'] = model?.toJson();
    json['timestamp'] = timestamp;
    json['qyn'] = qyn;
    return json;
  }
}
