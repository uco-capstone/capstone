import 'package:capstone/model/purchased_item_model.dart';
import 'package:capstone/model/shop_screen_model.dart';
import 'package:capstone/viewpage/view/kirby_loading.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import 'package:capstone/viewpage/home_screen.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import '../controller/firestore_controller.dart';
import '../model/constants.dart';
import '../model/customization_model.dart';
import '../model/kirby_pet_model.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shopScreen';

  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShopScreen();
  }
}

class _ShopScreen extends State<ShopScreen> {
  late _Controller con;
  late ShopScreenModel screenModel;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = ShopScreenModel(user: Auth.getUser());
    con.initScreen();
  }

  void render(fn) => setState(fn);
  int _selectedIndex = 0;

  final ScrollController _homeController = ScrollController();

  //Builds the Grid View bodies according to which bottom navigation bar index is chosen
  Widget _listViewBody(int menuOption) {
    switch (menuOption) {
      case 0: //Skins
        return GridView.builder(
          controller: _homeController,
          itemBuilder: (BuildContext context, int index) {
            return _skinsScreen(index);
          },
          itemCount: skinCustomizations.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
        );
      case 1: //Backgrounds
        return GridView.builder(
          controller: _homeController,
          itemBuilder: (BuildContext context, int index) {
            return _backgroundsScreen(index);
          },
          itemCount: backgroundCustomizations.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
        );
      case 2: //Accessories
        return ListView.separated(
            controller: _homeController,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Text(
                  'Item $index',
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  thickness: 5,
                ),
            itemCount: 26);
      case 3: //Misc
        return ListView.separated(
            controller: _homeController,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Text(
                  'Item $index',
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  thickness: 5,
                ),
            itemCount: 26);
      default:
        return ListView.separated(
            controller: _homeController,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Text(
                  'Item $index',
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  thickness: 5,
                ),
            itemCount: 26);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Builds the screen body for the skin customization options
  Widget _skinsScreen(int index) {
    return Align(
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.45,
        width: MediaQuery.of(context).size.width * 0.45,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Stack(
            children: [
              ListTile(
                title: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.28,
                        child: Image(
                          image: AssetImage(skinCustomizations[index].filepath),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        child: Text(skinCustomizations[index].label)),
                  ],
                ),
                onTap: () => con.updateSkinCustomization(
                    skinCustomizations[index].filepath),
              ),
              if (skinCustomizations[index].filepath ==
                  screenModel.kirbyPet!.kirbySkin)
                Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: const Image(
                    image: AssetImage('images/selected-stamp.png'),
                  ),
                ),
              if (!screenModel.purchasedItemsList.any((item) =>
                  item.filepath == skinCustomizations[index].filepath))
                Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    ListTile(
                      onTap: () => _purchaseItemDialog(
                          context, skinCustomizations[index]),
                      title: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${skinCustomizations[index].price} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                Icons.monetization_on,
                                color: Colors.orangeAccent,
                                size: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  //Builds the screen body for the background customization options
  Widget _backgroundsScreen(int index) {
    return Align(
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.45,
        width: MediaQuery.of(context).size.width * 0.45,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      child: Image(
                          image: AssetImage(
                              backgroundCustomizations[index].filepath),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 10,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(
                              child:
                                  Text(backgroundCustomizations[index].label))),
                    ),
                  ],
                ),
                onTap: () => con.updateBackgroundCustomization(
                    backgroundCustomizations[index].filepath),
              ),
              if (backgroundCustomizations[index].filepath ==
                  screenModel.kirbyPet!.background)
                Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: const Image(
                    image: AssetImage('images/selected-stamp.png'),
                  ),
                ),
              if (!screenModel.purchasedItemsList.any((item) =>
                  item.filepath == backgroundCustomizations[index].filepath))
                Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    ListTile(
                      onTap: () => _purchaseItemDialog(
                          context, backgroundCustomizations[index]),
                      title: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${backgroundCustomizations[index].price} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                Icons.monetization_on,
                                color: Colors.orangeAccent,
                                size: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  //Shows the dialog to ask the user if they do want
  void _purchaseItemDialog(BuildContext context, Customization customization) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Purchase Item?'),
          content: Text(
              'Are you sure you want to spend ${customization.price} coins on the ${customization.label}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => con.purchaseItem(customization),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (screenModel.loading) {
    //   return const Center(
    //     child: KirbyLoading(),
    //   );
    // } else {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 75,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Sample number of coins
                  screenModel.loading
                      ? const KirbyLoading()
                      : Text(
                          '${screenModel.kirbyUser!.currency}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: screenModel.loading
          ? const KirbyLoading()
          : Center(
              child: _listViewBody(_selectedIndex),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_rounded),
            label: 'Skins',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.area_chart_rounded),
            label: 'Background',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Accessories',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_symbols_rounded),
            label: 'Misc',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (int index) {
          switch (index) {
            case 0:
              // only scroll to top when current index is selected.
              if (_selectedIndex == index) {
                _homeController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              } else {
                _onItemTapped(index);
              }
              break;
            case 1:
              _onItemTapped(index);
              break;
            case 2:
              _onItemTapped(index);
              break;
            case 3:
              _onItemTapped(index);
              break;
            // bug-fix on how to select back to 'skins'
          }
        },
      ),
    );
  }
  // }
}

class _Controller {
  _ShopScreen state;
  _Controller(this.state);

