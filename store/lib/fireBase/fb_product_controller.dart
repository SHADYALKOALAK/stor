import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/FireBase/Models/product_model.dart';

class FbProductController {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final String table = 'productsTable';

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

  /// CategoryProducts
  Stream<QuerySnapshot<ProductModel>> reedCategory(String category) async* {
    yield* store
        .collection(table)
        .withConverter(
          fromFirestore: (snapshot, options) {
            return ProductModel.fromJson(snapshot.data()!);
          },
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .where('isCategory', isEqualTo: category)
        .snapshots();
  }

  /// category
  Stream<QuerySnapshot<ProductModel>> getAllCategoryFromId(String id) async* {
    yield* store
        .collection(table)
        .withConverter(
          fromFirestore: (snapshot, options) {
            return ProductModel.fromJson(snapshot.data()!);
          },
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .where('idCategory', isEqualTo: id)
        .snapshots();
  }
}
