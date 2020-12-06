import 'package:flutter/material.dart';
import 'package:future_sale/utils/utils.dart';

Future<String> showCategoriesModal(BuildContext context) {
  final categories = <String>[
    'Fashion',
    'Books, Movies & Music',
    'Electronics',
    'Collectibles & Art',
    'Home & Garden',
    'Sporting Goods',
    'Toys & Hobbies',
    'Business & Industrial',
    'Health & Beauty',
    'Others',
  ];

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final theme = Theme.of(context);

      return DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8.0,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Palette.primaryColor.withOpacity(0.75), width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'OK',
                        style: theme.textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(categories[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Palette.primaryColor.withOpacity(0.75), width: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(24.0),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Palette.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              categories[index],
                              style: theme.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
