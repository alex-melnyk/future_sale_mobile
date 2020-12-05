import 'package:flutter/material.dart';

class ContentLayout extends LayoutBuilder {
  ContentLayout({
    Key key,
    Widget child,
  }) : super(
          key: key,
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: child,
                ),
              ),
            );
          },
        );
}
