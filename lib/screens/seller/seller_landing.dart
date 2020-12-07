import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/models/models.dart';
import 'package:future_sale/screens/screens.dart';
import 'package:future_sale/utils/utils.dart';
import 'package:future_sale/widgets/widgets.dart';

class SellerLanding extends StatefulWidget {
  @override
  _SellerLandingState createState() => _SellerLandingState();
}

class _SellerLandingState extends State<SellerLanding> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ScreenContainer(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: Palette.tertiaryColor,
                      ),
                    ),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: Image(
                        image: AssetImage('assets/images/user_photo.jpg'),
                      ),
                    ),
                  ),
                  _buildDetails(),
                  Divider(),
                  _buildDescription(),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Feedback (10)',
                          style: theme.textTheme.subtitle1.copyWith(
                            color: Palette.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(MaterialCommunityIcons.chevron_right),
                      ],
                    ),
                  ),
                  Divider(),
                  _buildSections(),
                  _buildProducts(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: DetailsHeader(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(),
            child: Text(
              '35% CO2 saved',
              style: theme.textTheme.subtitle1.copyWith(
                color: Palette.primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Carole Chimako ',
                  style: theme.textTheme.headline6.copyWith(
                    color: Palette.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '5.0',
                  style: theme.textTheme.headline6.copyWith(
                    color: Palette.secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  MaterialCommunityIcons.star,
                  color: Colors.yellow,
                  size: 16,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(),
            child: Text(
              'Los Angeles',
              style: theme.textTheme.subtitle1.copyWith(
                color: Palette.primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Palette.tertiaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Follow',
                style: theme.textTheme.subtitle1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Description',
            style: theme.textTheme.subtitle1.copyWith(
              color: Palette.secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            style: theme.textTheme.bodyText1.copyWith(
              height: 1.25,
              color: Palette.secondaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSections() {
    final theme = Theme.of(context);

    final sections = [
      'Future Sale',
      'Sale Now'
    ].asMap().map((key, value) {
      return MapEntry(key, Expanded(
        child: InkWell(
          onTap: () => setState(() => _selectedSection = key),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            color: _selectedSection == key ? Palette.tertiaryColor : Colors.white,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: theme.textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w400,
                color: _selectedSection == key ? Colors.white : Palette.secondaryColor,
              ),
            ),
          ),
        ),
      ));
    }).values.toList(growable: false);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 4
            ),
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Palette.tertiaryColor,
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: sections,
              ),
            ),
          ),
          SizedBox(height: 4,),
          // TODO: ADD PRODUCTS
        ],
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

  Widget _buildProducts() {
    return Container(
      height: 326,
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('goods').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final docsList = snapshot.data.docs;

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: docsList.length,
              itemBuilder: (context, index) {
                return _buildProductCard(docsList[index], index % 2 != 0);
              },
              separatorBuilder: (context, index) => SizedBox(width: 8.0),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildProductCard(QueryDocumentSnapshot snapshot, bool sellNow) {
    final images = List<String>.from(snapshot.get('images') as List<dynamic>);

    return ProductCard(
      images: images,
      cost: double.parse(snapshot.get('cost').toString()),
      name: snapshot.get('name').toString(),
      saleUntil: sellNow ? null : 'Use until 10.11.2020',
      onProductPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) {
            if (sellNow) {
              return ProductOverviewNow(
                product: GoodBean(
                  name: snapshot.get('name') as String,
                  cost: double.parse(snapshot.get('cost').toString()),
                  images: images,
                ),
              );
            } else {
              return ProductOverviewFuture(
                product: GoodBean(
                  name: snapshot.get('name') as String,
                  cost: double.parse(snapshot.get('cost').toString()),
                  images: images,
                ),
              );
            }
          },
        ));
      },
    );
  }
}
