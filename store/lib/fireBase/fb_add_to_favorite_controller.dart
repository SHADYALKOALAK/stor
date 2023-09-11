import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/fireBase/Models/favorite+model.dart';
import 'package:store/providers/favorite_provider.dart';

class FbAddToFavoriteController {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final String table = 'favoriteTable';

  ///CREATE
  Future<bool> toggle(BuildContext context, FavoriteModel model) async {
    FavoriteProvider favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    var favorites = await getAllFavorite();

    int index = favorites.indexWhere(
        (element) => element.productModel?.id == model.productModel?.id);
    if (index == -1) {
      await store
          .collection(table)
          .doc(model.id)
          .set(model.toJson())
          .catchError((onError) => false);
      favoriteProvider.add(model);
    } else {
      var data = await store
          .collection(table)
          .doc(favorites[index].id)
          .delete()
          .catchError(((onError) => false));
      favoriteProvider.delete(model);
      return true;
    }
    return true;
  }

  Future<List<FavoriteModel>> getAllFavorite() async {
    var data = await store
        .collection(table)
        .where('idUser', isEqualTo: CacheController().getter(CacheKeys.id))
        .withConverter(
      fromFirestore: (snapshot, options) {
        return FavoriteModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    ).get();
    return data.docs.map((e) => e.data()).toList();
  }

  ///UpDate
  Future<bool> upDate(FavoriteModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .update(model.toJson())
        .catchError(((onError) => false));
    return true;
  }
}
