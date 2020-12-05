import 'dart:math' show Random;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/models/models.dart';
import 'package:future_sale/screens/goods/goods.dart';
import 'package:future_sale/screens/screens.dart';

class CatalogueList extends StatefulWidget {
  @override
  _CatalogueListState createState() => _CatalogueListState();
}

class _CatalogueListState extends State<CatalogueList> {
  final random = Random();
  final List<GoodBean> products = [];
  final primaryColor = Color.fromRGBO(191, 212, 228, 1);

  @override
  void initState() {
    final generatedProducts = List<GoodBean>.generate(50, (index) {
      final rnd = random.nextInt(4);
      final imageUrl = 'assets/images/book_0$rnd.jpg';

      return GoodBean(
        images: [imageUrl],
        name: 'Book #${index.toString().padLeft(2, '0')}',
      );
    });

    products.addAll(generatedProducts);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Catalogue'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(MaterialCommunityIcons.filter),
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSection(
                'Future Sale',
              ),
              _buildSection(
                'Bet Deals',
              ),
              _buildSection(
                'Sale now',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddNewGoodPressed,
        child: Icon(
          MaterialCommunityIcons.shopping,
        ),
      ),
    );
  }

  Widget _buildSection(String sectionTitle) {
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
                style: theme.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
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
          height: 320,
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('goods').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final docsList = snapshot.data.docs;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: docsList.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(docsList[index]);
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
        )
      ],
    );
  }

  Widget _buildProductCard(QueryDocumentSnapshot snapshot) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    final images = List<String>.from(snapshot.get('images') as List<dynamic>);
    final firstImage = images.first;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ProductOverview(
            product: GoodBean(
              name: snapshot.get('name') as String,
              cost: double.parse(snapshot.get('cost').toString()),
              images: images,
            ),
          ),
        ));
      },
      child: Container(
        width: (screenSize.width / 2) - 24,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
          border: Border.all(
            color: primaryColor,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              color: primaryColor,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FutureBuilder<String>(
                    future: FirebaseStorage.instance.ref('/images/$firstImage').getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Image(
                          image: NetworkImage(snapshot.data),
                          fit: BoxFit.cover,
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Center(
                        child: Icon(
                          MaterialIcons.image,
                          size: 64,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MaterialCommunityIcons.camera,
                                size: 15,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text('10'),
                            ],
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            MaterialCommunityIcons.alarm,
                            size: 15,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text('Use until 10.11.2020'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '\$100',
                    style: theme.textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'The Free People',
                    style: theme.textTheme.subtitle1.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Peasant Top Shirt',
                    style: theme.textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      'Los Angeles',
                      style: theme.textTheme.caption,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(MaterialCommunityIcons.account_circle),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text('5.0'),
                      Icon(
                        MaterialCommunityIcons.star,
                        size: 12.0,
                        color: primaryColor,
                      ),
                      Spacer(),
                      Icon(MaterialCommunityIcons.heart_outline),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddNewGoodPressed() async {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => GoodsCreate(),
    ));
  }
}
