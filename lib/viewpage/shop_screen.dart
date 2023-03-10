import 'package:capstone/model/shop_screen_model.dart';
import 'package:capstone/viewpage/home_screen.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
import '../model/constants.dart';
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
  }

  void render(fn) => setState(fn);
  int _selectedIndex = 0;

  final ScrollController _homeController = ScrollController();

  Widget _listViewBody(int menuOption) {
    switch (menuOption) {
      case 0: //Skins
        return ListView.separated(
          controller: _homeController,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                skinCustomizations[index],
              ),
              onTap: () =>
                  con.updateSkinCustomization(skinCustomizations[index]),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            thickness: 5,
          ),
          itemCount: 3,
        );
      case 1: //Backgrounds
        // return ListView.separated(
        //   controller: _homeController,
        //   itemBuilder: (BuildContext context, int index) {
        //     return ListTile(
        //       title: Text(
        //         skinCustomizations[index],
        //       ),
        //       onTap: () => con.updateSkinCustomization(skinCustomizations[index]),
        //     );
        //   },
        //   separatorBuilder: (BuildContext context, int index) => const Divider(
        //         thickness: 5,
        //       ),
        //   itemCount: skinCustomizations.length,
        // );
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
                con.skinsList();
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
    if (!state.mounted) return;
    showSnackBar(
        context: state.context, message: 'Successfully Customized Kirby!');
  }

  void skinsList() {}
}
