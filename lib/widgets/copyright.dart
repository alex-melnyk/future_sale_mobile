import 'package:flutter/material.dart';

class Copyright extends Builder {
  Copyright({Key key})
      : super(
          key: key,
          builder: (context) {
            final theme = Theme.of(context);

            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
              ),
              child: Text(
                'Powered by LITSLINK',
                style: theme.textTheme.overline.copyWith(
                  color: theme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        );
}
