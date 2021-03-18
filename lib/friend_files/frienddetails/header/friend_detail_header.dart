import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../friends_model.dart';
import 'diagonally_cut_colored_image.dart';

class FriendDetailHeader extends StatelessWidget {

  static const BACKGROUND_IMAGE = 'assets/images/noImage.png';
  final _databaseReference = FirebaseDatabase.instance.reference();

  FriendDetailHeader({
    @required this.friend,
    @required this.avatarTag,
  });

  final Friend friend;
  final Object avatarTag;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _buildAvatar() {
    return new Hero(
      tag: avatarTag,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(friend.avatar),
        radius: 50.0,
      ),
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
        textTheme.subtitle1.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(friend.university ?? "未設定", style: followerStyle),
          new Text(calculate(int.parse(friend.age ?? "100") ?? 100), style: followerStyle),
          new Text(friend.faculty ?? "" , style: followerStyle),
          new Text(friend.university ?? "" , style: followerStyle),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createPillButton(
            'トーク',
            backgroundColor: theme.accentColor,
          ),
          _createPillButton(
            '時間割',
            backgroundColor: theme.accentColor,
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white30),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: _createPillButton(
              '友達追加',
              textColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPillButton(
    String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 100.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () async {
          if (text == 'トーク') {
            print("push talk");
            String conversationId = await isExistConversation();
            // if (conversationId == "null") {
            //   conversationId =
            // }
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => Chat(
            //           chatID: _conversation.id,
            //           partnerID: _conversation.partnerEmail,
            //           partnerName: _conversation.partnerName,
            //         )
            //     )
            // )
          }
          if (text == '時間割') {
            print('timetable');
          }
          if (text == '友達追加') {
            print("push friend");
          }
        },
        child: new Text(text),
      ),
    );
  }

  String calculate(int age) {
    // 「2021年度入学」から学年を計算する
    // 2月以降は次年度の学年を表す
    if (age == 100) { return ""; }
    int nowYear = int.parse(DateFormat('yyyy').format(DateTime.now().toLocal()));
    int gap = nowYear - age;
    if (int.parse(DateFormat('MM').format(DateTime.now().toLocal())) >= 2) {
      gap += 1;
      if (gap <= 0) { return "新１年生"; }
      if (gap == 1){ return "１年生"; }
      if (gap == 2){ return "２年生"; }
      if (gap == 3){ return "３年生"; }
      if (gap == 4){ return "４年生"; }
      if (gap >= 5){ return "院生"; }
      return "";
    }
    else {
      //1月の時
      if (gap <= 0) { return "新１年生"; }
      if (gap == 1){ return "１年生"; }
      if (gap == 2){ return "２年生"; }
      if (gap == 3){ return "３年生"; }
      if (gap == 4){ return "４年生"; }
      if (gap >= 5){ return "院生"; }
      return "";
    }
  }

  // チャット開始
  // 会話がすでに存在しているかをチャックする
  Future<String> isExistConversation() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String myEmail =  pref.get("email");
    String conversationId1 = "${friend.email}_$myEmail";
    String conversationId2 = "${myEmail}_${friend.email}";

    var snapshot = await _databaseReference
        .child('all_users')
        .child(myEmail)
        .child('conversations')
        .child(conversationId1)
        .child('id')
        .once();

    if (snapshot.value == null) {
      return conversationId1;
    }
    var snapshot2 = await _databaseReference
        .child('all_users')
        .child(myEmail)
        .child('conversations')
        .child(conversationId2)
        .child('id')
        .once();

    if (snapshot2.value != null) {
      return conversationId2;
    }
    return "null";
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              _buildActionButtons(theme),
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );
  }
}
