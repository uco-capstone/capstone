import 'package:capstone/model/shop_screen_model.dart';
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
    con.getPet();
  }

  void render(fn) => setState(fn);
  int _selectedIndex = 0;

  final ScrollController _homeController = ScrollController();

  Widget _listViewBody(int menuOption) {
    switch (menuOption) {
      case 0: //Skins
        return GridView.builder(
          controller: _homeController,
          itemBuilder: (BuildContext context, int index) {
            return Align(
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.45,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                              child: Text(skinCustomizations[index].label)
                            ),
                            Positioned(
                              right: 0,
                              top: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.width * 0.08,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                                    //border: Border.all(color: Colors.deepPurple, width: 2)
                                  ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Sample number of coins
                                    Text('${skinCustomizations[index].price} '),
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.orangeAccent,
                                      size: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () =>
                            con.updateSkinCustomization(skinCustomizations[index].filepath),
                      ),
                      if (skinCustomizations[index].filepath == screenModel.kirbyPet!.kirbySkin)
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
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: skinCustomizations.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        );
      case 1:  //Backgrounds
        return ListView.separated(
          controller: _homeController,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                backgroundCustomizations[index].label,
              ),
              onTap: () => con.updateBackgroundCustomization(backgroundCustomizations[index].filepath),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
                thickness: 5,
              ),
          itemCount: backgroundCustomizations.length,
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

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  //Sample number of coins
                  Text(
                    '0',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.monetization_on,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
        
      ),
      body: Center(
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
}

class _Controller {
  _ShopScreen state;
  _Controller(this.state);

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
    showSnackBar(context: state.context, message: 'Successfully Customized Kirby!');
  }
  
  void updateBackgroundCustomization(String customization) async {
    if(state.screenModel.kirbyPet != null) {
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
        print('======================= Background Customization Update Error: $e');
      }
      showSnackBar(context: state.context, message: 'Background Update Error: $e');
    }
  
    state.render(() {});
    // ignore: use_build_context_synchronously
    showSnackBar(context: state.context, message: 'Successfully Customized Background!');
  }

  void skinsList() {}
}
