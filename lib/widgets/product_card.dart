import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/utils/utils.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.cost,
    this.images,
    this.name,
    this.saleUntil,
    this.onProductPressed,
    this.onSellerPressed,
  }) : super(key: key);

  final double cost;
  final List<String> images;
  final String name;
  final String saleUntil;
  final VoidCallback onProductPressed;
  final VoidCallback onSellerPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    final firstImage = images.first;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onProductPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Container(
            width: (screenSize.width / 2) - 24,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  color: Palette.primaryColor,
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
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    MaterialCommunityIcons.camera,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    images.length.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (saleUntil != null)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 8,
                              bottom: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Palette.tertiaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  MaterialCommunityIcons.alarm,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  saleUntil,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
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
                        '\$$cost',
                        style: theme.textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        name,
                        style: theme.textTheme.subtitle2.copyWith(
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Text(
                        'Short description',
                        style: theme.textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Palette.secondaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Text(
                          'Los Angeles',
                          style: theme.textTheme.caption.copyWith(
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: onSellerPressed,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  MaterialCommunityIcons.account_circle,
                                  color: Palette.secondaryColor,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  '5.0',
                                  style: theme.textTheme.bodyText2.copyWith(
                                    color: Palette.secondaryColor,
                                  ),
                                ),
                                Icon(
                                  MaterialCommunityIcons.star,
                                  color: Colors.yellow,
                                  size: 16.0,
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          Icon(
                            MaterialCommunityIcons.heart_outline,
                            color: Palette.secondaryColor,
                            size: 20.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
