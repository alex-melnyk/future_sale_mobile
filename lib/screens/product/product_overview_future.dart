import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/models/models.dart';
import 'package:future_sale/screens/screens.dart';
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
      body: ScreenContainer(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildGallery(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTitle(),
                        Container(
                          width: double.infinity,
                          child: Text(
                            widget.product.name,
                            style: theme.textTheme.headline5.copyWith(
                              color: Palette.secondaryColor,
                            ),
                          ),
                        ),
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
                                'How to buy',
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
                        _buildSellerDetails(),
                        Divider(),
                        _buildSpecifications(),
                      ],
                    ),
                  ),
                  _buildButtons(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: DetailsHeader(actionColor: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: 320,
      child: FutureBuilder(
        future: _imageUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final imagesUrls = snapshot.data ?? [];

            return Stack(
              children: [
                PageView(
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    // height: 60,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          height: 24,
                          decoration: BoxDecoration(
                            color: Palette.tertiaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MaterialCommunityIcons.alarm,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'User until 10.11.2020',
                                style: theme.textTheme.caption.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          height: 24,
                          decoration: BoxDecoration(
                            color: Palette.quaternaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Like a new',
                                style: theme.textTheme.caption.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MaterialCommunityIcons.camera,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '1/10',
                                style: theme.textTheme.caption.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
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

  Widget _buildTitle() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '\$100',
                style: theme.textTheme.headline5.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Book for ',
                style: theme.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Palette.secondaryColor,
                ),
              ),
              Text(
                '\$10',
                style: theme.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Palette.tertiaryColor,
                ),
              ),
              Spacer(),
              Icon(MaterialCommunityIcons.heart_outline),
            ],
          ),
          SizedBox(
            height: 16,
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
            style: theme.textTheme.bodyText2.copyWith(
              color: Palette.secondaryColor,
              fontWeight: FontWeight.w400,
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

  Widget _buildSellerDetails() {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SellerLanding(),
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  Row(
                    children: [
                      Text(
                        'Julia Roberts',
                        style: theme.textTheme.headline6.copyWith(
                          color: Palette.secondaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '5.0',
                        style: theme.textTheme.bodyText2.copyWith(
                          height: 1.5,
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Icon(
                        MaterialCommunityIcons.star,
                        size: 16,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  Text(
                    'Los Angeles',
                    style: theme.textTheme.bodyText2.copyWith(
                      height: 1.5,
                      color: Palette.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(MaterialCommunityIcons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecifications() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Product Lifecycle',
              style: theme.textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
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
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.deepOrange,
                        width: 2,
                      )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '150kg',
                          style: theme.textTheme.subtitle2.copyWith(
                            color: Palette.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'CO2/year',
                          style: theme.textTheme.subtitle2.copyWith(
                            color: Palette.secondaryColor,
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
                          MaterialCommunityIcons.periodic_table_co2,
                          size: 64,
                          color: Palette.primaryColor,
                        ),
                        Text(
                          '0% carbon free',
                          style: theme.textTheme.subtitle1.copyWith(
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
                          MaterialCommunityIcons.water,
                          size: 64,
                          color: Palette.primaryColor,
                        ),
                        Text(
                          '300 saved',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle1.copyWith(
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
      ),
    );
  }

  Widget _buildButtons() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Palette.tertiaryColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Rent',
                  style: theme.textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Palette.tertiaryColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Palette.tertiaryColor,
                    width: 1,
                  ),
                  color: Palette.tertiaryColor,
                ),
                child: Text(
                  'Book',
                  style: theme.textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
