import 'package:capstone/controller/auth_controller.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/kirby_pet_model.dart';

class FirestoreController {
  static const taskCollection = 'task_collection';
  static const kirbyUserCollection = 'kirby_user_collection';
  static const petCollection = 'pet_collection';

  //============== USER INFO ==================

  static Future<void> addHealthInfo({required KirbyUser kirbyUser}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(kirbyUserCollection)
        .where(DocKeyUser.userId.name, isEqualTo: kirbyUser.userId)
        .get();

    if (querySnapshot.docs.length != 1) {
      // ignore: unused_local_variable
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

  //============== KIRBY USER ==================

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
      userId: userId,
    );
  }

  static Future<bool> hasKirbyUser(String userId) async {
    try {
      // Get reference to Firestore collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(kirbyUserCollection)
          .where(DocKeyUser.userId.name, isEqualTo: userId)
          .get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return false;
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

  //============== KIRBY TASK ==================

  static Future<void> updateTaskCompletion({
    required String taskId,
    required bool isCompleted,
    required DateTime completeDate,
  }) async {
    // Update an existing document
    FirebaseFirestore.instance
        .collection(taskCollection)
        .doc(taskId)
        .update({'isCompleted': !isCompleted, 'completeDate': completeDate});

    // Reward if complete task
    if (!isCompleted) {
      // Increase currency
      updateKirbyUser(
        userId: Auth.user!.uid,
        update: {'currency': FieldValue.increment(100)},
      );

      // Increase hunger
      FirebaseFirestore.instance.runTransaction((transaction) async {
        QuerySnapshot petSnapshot = await FirebaseFirestore.instance
            .collection(petCollection)
            .where(DocKeyPet.userId.name, isEqualTo: Auth.user!.uid)
            .get();

        final snapshot = await transaction.get(petSnapshot.docs[0].reference);

        // Increase if less than 10
        if (snapshot.get("hungerGauge") < 10) {
          transaction.update(
            petSnapshot.docs[0].reference,
            {
              'hungerGauge': FieldValue.increment(1),
            },
          );
        }
      });
    }
  }

  static Future<String> addKirbyTask({required KirbyTask kirbyTask}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(taskCollection)
        .add(kirbyTask.toFirestoreDoc());
    return ref.id;
  }

  static Future<void> deleteKirbyTask({required String taskId}) async {
    await FirebaseFirestore.instance
        .collection(taskCollection)
        .doc(taskId)
        .delete();
  }

  static Future<KirbyTask> getKirbyTask({
    required String taskId,
  }) async {
    var doc = await FirebaseFirestore.instance
        .collection(taskCollection)
        .doc(taskId)
        .get();
    var document = doc.data() as Map<String, dynamic>;
    return KirbyTask.fromFirestoreDoc(doc: document, taskId: taskId);
  }

// Overwrites the entire doc
  static Future<void> editKirbyTask({
    required String taskId,
    required Map<String, dynamic> update,
  }) async {
    await FirebaseFirestore.instance
        .collection(taskCollection)
        .doc(taskId)
        .set(update);
  }

// Overrides specfic fields
  static Future<void> editKirbyTaskField({
    required String taskId,
    required Map<String, dynamic> update,
  }) async {
    await FirebaseFirestore.instance
        .collection(taskCollection)
        .doc(taskId)
        .update(update);
  }

  static Future<List<KirbyTask>> getKirbyTaskList({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(taskCollection)
        .where(DocKeyKirbyTask.userId.name, isEqualTo: uid)
        .orderBy(DocKeyKirbyTask.dueDate.name, descending: false)
        .get();

    var result = <KirbyTask>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = KirbyTask.fromFirestoreDoc(doc: document, taskId: doc.id);
        result.add(t);
      }
    }
    return result;
  }

  // get all tasks for a given day
  static Future<List<KirbyTask>> getDayTasks({
    required String uid,
    required DateTime day,
  }) async {
    DateTime nextDay = day.add(Duration(days: 1));

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(taskCollection)
        .where(DocKeyKirbyTask.userId.name, isEqualTo: uid)
        .where(DocKeyKirbyTask.dueDate.name,
            isGreaterThanOrEqualTo: day) // midnight of day
        .where(DocKeyKirbyTask.dueDate.name,
            isLessThan: nextDay) // midnight of next day
        .get();

    var result = <KirbyTask>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = KirbyTask.fromFirestoreDoc(doc: document, taskId: doc.id);
        result.add(t);
      }
    }
    return result;
  }

  static Future<List<KirbyTask>> getPreloadedTaskList({
    required String uid,
  }) async {
    var result = <KirbyTask>[];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(taskCollection)
        .where(DocKeyKirbyTask.userId.name, isEqualTo: uid)
        .where(DocKeyKirbyTask.isPreloaded.name, isEqualTo: true)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = KirbyTask.fromFirestoreDoc(doc: document, taskId: doc.id);
        result.add(t);
      }
    }

    return result;
  }

  static Future<List<KirbyTask>> getNonPreloadedTaskList({
    required String uid,
  }) async {
    var result = <KirbyTask>[];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(taskCollection)
        .where(DocKeyKirbyTask.userId.name, isEqualTo: uid)
        .where(DocKeyKirbyTask.isPreloaded.name, isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = KirbyTask.fromFirestoreDoc(doc: document, taskId: doc.id);
        result.add(t);
      }
    }

    return result;
  }

  //============== KIRBY PET ==================
  static Future<KirbyPet> getPet({
    required String userId,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(petCollection)
        .where(DocKeyPet.userId.name, isEqualTo: userId)
        .get();

    if (querySnapshot.docs.length != 1) {
      return KirbyPet(userId: userId);
    }
    return KirbyPet.fromFirestoreDoc(
      doc: querySnapshot.docs[0].data() as Map<String, dynamic>,
      petId: querySnapshot.docs[0].id,
    );
  }

  static Future<void> updatePet({
    required String userId,
    required Map<String, dynamic> update,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(petCollection)
        .where(DocKeyPet.userId.name, isEqualTo: userId)
        .get();

    await FirebaseFirestore.instance
        .collection(petCollection)
        .doc(querySnapshot.docs[0].id)
        .update(update);
  }

  static Future<bool> hasPet(String userId) async {
    try {
      // Get reference to Firestore collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(petCollection)
          .where(DocKeyUser.userId.name, isEqualTo: userId)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return false;
  }

  static Future<String> addPet({required KirbyPet kirbyPet}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(petCollection)
        .add(kirbyPet.toFirestoreDoc());
    return ref.id;
  }
}
