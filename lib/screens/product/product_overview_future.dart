import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/models/models.dart';
import 'package:future_sale/utils/palette.dart';
import 'package:future_sale/widgets/widgets.dart';

class ProductOverviewFuture extends StatefulWidget {
  const ProductOverviewFuture({
    Key key,
    this.product,
  }) : super(key: key);

  final GoodBean product;

  @override
  _ProductOverviewFutureState createState() => _ProductOverviewFutureState();
}

class _ProductOverviewFutureState extends State<ProductOverviewFuture> {
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
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text('BUY'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text('RENT'),
                      ),
                    ),
                  ],
                ),
              ),
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
                'Time frame for',
                style: theme.textTheme.headline6.copyWith(
                  color: Palette.primaryColor,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sale: ',
                    style: theme.textTheme.headline6.copyWith(
                      color: Palette.secondaryColor,
                    ),
                  ),
                  Text(
                    '3-6 month',
                    style: theme.textTheme.headline6.copyWith(
                      color: Palette.secondaryColor,
                    ),
                  ),
                ],
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
                  width: 100,
                  height: 100,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2300',
                        style: theme.textTheme.subtitle1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'KG',
                        style: theme.textTheme.bodyText2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'CO2/year',
                        style: theme.textTheme.subtitle1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                        MaterialCommunityIcons.water,
                        size: 64,
                        color: Palette.primaryColor,
                      ),
                      Text(
                        '3000',
                        style: theme.textTheme.headline6.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        'litters\nsaved',
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
                        '0%',
                        style: theme.textTheme.headline6.copyWith(
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        'carbon\nfree',
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
