import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/utils/utils.dart';
import 'package:future_sale/widgets/widgets.dart';

class SellerLanding extends StatefulWidget {
  @override
  _SellerLandingState createState() => _SellerLandingState();
}

class _SellerLandingState extends State<SellerLanding> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cindy Crawford'),
      ),
      body: ScreenContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image(
                          image: AssetImage('assets/images/user_photo.jpg'),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'John Smith',
                        style: theme.textTheme.headline6.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        'USA, LA',
                        style: theme.textTheme.subtitle2.copyWith(
                          height: 1.5,
                          color: Palette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('5.0', style: theme.textTheme.headline6),
                          Icon(MaterialCommunityIcons.star),
                        ],
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.primaryColor,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  '35%',
                                  style: theme.textTheme.subtitle1,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              width: double.infinity,
                              color: Palette.secondaryColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'CO2',
                                    style: theme.textTheme.subtitle1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Saved',
                                    style: theme.textTheme.bodyText2.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '20',
                              style: theme.textTheme.headline6,
                            ),
                            Text(
                              'ECO points',
                              style: theme.textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'Interests: swimming, tennis, football',
                  style: theme.textTheme.subtitle1.copyWith(
                    color: Palette.secondaryColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Sell NEW',
                          style: theme.textTheme.headline5,
                        ),
                        _buildStatItem(MaterialIcons.directions_bike, 'x1'),
                        _buildStatItem(MaterialCommunityIcons.book, 'x10'),
                        _buildStatItem(MaterialIcons.tv, 'x2'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Future SELL',
                          style: theme.textTheme.headline5,
                        ),
                        _buildStatItem(MaterialCommunityIcons.bow_tie, 'x1'),
                        _buildStatItem(MaterialCommunityIcons.link_box, 'x1'),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total SOLD OUT = 16 products',
                      style: theme.textTheme.subtitle1,
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'View details',
                        style: theme.textTheme.subtitle1.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Saved Planet Resources',
                      style: theme.textTheme.headline6,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _buildStatItem(MaterialIcons.directions_bike, 'x1'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Text(
                            '≅',
                            style: theme.textTheme.headline6,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '250kg',
                                style: theme.textTheme.headline6,
                              ),
                              SizedBox(width: 8,),
                              Text(
                                'CO2',
                                style: theme.textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _buildStatItem(MaterialIcons.book, 'x10'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Text(
                            '≅',
                            style: theme.textTheme.headline6,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '30',
                                style: theme.textTheme.headline6,
                              ),
                              SizedBox(width: 8,),
                              Icon(MaterialCommunityIcons.tree_outline),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child:
                    Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(
                    'Feedback',
                    style: theme.textTheme.headline6,
                  ),
                  _buildFeedbackItem(),
                  _buildFeedbackItem(),
                  _buildFeedbackItem(),
                  _buildFeedbackItem(),
                  _buildFeedbackItem(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            label,
            style: theme.textTheme.headline6,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image(
              image: AssetImage('assets/images/user_photo.jpg'),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Julia Roberts',
                  style: theme.textTheme.headline6.copyWith(
                    color: Palette.primaryColor,
                  ),
                ),
                Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                  style: theme.textTheme.bodyText2.copyWith(
                    height: 1.5,
                    color: Palette.secondaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
