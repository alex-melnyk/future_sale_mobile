import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/screens/screens.dart';
import 'package:future_sale/utils/utils.dart';
import 'package:future_sale/widgets/screen_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntoLanding extends StatefulWidget {
  @override
  _LandonState createState() => _LandonState();
}

class _LandonState extends State<IntoLanding> {
  final _pageViewController = PageController();
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ScreenContainer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _pageIndex != 0
                      ? IconButton(
                          onPressed: _handleBackPressed,
                          icon: Icon(
                            MaterialCommunityIcons.chevron_left,
                            size: 32,
                          ),
                        )
                      : Container(),
                  FlatButton(
                    onPressed: _handleNavigateToHome,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageViewController,
                onPageChanged: (index) => setState(() {
                  _pageIndex = index;
                }),
                children: [
                  // SLIDE 01
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(),
                      Image(image: AssetImage('assets/images/intro_1.png')),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        margin: EdgeInsets.only(
                          top: 50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Lorem Ipsum is\nsimple dummy',
                              style: theme.textTheme.headline4.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Lorem Ipsum is simple dummy',
                              style: theme.textTheme.subtitle1.copyWith(
                                height: 2,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // SLIDE 02
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        margin: EdgeInsets.only(bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Lorem Ipsum is\nsimple dummy',
                              style: theme.textTheme.headline4.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Lorem Ipsum is simple dummy',
                              style: theme.textTheme.subtitle1.copyWith(
                                height: 2,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image(image: AssetImage('assets/images/intro_2.png')),
                    ],
                  ),
                  // SLIDE 03
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(),
                      Image(image: AssetImage('assets/images/intro_3.png')),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        margin: EdgeInsets.only(
                          top: 50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Lorem Ipsum is\nsimple dummy',
                              style: theme.textTheme.headline4.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Lorem Ipsum is simple dummy',
                              style: theme.textTheme.subtitle1.copyWith(
                                height: 2,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPageIndicator(),
                  InkWell(
                    onTap: _handleNextPressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        color: Palette.tertiaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        _pageIndex < 2 ? 'NEXT' : 'START',
                        style: theme.textTheme.subtitle1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    final indicators = List<Widget>.generate(3, (index) {
      final selected = _pageIndex == index;

      return Container(
        width: selected ? 50 : 15,
        height: 15,
        decoration: BoxDecoration(
          color: selected ? Palette.tertiaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Palette.tertiaryColor,
            width: 1,
          ),
        ),
      );
    });

    return Container(
      width: 96,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: indicators,
      ),
    );
  }

  void _handleBackPressed() {
    _pageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleNextPressed() {
    if (_pageIndex == 2) {
      _handleNavigateToHome();
    } else {
      _pageViewController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNavigateToHome() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setBool('intro', true);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => Home(),
    ));
  }
}
