import 'package:campuspost/providers.dart';
import 'package:campuspost/routes/timetable_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'routes/timeline_route.dart';
import 'routes/profile_route.dart';
import 'routes/talk_route.dart';
import 'routes/blog_route.dart';


class RootWidget extends HookWidget {
  var _routes = [
    Profile(),
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
  @override
  Widget build(BuildContext context) {
    final int state = useProvider(rootProvider).state;
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => {},
          ),
        ),
        title: Text(_itemNames[state]),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => {},
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
}