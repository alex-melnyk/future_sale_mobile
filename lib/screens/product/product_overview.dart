import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:future_sale/models/models.dart';

class ProductOverview extends StatefulWidget {
  const ProductOverview({
    Key key,
    this.product,
  }) : super(key: key);

  final GoodBean product;

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  Future<List<String>> _imageUrlsFuture;

  @override
  void initState() {
    _imageUrlsFuture = Future.wait(widget.product.images
        .map((e) => FirebaseStorage.instance.ref('/images/$e').getDownloadURL())
        .toList(growable: true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildGallery(),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    final screenSize = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _imageUrlsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final imagesUrls = snapshot.data ?? [];

          return Container(
            height: 320,
            child: PageView(
              children: imagesUrls.map<Widget>((e) {
                return Container(
                  width: screenSize.width,
                  child: Image(
                    image: NetworkImage(e),
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(growable: false),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildTitle() {
    final theme = Theme.of(context);
    final price = widget.product.cost.toString().padLeft(1, '0');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.product.name,
            style: theme.textTheme.headline4,
          ),
          Text(
            '\$$price',
            style: theme.textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
