import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DetailsHeader extends Builder {
  DetailsHeader({
    Key key,
    Color actionColor = Colors.black87,
    VoidCallback onPressed
  }) : super(
          key: key,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.chevron_left,
                      size: 32,
                      color: actionColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.upload,
                      size: 32,
                      color: actionColor,
                    ),
                    onPressed: onPressed,
                  ),
                ],
              ),
            );
          },
        );
}
