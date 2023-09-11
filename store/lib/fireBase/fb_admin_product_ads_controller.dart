import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/FireBase/Models/ads_model.dart';

class FbAdminProductAdsController {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final String table = 'AdsTable';

  ///CREATE
  Future<bool> insertAds(AdsModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .set(model.toJson())
        .catchError((onError) => false);
    return true;
  }

  ///Read
  Stream<QuerySnapshot<AdsModel>> read() async* {
    yield* store.collection(table).withConverter(
      fromFirestore: (snapshot, options) {
        return AdsModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    ).snapshots();
  }

  ///UpDate
  Future<bool> upDate(AdsModel model) async {
    await store
        .collection(table)
        .doc(model.id)
        .update(model.toJson())
        .catchError(((onError) => false));
    return true;
  }

  ///delete
  Future<bool> delete(AdsModel model) async {
   await store
        .collection(table)
        .doc(model.id)
        .delete()
        .catchError(((onError) => false));
    return true;
  }
}
