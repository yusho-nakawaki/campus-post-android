import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../friends_model.dart';
import 'footer/friend_detail_footer.dart';
import 'friend_detail_body.dart';
import 'header/friend_detail_header.dart';

class FriendDetailsPage extends StatefulWidget {
  FriendDetailsPage({
    this.friend,
    this.avatarTag,
    this.isFriend,
    this.isMe
  });

  final Friend friend;
  final Object avatarTag;
  final bool isFriend;
  final bool isMe;

  @override
  _FriendDetailsPageState createState() => new _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FriendDetailHeader(
                friend: widget.friend,
                avatarTag: widget.avatarTag,
                isFriend: widget.isFriend,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new FriendDetailBody(widget.friend),
              ),
              new FriendShowcase(widget.friend),
            ],
          ),
        ),
      ),
    );
  }
}
