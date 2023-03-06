class KirbyPet {
  String? kirbySkin;            //Path for custom skin, ex: "images/sample-kirby.png"
  String? backgroundImage;      //Path for custom background image
  int? hungerGauge;

  KirbyPet({
    this.kirbySkin,
    this.backgroundImage,
    this.hungerGauge,
  });
}

//Array of all skin customization paths
  var skinCustomizations = [
    'images/default-kirby.png',
    'images/blue-kirby.png',
    'images/yellow-kirby.png'
  ];