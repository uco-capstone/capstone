import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/kirby_pet_model.dart';
import 'auth_controller.dart';

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
      return snapshot.docs.isNotEmpty;
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
    if (!isCompleted) {
      var pet = await getPet(userId: Auth.user!.uid);
      if (pet.hungerGauge < 10) {
        updatePet(
            userId: Auth.user!.uid,
            update: {'hungerGauge': FieldValue.increment(1)});
      }
      updateKirbyUser(
        userId: Auth.user!.uid,
        update: {'currency': FieldValue.increment(100)},
      );
    }
    var task = await getKirbyTask(taskId: taskId);
    // ignore: avoid_print
    print("==== reoccuring: ${task.reocurringDuration}");
    /*  Eli
        - if a reoccuring task becomes completed, the interval of recursion is 
          added to the due date and is added to the task list in the database
    */
    if (task.isCompleted && task.isReoccuring!) {
      var tempTask = KirbyTask(
        userId: task.userId,
        title: task.title,
        isCompleted: false,
        dueDate: task.dueDate?.add(Duration(days: task.reocurringDuration!)),
        isReoccuring: true,
        isPreloaded: task.isPreloaded,
        reocurringDuration: task.reocurringDuration,
      );
      await addKirbyTask(kirbyTask: tempTask);
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

  static Future<void> updateKirbyTask({
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
        if (t.isCompleted != true) {
          result.add(t);
        }
      }
    }
    return result;
  }

  // get all tasks for a given day
  static Future<List<KirbyTask>> getDayTasks({
    required String uid,
    required DateTime day,
  }) async {
    DateTime nextDay = day.add(const Duration(days: 1));

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
