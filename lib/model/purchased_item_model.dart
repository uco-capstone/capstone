import 'package:capstone/model/customization_model.dart';

enum DocKeyPurchasedItem {
  purchasedItemId,
  userId,
  label,
  filepath,
  price,
}

class PurchasedItem extends Customization {
  String userId;
  String? purchasedItemId;

  PurchasedItem({
    this.purchasedItemId,
    required this.userId,
    required super.label, 
    required super.filepath, 
    required super.price,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPurchasedItem.userId.name: userId,
      DocKeyPurchasedItem.label.name: label,
      DocKeyPurchasedItem.filepath.name: filepath,
      DocKeyPurchasedItem.price.name: price,
    };
  }

  factory PurchasedItem.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String purchasedItemId,
  }) {
    return PurchasedItem(
      purchasedItemId: purchasedItemId,
      userId: doc[DocKeyPurchasedItem.userId.name] ??= "",
      label: doc[DocKeyPurchasedItem.label.name] ??= "",
      filepath: doc[DocKeyPurchasedItem.filepath.name] ??= "",
      price: doc[DocKeyPurchasedItem.price.name] ??= 0,
    );
  }
}