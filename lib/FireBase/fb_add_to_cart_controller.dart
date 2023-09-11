import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/FireBase/Models/ads_model.dart';
import 'package:store/FireBase/Models/product_model.dart';

class FbAddToCartController {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final String table = 'CartTable';

  ///CREATE
  Future<bool> insert(ProductModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .set(model.toJson())
        .catchError((onError) => false);
    return true;
  }

  ///Read
  Stream<QuerySnapshot<ProductModel>> read() async* {
    yield* store.collection(table).withConverter(
      fromFirestore: (snapshot, options) {
        return ProductModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    ).snapshots();
  }

  ///UpDate
  Future<bool> upDate(ProductModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .update(model.toJson())
        .catchError(((onError) => false));
    return true;
  }

  ///delete
  Future<bool> delete(ProductModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .delete()
        .catchError(((onError) => false));
    return true;
  }
}
