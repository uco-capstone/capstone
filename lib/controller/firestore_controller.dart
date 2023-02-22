import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  static const taskCollection = 'task_collection';
  static const kirbyUserCollection = 'kirby_user_collection';

  static Future<String> addTask({required KirbyTask kirbyTask}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(taskCollection)
        .add(kirbyTask.toFirestoreDoc());
    return ref.id;
  }

  static Future<void> addHealthInfo({required KirbyUser kirbyUser}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(kirbyUserCollection)
        .where(DocKeyUser.userId.name, isEqualTo: kirbyUser.userId)
        .get();

    if (querySnapshot.docs.length != 1) {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(kirbyUserCollection)
          .add(kirbyUser.toFirestoreDoc());
      return;
    }
    await FirebaseFirestore.instance
        .collection(kirbyUserCollection)
        .doc(querySnapshot.docs[0].id)
        .update(kirbyUser.toFirestoreDoc());
  }

  static Future<KirbyUser> getKirbyUser({
    required String userId,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(kirbyUserCollection)
        .where(DocKeyUser.userId.name, isEqualTo: userId)
        .get();

    if (querySnapshot.docs.length != 1) {
      return KirbyUser(userId: userId, firstName: "");
    }
    return KirbyUser.fromFirestoreDoc(
        doc: querySnapshot.docs[0].data() as Map<String, dynamic>,
        userId: userId);
  }

  static Future<void> updateKirbyUser({
    required String userId,
    required Map<String, dynamic> update,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(kirbyUserCollection)
        .where(DocKeyUser.userId.name, isEqualTo: userId)
        .get();

    await FirebaseFirestore.instance
        .collection(kirbyUserCollection)
        .doc(querySnapshot.docs[0].id)
        .update(update);
  }
}
