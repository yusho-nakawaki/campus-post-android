

import 'package:campuspost/friend_files/frienddetails/friend_detail_body.dart';
import 'package:campuspost/friend_files/frienddetails/header/friend_detail_header.dart';
import 'package:campuspost/friend_files/friends_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers.dart';

class SetupProfile extends HookWidget {

  var _textController = TextEditingController();
  final _databaseReference = FirebaseDatabase.instance.reference();
  final String _userID = useProvider(userIDProvider).state;



  Future<Friend> getMyInfo() async {
    var snapshot = await _databaseReference
        .child('users').child(_userID).child('info').once();

    print("now getting");
    if (snapshot.value != null) {
      return Friend(
        avatar: snapshot.value['picture'],
        name: snapshot.value['name'],
        email: _userID,
        introduction: snapshot.value['introduction'],
        age: snapshot.value['age'],
        university: snapshot.value['university'],
        faculty: snapshot.value['faculty'],
        department: snapshot.value['department'],
      );
    }
    else {
      return Friend(avatar: "", name: "", email: _userID, introduction: "", age: "",
          university: "", faculty: "", department: "");
    }
  }
  

  @override Widget build(BuildContext context) {

    // var _friendInfo = await getMyInfo();

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
        child: FutureBuilder(
          future: getMyInfo(),
          builder: (context, snapshot) {
            // エラー時に表示するWidget
            if (snapshot.hasError) {
              return Container(
                child: Text("エラーが発生しました"),
              );
            }

            // Firebaseのinitialize完了したら表示したいWidget
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data);

              // ここでUIを作っていく
              return new Container(
                decoration: linearGradient,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new FriendDetailHeader(
                      friend: snapshot.data,
                      avatarTag: 0,
                      isFriend: false,
                      isMe: true,
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: new FriendDetailBody(snapshot.data),
                    ),
                    // new FriendShowcase(widget.friend),
                  ],
                ),
              );
            }

            // Firebaseのinitializeが完了するのを待つ間に表示するWidget
            return Center(child: CircularProgressIndicator());

          },

        ),
      ),
    );
  }

}