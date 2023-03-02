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

  static Future<List<KirbyTask>> getKirbyTaskList({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(taskCollection)
        .where(DocKeyKirbyTask.userId.name, isEqualTo: uid)
        //.orderBy(DocKeyKirbyTask.dueDate, descending: false)
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
    if (querySnapshot.docs.isEmpty) {
      List<KirbyTask> tempList = getPreloadedTasks(uid: uid);
      for (var element in tempList) {
        result.add(element);
      }
    }

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

  static List<KirbyTask> getPreloadedTasks({required String uid}) {
    List<KirbyTask> taskList = [];
    DateTime now = DateTime.now();
    KirbyTask eatMeals = KirbyTask(
        userId: uid,
        title: "Eat 3 meals today",
        isPreloaded: true,
        isReoccuring: true,
        // due midnight tonight
        dueDate: DateTime(now.year, now.month, now.day, 24));
    taskList.add(eatMeals);

    KirbyTask drinkWater = KirbyTask(
        userId: uid,
        title: "Drink half my weight in ounces",
        isPreloaded: true,
        isReoccuring: true,
        // due midnight tonight
        dueDate: DateTime(now.year, now.month, now.day, 24));
    taskList.add(drinkWater);

    KirbyTask sleep = KirbyTask(
        userId: uid,
        title: "Sleep",
        isPreloaded: true,
        isReoccuring: true,
        // due midnight tonight
        dueDate: DateTime(now.year, now.month, now.day, 24));
    taskList.add(sleep);

    // add to firebase
    for (var element in taskList) {
      addTask(kirbyTask: element);
    }
    return taskList;
  }
}
