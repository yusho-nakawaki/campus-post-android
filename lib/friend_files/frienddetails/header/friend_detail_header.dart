
import 'package:campuspost/routes/chat_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database_sqlite.dart';
import '../../friends_model.dart';
import 'diagonally_cut_colored_image.dart';

class FriendDetailHeader extends StatefulWidget {

  FriendDetailHeader({
    @required this.friend,
    @required this.avatarTag,
    @required this.isFriend,
    this.isMe,
  });

  final Friend friend;
  final Object avatarTag;
  bool isFriend;
  bool isMe = false;

  @override _FriendDetailHeader createState() => new _FriendDetailHeader();
}

class _FriendDetailHeader extends State<FriendDetailHeader> {

  static const BACKGROUND_IMAGE = 'assets/images/noImage.png';
  final _databaseReference = FirebaseDatabase.instance.reference();
  DatabaseHelper _dbHelper = DatabaseHelper();

  // buildは最初に呼ばれるメソッド
  @override Widget build(BuildContext context) {
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
              _buildActionButtons(theme, context, widget.isFriend),
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
      tag: widget.avatarTag, //ただのindex
      child: new CircleAvatar(
        backgroundImage: (widget.friend.avatar == "") ? AssetImage('assets/images/noImage.png')
            : NetworkImage(widget.friend.avatar),
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
          new Text(widget.friend.university ?? "未設定", style: followerStyle),
          new Text(calculate(int.parse(widget.friend.age ?? "100") ?? 100), style: followerStyle),
          new Text(widget.friend.faculty ?? "" , style: followerStyle),
          new Text(widget.friend.university ?? "" , style: followerStyle),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, BuildContext context, bool isFriend) {
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
            context,
            'トーク',
            backgroundColor: theme.accentColor,
          ),
          _createPillButton(
            context,
            '時間割',
            backgroundColor: theme.accentColor,
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
              border: isFriend ? null : new Border.all(color: Colors.white30),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: _createPillButton(
              context,
              isFriend ? 'フォロー中' : '友達追加',
              textColor: Colors.white70,
              backgroundColor: isFriend ? theme.accentColor : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPillButton(
      BuildContext context,
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
            String conversationId = await isExistConversation();
            bool isNew = false;
            if (conversationId == "null") {
              isNew = true;
              SharedPreferences pref = await SharedPreferences.getInstance();
              String myEmail =  pref.get("email");
              conversationId = "${widget.friend.email}_$myEmail";
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                      chatID: conversationId,
                      partnerID: widget.friend.email,
                      partnerName: widget.friend.name,
                      isNew: isNew,
                    )
                )
            );

          }
          if (text == '時間割') {
            // 友達の時間割を見る

          }
          if (text == '友達追加') {
            // フォロー
            dynamic _myFriends = await _dbHelper.getMyFriends();
            if (_myFriends is List<String>) {
              _myFriends.add(widget.friend.email);
              await _dbHelper.insertFriend(widget.friend.email, _myFriends.length);
            }
            else {
              await _dbHelper.insertFriend(widget.friend.email, 0);
            }

            widget.isFriend = true;
            setState(() {});
          }
          if (text == 'フォロー中') {
            // フォローを解除
            // dynamic _myFriends = await _dbHelper.getMyFriends();
            // if (_myFriends is List<String>) {
            //   for (int i=0; i<_myFriends.length; i++){
            //     if (widget.friend.email == _myFriends[i]) {
                  await _dbHelper.deleteFriend(widget.friend.email);
            //       break;
            //     }
            //   }
            // }
            widget.isFriend = false;
            setState(() {});
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
    String conversationId1 = "${widget.friend.email}_$myEmail";
    String conversationId2 = "${myEmail}_${widget.friend.email}";

    var snapshot = await _databaseReference
        .child('all_users')
        .child(myEmail)
        .child('conversations')
        .child(conversationId1)
        .child('id')
        .once();

    if (snapshot.value != null) {
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



}
