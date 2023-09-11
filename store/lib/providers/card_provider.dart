import 'package:flutter/cupertino.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/fireBase/Models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> carts = [];

  set(List<CartModel> list) {
    carts = list;
    notifyListeners();
  }

  void add(CartModel cards) {
    carts.add(cards);
    notifyListeners();
  }

  void delete(CartModel model) {
    int index = carts.indexWhere(
        (element) => element.model?.id == model.model?.id);
    carts.removeAt(index);
    notifyListeners();
  }

  bool checkFavorite(ProductModel? model) {
    int index =
        carts.indexWhere((element) => element.model?.id == model?.id);
    return index != -1;
  }
}
