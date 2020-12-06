import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/screens/catalogue/catalogue.dart';
import 'package:future_sale/screens/goods/goods.dart';
import 'package:future_sale/utils/utils.dart';
import 'package:future_sale/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _screens = [];
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'FutureSale',
          style: TextStyle(
            color: Palette.tertiaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                SimpleLineIcons.handbag,
                color: Color.fromRGBO(89, 115, 147, 1),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_currentTab],
      bottomNavigationBar: FABBottomAppBar(
        // notchedShape: CircularNotchedRectangle(),
        color: Palette.secondaryColor,
        selectedColor: Palette.primaryColor,
        items: [
          FABBottomAppBarItem(iconData: MaterialCommunityIcons.home_outline),
          FABBottomAppBarItem(iconData: MaterialCommunityIcons.heart_outline),
          FABBottomAppBarItem(iconData: MaterialCommunityIcons.bell_outline),
          FABBottomAppBarItem(iconData: MaterialCommunityIcons.account_outline),
        ],
        onTabSelected: (value) => setState(() {
          _currentTab = value;
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => GoodsCreate(),
          ));
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Color.fromRGBO(9, 152, 255, 0.7),
              width: 2.0,
            ),
          ),
          child: Icon(
            MaterialCommunityIcons.plus,
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromRGBO(50, 197, 255, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void initState() {
    _screens.addAll([
      CatalogueList(),
      Container(
        color: Colors.red,
      ),
      Container(
        color: Colors.green,
      ),
      Container(
        color: Colors.blue,
      ),
    ]);

    super.initState();
  }
}
