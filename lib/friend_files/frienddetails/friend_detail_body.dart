import 'package:flutter/material.dart';

import '../friends_model.dart';


class FriendDetailBody extends StatelessWidget {
  FriendDetailBody(this.friend);
  final Friend friend;


  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          friend.name,
          style: textTheme.headline.copyWith(color: Colors.white),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Text(
            friend.introduction,
            style:
                textTheme.bodyText2.copyWith(color: Colors.white70, fontSize: 16.0),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBadge(Icons.beach_access, theme.accentColor),
              _createCircleBadge(Icons.cloud, Colors.white12),
              _createCircleBadge(Icons.shop, Colors.white12),
            ],
          ),
        ),
      ],
    );
  }
}
