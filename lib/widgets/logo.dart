import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Logo extends Builder {
  Logo({Key key})
      : super(
          key: key,
          builder: (context) {
            final theme = Theme.of(context);

            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 48.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    MaterialCommunityIcons.shopping,
                    size: 48,
                    color: theme.primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Future Sale',
                    style: theme.textTheme.headline3.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        );
}
