import 'package:flutter/material.dart';

class ArticlesShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return new Center(
      child: new Text(
        'Articles: TODO',
        style: textTheme.headline6.copyWith(color: Colors.white),
      ),
    );
  }
}