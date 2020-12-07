import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/screens/catalogue/catalogue.dart';
import 'package:future_sale/utils/utils.dart';
import 'package:future_sale/widgets/widgets.dart';

import 'goods/goods.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _screens = [];
  int _currentTab = 0;

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
              onPressed: () {},
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
        onPressed: _handlePlusPressed,
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

  void _handlePlusPressed() async {
    final theme = Theme.of(context);

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What do you want to sell?',
                style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w600, color: Palette.secondaryColor),
              ),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Palette.tertiaryColor,
                      width: 1,
                    ),
                    color: Palette.tertiaryColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MaterialCommunityIcons.alarm,
                        size: 32,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Future Sale',
                        style: theme.textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Palette.tertiaryColor,
                      width: 1,
                    ),
                    color: Palette.tertiaryColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesome.money,
                        size: 32,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Sale now',
                        style: theme.textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => GoodsCreate(),
    ));
  }
}
