import 'dart:async';

import 'package:campuspost/friend_files/frienddetails/friend_details_page.dart';
import 'package:campuspost/friend_files/friends_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../database_sqlite.dart';



class FriendsListPage extends StatefulWidget {

  // Hookになおすのが面倒くさいからemailを遷移元の画面から取得
  final String myEmail;
  FriendsListPage({Key key, @required this.myEmail}) : super(key: key);

  @override
  _FriendsListPageState createState() => new _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {

  List<Friend> _friends = [];
  DatabaseHelper _dbHelper = DatabaseHelper();


  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {

    List<String> _myFriends = await _dbHelper.getMyFriends();

    final _databaseReference = FirebaseDatabase.instance.reference();

    // [email]となっている
    for (int i = 0; i < _myFriends.length; i++) {
      _databaseReference
          .child('users')
          .child(_myFriends[i])
          .child('info')
          .once()
          .then((snapshot) =>
      {
        if (snapshot.value != null) {
          _friends.add(Friend(
            avatar: snapshot.value['picture'],
            name: snapshot.value['name'],
            email: _myFriends[i],
            introduction: snapshot.value['introduction'],
            age: snapshot.value['age'],
            university: snapshot.value['university'],
            faculty: snapshot.value['faculty'],
            department: snapshot.value['department'],
          )),
        },

        if (_myFriends.length == i + 1) {
          setState(() {}),
        }
      });
    }

  }


  // 個別cell
  Widget _buildFriendListTile(BuildContext context, int index) {
    var friend = _friends[index];
    bool isFriend = false;

    return Padding(
      padding: EdgeInsets.only(
        top: 5,
      ),
      child: new ListTile(
        onTap: () async =>
        {
          isFriend = await _isCheckFriend(index),
          _navigateToFriendDetails(friend, index, isFriend),
        },
        leading: new Hero(
          tag: index,
          child: new CircleAvatar(
            backgroundImage: new NetworkImage(friend.avatar),
          ),
        ),
        title: new Text(friend.name),
      ),
    );
  }

  void _navigateToFriendDetails(Friend friend, Object avatarTag, bool isFriend) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new FriendDetailsPage(friend: friend, avatarTag: avatarTag, isFriend: isFriend, isMe: false);
        },
      ),
    );
  }

  Future<bool> _isCheckFriend(int index) async {
    List<String> _myFriends = await _dbHelper.getMyFriends();
    if (_myFriends is List<String>) {
      if (_myFriends == null || _myFriends.length == 0) {
        print("oh ... I don't understand SharedPreferences");
        return false;
      }
      for (int i = 0; i < _myFriends.length; i++) {
        if (_myFriends[i] == _friends[index].email) {
          print("friend!");
          return true;
        }
      }
      print("he is not my friend");
      return false;
    }
    else {
      // 友達登録なし
      print("have no friends");
      return false;
    }

  }

  @override Widget build(BuildContext context) {

    Widget content;
    if (_friends.isEmpty) {
      content = Center(
        // child: new CircularProgressIndicator(),
        child: Text("友達がここに表示されます。\n 友達追加してみよう！"),
      );
    } else {
      content = new ListView.builder(
        itemCount: _friends.length,
        itemBuilder: _buildFriendListTile,
      );
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text('Friends')),
      body: content,
    );
  }


}
