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
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('goods').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.count(
                padding: const EdgeInsets.all(4),
                crossAxisCount: 2,
                children: snapshot.data.docs.map((e) => _buildProductCard(e)).toList(growable: false),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
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

  Widget _buildProductCard(QueryDocumentSnapshot snapshot) {
    final theme = Theme.of(context);

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
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 120,
                color: Colors.grey,
                child: FutureBuilder<String>(
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
                      child: Icon(MaterialCommunityIcons.image),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'product name',
                        style: theme.textTheme.bodyText1,
                      ),
                      Text(
                        'Description of a book...',
                        style: theme.textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
