import 'package:campuspost/providers.dart';
import 'package:campuspost/routes/timetable_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'auth/setup_profile.dart';
import 'friend_files/friends_model.dart';
import 'friend_files/search_friends.dart';
import 'routes/timeline_route.dart';
import 'routes/profile_route.dart';
import 'routes/talk_route.dart';
import 'routes/blog_route.dart';


class RootWidget extends HookWidget {
  var _routes = [
    FriendDetailsPage(isMe: true),
    Timeline(),
    Timetable(),
    Talk(),
    Blog(),
  ];

  // アイコン情報
  static const _footerIcons = [
    Icons.person,
    Icons.people,
    Icons.apps_sharp,
    Icons.textsms,
    Icons.article,
  ];

  // アイコン文字列
  static const _itemNames = [
    'プロフィール',
    'タイムライン',
    '時間割',
    'やりとり',
    'ブログ',
  ];


  final _databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {

    final int state = useProvider(rootProvider).state;
    final String _userID = useProvider(userIDProvider).state;
    final _bottomNavigationBarItems = <BottomNavigationBarItem>[];
    for (var i = 0; i < _itemNames.length; i++) {
      if (i == state) {
        _bottomNavigationBarItems.add(BottomNavigationBarItem(
            icon: Icon(_footerIcons[i], color: Colors.black87,),
            title: Text(
              _itemNames[i], style: TextStyle(color: Colors.black87, fontSize: 10),)
        ),);
      } else {
        _bottomNavigationBarItems.add(BottomNavigationBarItem(
            icon: Icon(_footerIcons[i], color: Colors.black26,),
            title: Text(
              _itemNames[i], style: TextStyle(color: Colors.black26, fontSize: 10),)
        ),);
      }
    }
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'My App',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
            ),
            ListTile(
              title: Text('プロフィール変更'),
              onTap: () async {
                var friendInfo = await getMyInfo(_userID);
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new SetupProfile(
                        friendInfo: friendInfo,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('設定'),
              onTap: () {

              },
            ),
            ListTile(
              title: Text('公式Twitter'),
              onTap: () {

              },
            ),
            ListTile(
              title: Text('規約'),
              onTap: () {

              },
            ),
            ListTile(
              title: Text('運営に報告する'),
              onTap: () {

              },
            ),
            ListTile(
              title: Text('ログアウト'),
              onTap: () {

              },
            ),
          ],
        ),
      ),
      appBar: AppBar(

        // leading: Padding(
        // padding: const EdgeInsets.all(4.0),
        // child: IconButton(
        //   icon: Icon(Icons.settings),
        //   onPressed: () => {},
        // ),
        // ),
        title: Text(_itemNames[state]),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsListPage(
                      // riverpodがよくわからなくて、画面遷移でemailを渡している
                        myEmail: _userID
                    ),
                    )
                )
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () => {},
              )),
        ],
      ),
      body: _routes[state],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // これを書かないと3つまでしか表示されない
        items: _bottomNavigationBarItems,
        onTap: (int index) {
          context
              .read(rootProvider)
              .state = index;
        },
        currentIndex: state,
      ),

    );
  }


  Future<Friend> getMyInfo(String userId) async {
    var snapshot = await _databaseReference
        .child('users').child(userId).child('info').once();

    if (snapshot.value != null) {
      return Friend(
        avatar: snapshot.value['picture'] ?? "",
        name: snapshot.value['name'] ?? "",
        email: userId,
        introduction: snapshot.value['introduction'] ?? "",
        age: snapshot.value['age'] ?? "",
        university: snapshot.value['university'] ?? "",
        faculty: snapshot.value['faculty'] ?? "",
        department: snapshot.value['department'] ?? "",
      );
    }
    else {
      return Friend(avatar: "", name: "abc", email: userId, introduction: "", age: "",
          university: "", faculty: "", department: "");
    }
  }
}