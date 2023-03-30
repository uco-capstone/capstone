import 'customization_model.dart';

enum DocKeyPet {
  petId,
  userId,
  kirbySkin,
  background,
  hungerGauge,
}

class KirbyPet {
  String? petId;
  String userId;
  String? kirbySkin;            //Path for custom skin, ex: "images/sample-kirby.png"
  String? background;           //Path for custom background image
  int hungerGauge;

  KirbyPet({
    this.petId,
    required this.userId,
    this.kirbySkin,
    this.background,
    this.hungerGauge = 5,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPet.userId.name: userId,
      DocKeyPet.kirbySkin.name: kirbySkin,
      DocKeyPet.background.name: background,
      DocKeyPet.hungerGauge.name: hungerGauge,
    };
  }

  factory KirbyPet.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String petId,
  }) {
    return KirbyPet(
      petId: petId,
      userId: doc[DocKeyPet.userId.name] ??= "",
      kirbySkin: doc[DocKeyPet.kirbySkin.name] ??= skinCustomizations[0].filepath,
      background: doc[DocKeyPet.background.name] ??= backgroundCustomizations[0].filepath,
      hungerGauge: doc[DocKeyPet.hungerGauge.name] ??= 5,
    );
  }
}
