class Customization {
  String label;
  String filepath;
  int price;

  Customization({
    required this.label,
    required this.filepath,
    required this.price,
  });
}

//Array of all skin customization paths
  var skinCustomizations = [
    Customization(label: 'Pink', filepath: 'images/skins/default-kirby.png', price: 0),
    Customization(label: 'Blue', filepath: 'images/skins/blue-kirby.png', price: 0),
    Customization(label: 'Yellow', filepath: 'images/skins/yellow-kirby.png', price: 0),
    Customization(label: 'Green', filepath: 'images/skins/green-kirby.png', price: 0),
  ];

//Array of all background customization paths
  var backgroundCustomizations = [
    Customization(label: 'Indoors', filepath: 'images/backgrounds/default-background.png', price: 0),
    Customization(label: 'Park', filepath: 'images/backgrounds/outside-background.png', price: 0),
    Customization(label: 'City', filepath: 'images/backgrounds/city-background.png', price: 0),
    Customization(label: 'Clouds', filepath: 'images/backgrounds/cloud-background.png', price: 0),
  ];