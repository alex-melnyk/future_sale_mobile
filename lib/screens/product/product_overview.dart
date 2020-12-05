import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
  final _imagesController = PageController(
    initialPage: 0,
  );
  Future<List<String>> _imagesUrls;

  @override
  void initState() {
    _imagesUrls = Future.wait(widget.product.images.map((e) => FirebaseStorage.instance.ref('/images/$e').getDownloadURL()).toList(growable: true));

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
          ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: 320,
      child: PageView(
        controller: _imagesController,
        children: widget.product.images.map((e) {
          return Container(
            width: 320,
            height: 320,
            child: FutureBuilder<String>(
              future: FirebaseStorage.instance.ref('/images/$e').getDownloadURL(),
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
          );
        }).toList(growable: false),
      ),
    );
  }
}
