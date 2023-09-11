import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/FireBase/Models/ads_model.dart';
import 'package:store/FireBase/Models/category_model.dart';

class FbAdminProductCategoryController {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final String table = 'CategoryTable';

  ///CREATE
  Future<bool> insertCategory(CategoryModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .set(model.toJson())
        .catchError((onError) => false);
    return true;
  }

  ///Read
  Stream<QuerySnapshot<CategoryModel>> read() async* {
    yield* store.collection(table).withConverter(
      fromFirestore: (snapshot, options) {
        return CategoryModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    ).snapshots();
  }

  ///UpDate
  Future<bool> upDate(CategoryModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .update(model.toJson())
        .catchError(((onError) => false));
    return true;
  }

  ///delete
  Future<bool> delete(CategoryModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .delete()
        .catchError(((onError) => false));
    return true;
  }
}
