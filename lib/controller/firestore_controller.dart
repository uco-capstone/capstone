import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/kirby_pet_model.dart';
import '../model/purchased_item_model.dart';
import 'auth_controller.dart';

class FirestoreController {
  static const taskCollection = 'task_collection';
  static const kirbyUserCollection = 'kirby_user_collection';
  static const petCollection = 'pet_collection';
  static const purchasedCollection = 'purchased_collection';

  //============== USER INFO ==================

  // updates user health info
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

  // gets user data
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

  // checks if user exists
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

  // updates user data
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

  // get all kirbyusers
  static Future<List<KirbyUser>> getKirbyUserList() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(kirbyUserCollection).get();

    var result = <KirbyUser>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var u = KirbyUser(
            userId: document['userId'], firstName: document['firstName']);
        result.add(u);
      }
    }
    return result;
  }

  //============== KIRBY TASK ==================

  // updates the completion status of a task
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
    var task = await getKirbyTask(taskId: taskId);

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

  // adds a task
  static Future<String> addKirbyTask({required KirbyTask kirbyTask}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(taskCollection)
        .add(kirbyTask.toFirestoreDoc());
    return ref.id;
  }

  // deletes a task
  static Future<void> deleteKirbyTask({required String taskId}) async {
    await FirebaseFirestore.instance
        .collection(taskCollection)
        .doc(taskId)
        .delete();
  }

  // get a single kirbyTask
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

  //Updates KirbyTask in FireStore
  static Future<void> updateKirbyTask({
    required String taskId,
    required Map<String, dynamic> update,
  }) async {
    await FirebaseFirestore.instance
        .collection(taskCollection)
        .doc(taskId)
        .update(update);
  }

  // get all kirbyTask from user
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

  // Obtaining completedTasks for users
  static Future<List<KirbyTask>> getCompletedTasks({
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
        if (t.isCompleted == true) {
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

  // gets all preloaded tasks from user
  static Future<List<KirbyTask>> getPreloadedTaskList({
    required String uid,
  }) async {
    var result = <KirbyTask>[];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(taskCollection)
        .where(DocKeyKirbyTask.userId.name, isEqualTo: uid)
        .where(DocKeyKirbyTask.isPreloaded.name, isEqualTo: true)
        .where(DocKeyKirbyTask.isCompleted.name, isEqualTo: false)
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

  // gets non-preloaded tasks from user
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

  //Gets KirbyPet from the firestore according to UserId
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

  //Updates corresponding KirbyPet fields
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

  //Checks if a user has an instance of KirbyPet in the firestore
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

  // Adds a KirbyPet to the firestore and returns the ID of the KirbyPet
  static Future<String> addPet({required KirbyPet kirbyPet}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(petCollection)
        .add(kirbyPet.toFirestoreDoc());
    return ref.id;
  }

  //============== PURCHASED ITEMS ==================

  ///Adds a purchased item to the firestore and returns the ID of the purchased item
  static Future<String> addPurchasedItem({required PurchasedItem purchasedItem}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(purchasedCollection)
        .add(purchasedItem.toFirestoreDoc());
    return ref.id;
  }

  //Gets a list of all the purchased items that is linked to a user
  static Future<List<PurchasedItem>> getPurchasedItemsList({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(purchasedCollection)
        .where(DocKeyPurchasedItem.userId.name, isEqualTo: uid)
        .get();

    var result = <PurchasedItem>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PurchasedItem.fromFirestoreDoc(doc: document, purchasedItemId: doc.id);
        result.add(p);
      }
    }
    return result;
  }
}
