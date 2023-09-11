import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/fireBase/Models/cart_model.dart';
import 'package:store/providers/card_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FbCartController with ChickData {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final String table = 'cartTable';

  ///CREATE
  Future<bool> insert(BuildContext context, CartModel model) async {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    var carts = await getAllCartProduct();
    int index =
        carts.indexWhere((element) => element.model?.id == model.model?.id);
    if (index == -1) {
      await store
          .collection(table)
          .doc(model.id)
          .set(model.toJson())
          .catchError((onError) => false);
      cartProvider.add(model);
    } else {
      int? oldCount = carts[index].qyn ?? 0;
      int newCount = oldCount + carts[index].qyn!;
      CartModel newCartModel = carts[index];
      newCartModel.qyn = newCount;
      await update(newCartModel);
      return true;
    }
    return true;
  }

  Future<List<CartModel>> getAllCartProduct() async {
    var data = await store
        .collection(table)
        .where('idUser', isEqualTo: CacheController().getter(CacheKeys.id))
        .withConverter<CartModel>(fromFirestore: (snapshot, options) {
      return CartModel.fromJson(snapshot.data()!);
    }, toFirestore: (value, options) {
      return value.toJson();
    }).get();
    return data.docs.map((e) => e.data()).toList();
  }

  ///delete
  Future<bool> delete(BuildContext context, CartModel model) async {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    var carts = await getAllCartProduct();
    int index =
        carts.indexWhere((element) => element.model?.id == model.model?.id);
    if (index != -1) {
      await store
          .collection(table)
          .doc(carts[index].id)
          .delete()
          .catchError(((onError) => false));
      cartProvider.delete(model);
      return true;
    }
    return false;
  }

  Future<bool> update(CartModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .update(model.toJson())
        .catchError((onError) => false);
    return true;
  }
}
