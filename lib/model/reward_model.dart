enum DocKeyReward {
  uid,
  receivedDate,
  // isReceived,
}

class Reward {
  String? uid;
  DateTime? receivedDate;
  // bool isReceived;

  Reward({
    required this.uid,
    this.receivedDate,
    // this.isReceived = false,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyReward.uid.name: uid,
      DocKeyReward.receivedDate.name: receivedDate,
      // DocKeyReward.isReceived.name: isReceived,
    };
  }

  factory Reward.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String uid,
  }) {
    return Reward(
      uid: doc[DocKeyReward.uid.name] ??= "",
      receivedDate: doc[DocKeyReward.receivedDate.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyReward.receivedDate.name].millisecondsSinceEpoch,
            )
          : null,
      // isReceived: doc[DocKeyReward.isReceived.name] ??= false,
    );
  }
}