  //Adds a loading screen while it is getting the KirbyPet, to avoid any null values
  void initScreen() async {
    state.screenModel.loading = true;
    await getPet();
    await getKirbyUser();
    await getPurchasedItems();
    state.screenModel.loading = false;
  }

  //Gets the KirbyUser that corresponds to the logged in user from the firebase
  Future<void> getKirbyUser() async {
    try {
      state.screenModel.kirbyUser =
          await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
      state.render(() {});
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print(" ==== loading error $e");
      state.render(() => state.screenModel.loadingErrorMessage = "$e");
    }
  }

  //Gets the KirbyPet that corresponds with the logged in user from the firebase
  Future<void> getPet() async {
    try {
      state.screenModel.kirbyPet =
          await FirestoreController.getPet(userId: Auth.getUser().uid);
      state.render(() {});
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print(" ==== loading error $e");
      state.render(() => state.screenModel.loadingErrorMessage = "$e");
    }
  }

  //Gets the list of items that have been purchased by the user, if there are no purchased items, add the defaults
  Future<void> getPurchasedItems() async {
    try {
      state.screenModel.purchasedItemsList =
          await FirestoreController.getPurchasedItemsList(
              uid: Auth.getUser().uid);

      if (state.screenModel.purchasedItemsList.isEmpty) {
        // ignore: avoid_print
        print('**************** Empty!!!!!!');
        var tempPurchasedItem = PurchasedItem(
            userId: Auth.getUser().uid,
            label: skinCustomizations[0].label,
            filepath: skinCustomizations[0].filepath,
            price: skinCustomizations[0].price);

        await FirestoreController.addPurchasedItem(
            purchasedItem: tempPurchasedItem);

        tempPurchasedItem = PurchasedItem(
            userId: Auth.getUser().uid,
            label: backgroundCustomizations[0].label,
            filepath: backgroundCustomizations[0].filepath,
            price: backgroundCustomizations[0].price);

        await FirestoreController.addPurchasedItem(
            purchasedItem: tempPurchasedItem);
      }

      state.screenModel.purchasedItemsList =
          await FirestoreController.getPurchasedItemsList(
              uid: Auth.getUser().uid);
      state.render(() {});
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print(" ==== loading error $e");
      state.render(() => state.screenModel.loadingErrorMessage = "$e");
    }
  }

  /*
  This function recieves a string of the filepath of the image and 
  updates the kirbySkin option of the KirbyPet in the firebase
  */
  void updateSkinCustomization(String customization) async {
    if (state.screenModel.kirbyPet != null) {
      state.screenModel.kirbyPet!.kirbySkin = customization;
    }
    try {
      Map<String, dynamic> update = {};
      update[DocKeyPet.kirbySkin.name] = customization;
      await FirestoreController.updatePet(
          userId: Auth.getUser().uid, update: update);
    } catch (e) {
      if (Constants.devMode) {
        // ignore: avoid_print
        print('======================= Skin Customization Update Error: $e');
      }
      showSnackBar(context: state.context, message: 'Skin Update Error: $e');
    }

    state.render(() {});
    // ignore: use_build_context_synchronously
    showSnackBar(
        context: state.context, message: 'Successfully Customized Kirby!');
  }

  /*
  This function recieves a string of the filepath of the image and 
  updates the background option of the KirbyPet in the firebase
  */
  void updateBackgroundCustomization(String customization) async {
    if (state.screenModel.kirbyPet != null) {
      state.screenModel.kirbyPet!.background = customization;
    }
    try {
      Map<String, dynamic> update = {};
      update[DocKeyPet.background.name] = customization;
      await FirestoreController.updatePet(
          userId: Auth.getUser().uid, update: update);
    } catch (e) {
      if (Constants.devMode) {
        // ignore: avoid_print
        print(
            '======================= Background Customization Update Error: $e');
      }
      showSnackBar(
          context: state.context, message: 'Background Update Error: $e');
    }

    state.render(() {});
    // ignore: use_build_context_synchronously
    showSnackBar(
        context: state.context, message: 'Successfully Customized Background!');
  }

  //Adds a purchased item to the database
  void purchaseItem(Customization customization) async {
    if (customization.price > state.screenModel.kirbyUser!.currency!) {
      Navigator.of(state.context).pop();
      showSnackBar(
          context: state.context,
          message: "You don't have enough coins to purchase this!");
      return;
    } else {
      var tempItem = PurchasedItem(
        userId: Auth.getUser().uid,
        label: customization.label,
        filepath: customization.filepath,
        price: customization.price,
      );

      await FirestoreController.addPurchasedItem(purchasedItem: tempItem);

      //Deduct Coins
      var userCoins = state.screenModel.kirbyUser!.currency!;
      userCoins -= customization.price;

      await FirestoreController.updateKirbyUser(
        userId: Auth.getUser().uid,
        update: {'currency': userCoins},
      );

      //Update Screen
      if (state.mounted) {
        Navigator.of(state.context).pop();
      } else {
        return;
      }
      state.screenModel.purchasedItemsList =
          await FirestoreController.getPurchasedItemsList(
              uid: Auth.getUser().uid);
      state.screenModel.kirbyUser =
          await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
      state.render(() {});
      // ignore: use_build_context_synchronously
      showSnackBar(
          context: state.context,
          message: "You've purchased the ${customization.label}!");
    }
  }
}
