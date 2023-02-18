import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  static const taskCollection = 'task_collection';

  static Future<String> addTask({required KirbyTask kirbyTask}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(taskCollection)
        .add(kirbyTask.toFirestoreDoc());
    return ref.id;
  }

  // TODO: delete; test fxn //////////////////////////////////////////////////////////////
  // Future<String> addTaskTest() async {
  //   KirbyUser kirbyUser1 = KirbyUser(
  //       firstName: "kirbyuser1", userId: "YNhIIiWfbveNu9rz4tORUfPKHXv2");
  //   KirbyTask kirbyTaskTest =
  //       KirbyTask(user: kirbyUser1, title: "kirbyuser1's title");
  //   DocumentReference ref = await FirebaseFirestore.instance
  //       .collection(taskCollection)
  //       .add(kirbyTaskTest.toFirestoreDoc());
  //   print("added TaskTest");
  //   return ref.id;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////
}

// // example code for reference
// class FirestoreController {
//   static Future<String> addPhotoMemo({
//     required PhotoMemo photoMemo,
//   }) async {
//     DocumentReference ref = await FirebaseFirestore.instance
//         .collection(Constant.photoMemoCollection)
//         .add(photoMemo.toFirestoreDoc());
//     return ref.id; // doc id
//   }

//   static Future<List<PhotoMemo>> getPhotoMemoList({
//     required String email,
//   }) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection(Constant.photoMemoCollection)
//         .where(DocKeyPhotoMemo.createdBy.name, isEqualTo: email)
//         .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
//         .get();

//     var result = <PhotoMemo>[];
//     // if user has photos, populate result
//     for (var doc in querySnapshot.docs) {
//       if (doc.data() != null) {
//         var document = doc.data()
//             as Map<String, dynamic>; // get 1 doc then convert back to Map
//         var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
//         if (p != null) result.add(p);
//       }
//     }
//     return result;
//   }

//   static Future<void> updatePhotoMemo({
//     required String docId,
//     required Map<String, dynamic> update,
//   }) async {
//     await FirebaseFirestore.instance
//         .collection(Constant.photoMemoCollection)
//         .doc(docId)
//         .update(update);
//   }

//   static Future<List<PhotoMemo>> searchImages({
//     required String email,
//     required List<String> searchLabel,
//   }) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection(Constant.photoMemoCollection)
//         .where(DocKeyPhotoMemo.createdBy.name,
//             isEqualTo: email) // use .name for firestore String value
//         .where(DocKeyPhotoMemo.imageLabels.name, arrayContainsAny: searchLabel)
//         .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
//         .get();

//     // convert from FB doc to Phtomemo object
//     var result = <PhotoMemo>[];
//     for (var doc in querySnapshot.docs) {
//       var p = PhotoMemo.fromFirestoreDoc(
//         doc: doc.data() as Map<String, dynamic>, // convert data to Map
//         docId: doc.id,
//       );
//       if (p != null) result.add(p);
//     }
//     return result;
//   }

//   // delete from firestore
//   static Future<void> deleteDoc({
//     required String docId,
//   }) async {
//     await FirebaseFirestore.instance
//         .collection(Constant.photoMemoCollection)
//         .doc(docId)
//         .delete();
//   }

//   static Future<List<PhotoMemo>> getPhotoMemoListSharedWithMe({
//     required String email,
//   }) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection(Constant.photoMemoCollection)
//         .where(DocKeyPhotoMemo.sharedWith.name, arrayContains: email)
//         .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
//         .get();

//     var result = <PhotoMemo>[];
//     // if user has photos, populate result
//     for (var doc in querySnapshot.docs) {
//       if (doc.data() != null) {
//         var document = doc.data()
//             as Map<String, dynamic>; // get 1 doc then convert back to Map
//         var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
//         if (p != null) result.add(p);
//       }
//     }
//     return result;
//   }
// }
