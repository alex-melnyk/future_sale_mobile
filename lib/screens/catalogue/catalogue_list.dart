import 'dart:math' show Random;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/modals/modals.dart';
import 'package:future_sale/models/models.dart';
import 'package:future_sale/screens/screens.dart';
import 'package:future_sale/utils/utils.dart';
import 'package:future_sale/widgets/product_card.dart';
import 'package:future_sale/widgets/screen_container.dart';

class CatalogueList extends StatefulWidget {
  @override
  _CatalogueListState createState() => _CatalogueListState();
}

class _CatalogueListState extends State<CatalogueList> {
  final random = Random();

  String _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScreenContainer(
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: 50,
          ),
          clipBehavior: Clip.none,
          child: Column(
            children: [
              _buildSearch(),
              _buildFilters(),
              _buildBanner(),
              _buildSection(
                'Future Sale',
              ),
              _buildSection(
                'Bet Deals',
              ),
              _buildSection(
                'Sale now',
                sellNow: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            MaterialIcons.search,
            color: Palette.secondaryColor,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            fontSize: 18,
            color: Palette.secondaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Palette.primaryColor,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Palette.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilter(
            MaterialCommunityIcons.grid,
            'Categories',
            onPressed: _handleCategoriesPressed,
          ),
          _buildFilter(
            MaterialCommunityIcons.alarm,
            'Future Sale',
          ),
          _buildFilter(
            MaterialCommunityIcons.moon_new,
            'Sale now',
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      width: double.infinity,
      height: 180,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Palette.primaryColor, borderRadius: BorderRadius.circular(5)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage('assets/images/banner.png'),
            fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Future Sale',
                  style: theme.textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Sell today what you buy\ntomorrow',
                    style: theme.textTheme.bodyText2,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Palette.tertiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'START',
                      style: TextStyle(
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
    );
  }

  Widget _buildFilter(
    IconData icon,
    String label, {
    VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Palette.tertiaryColor.withOpacity(0.15),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Palette.tertiaryColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Palette.tertiaryColor,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  label,
                  style: theme.textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Palette.tertiaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String sectionTitle, {bool sellNow = false}) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionTitle,
                style: theme.textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'View all',
                style: theme.textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.underline,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 326,
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('goods').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final docsList = snapshot.data.docs;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: docsList.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(docsList[index], sellNow);
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
        ),
      ],
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
      onSellerPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SellerLanding(),
        ));
      },
    );
  }

  void _handleSellerPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SellerLanding(),
    ));
  }

  void _handleCategoriesPressed() async {
    final category = await showCategoriesModal(context);

    if (category != null) {
      setState(() {
        _selectedCategory = category;
      });
    }
  }
}
