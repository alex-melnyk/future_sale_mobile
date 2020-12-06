import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/models/models.dart';
import 'package:future_sale/utils/palette.dart';
import 'package:future_sale/widgets/widgets.dart';

class ProductOverviewNow extends StatefulWidget {
  const ProductOverviewNow({
    Key key,
    this.product,
  }) : super(key: key);

  final GoodBean product;

  @override
  _ProductOverviewNowState createState() => _ProductOverviewNowState();
}

class _ProductOverviewNowState extends State<ProductOverviewNow> {
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: ScreenContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: _buildGallery(),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: _buildTitle(),
                  ),
                ],
              ),
              _buildStatLine(),
              _buildProductPhotos(),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Description',
                      style: theme.textTheme.headline5.copyWith(
                        color: Palette.primaryColor,
                      ),
                    ),
                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged',
                      style: theme.textTheme.subtitle1.copyWith(
                        color: Palette.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              _buildSpecifications(),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: RaisedButton(
                  onPressed: () {},
                  child: Text('RECYCLE REQUEST'),
                ),
              ),
            ],
          ),
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

          return PageView(
            children: imagesUrls.map<Widget>((e) {
              return Container(
                width: screenSize.width,
                child: Image(
                  image: NetworkImage(e),
                  fit: BoxFit.cover,
                ),
              );
            }).toList(growable: false),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.product.name,
            style: theme.textTheme.headline5.copyWith(
              color: Palette.secondaryColor,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Category: Electronics',
            style: theme.textTheme.subtitle1.copyWith(
              color: Palette.secondaryColor,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Type: NEW',
            style: theme.textTheme.subtitle1.copyWith(
              color: Palette.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatLine() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '54',
                    style: theme.textTheme.subtitle1.copyWith(
                      color: Palette.secondaryColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    MaterialCommunityIcons.heart,
                    color: Palette.primaryColor,
                    size: 32,
                  )
                ],
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Seller',
                style: theme.textTheme.headline6.copyWith(
                  color: Palette.primaryColor,
                ),
              ),
              Text(
                'Susanna Won (USA, LA)',
                style: theme.textTheme.subtitle1.copyWith(
                  color: Palette.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductPhotos() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // width: 80,
            // height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Palette.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              MaterialCommunityIcons.image,
              size: 80,
              color: Palette.primaryColor,
            ),
          ),
          Container(
            // width: 80,
            // height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Palette.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              MaterialCommunityIcons.image,
              size: 80,
              color: Palette.primaryColor,
            ),
          ),
          Container(
            // width: 80,
            // height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Palette.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              MaterialCommunityIcons.image,
              size: 80,
              color: Palette.primaryColor,
            ),
          ),
          Container(
            // width: 80,
            // height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Palette.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              MaterialCommunityIcons.image,
              size: 80,
              color: Palette.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Product Lifecycle',
            textAlign: TextAlign.center,
            style: theme.textTheme.headline5.copyWith(
              color: Palette.secondaryColor,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MaterialCommunityIcons.tree,
                        size: 64,
                        color: Palette.primaryColor,
                      ),
                      Text(
                        '300',
                        style: theme.textTheme.headline6.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        'trees\nsaved',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText2.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MaterialCommunityIcons.periodic_table_co2,
                        size: 64,
                        color: Palette.primaryColor,
                      ),
                      Text(
                        '150',
                        style: theme.textTheme.headline6.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        'kg\nyearly',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText2.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MaterialCommunityIcons.forward,
                        size: 64,
                        color: Palette.primaryColor,
                      ),
                      Text(
                        '1st\nbuy',
                        style: theme.textTheme.headline6.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        '2019, Jun',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText2.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
