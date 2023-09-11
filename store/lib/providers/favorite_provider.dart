import 'package:flutter/cupertino.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/fireBase/Models/favorite+model.dart';

class FavoriteProvider extends ChangeNotifier {
  List<FavoriteModel> favorites = [];

  set(List<FavoriteModel> list) {
    favorites = list;
    notifyListeners();
  }

  void add(FavoriteModel favorite) {
    favorites.add(favorite);
    notifyListeners();
  }

  void delete(FavoriteModel model) {
    int index = favorites.indexWhere(
        (element) => element.productModel?.id == model.productModel?.id);
    favorites.removeAt(index);
    notifyListeners();
  }

  bool checkFavorite(ProductModel? model) {
    int index =
        favorites.indexWhere((element) => element.productModel?.id == model?.id);
    return index != -1;
  }
}
