import 'package:campuspost/providers.dart';
import 'package:campuspost/timeline_elements/post_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Timeline extends HookWidget with PreferredSizeWidget{
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final _authReference = FirebaseAuth.instance;
    final _databaseReference = FirebaseDatabase.instance.reference();
    final String _userID = useProvider(userIDProvider).state;
    return Scaffold(
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return PostTile();
        }),
      // body: StreamBuilder(
      //     stream: _databaseReference
      //         .child('posts')
      //         .child(_userID)
      //         .child('conversations')
      //         .onValue,
      //     builder: (context, snap) {
      //       if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
      //         Map data = snap.data.snapshot.value;
      //         List item = [];
      //         data.forEach((index, data) => item.add({"key": index, ...data}));
      //         return ListView.builder(
      //           itemCount: item.length,
      //           itemBuilder: (context, index) {
      //             return Tile(
      //               icon: Icons.person,
      //               partnerID: item[index]['partner_email'],
      //               partnerName: item[index]['partner_name'],
      //               latestMessage: item[index]['latest_message']['message'],
      //               chatID: item[index]['id'],
      //               timeStamp: item[index]['latest_message']['date'],
      //             );
      //           },
      //         );
      //       }
      //       else{return Center(child: Text("loading"),);}
      //     }
      // )
    );
  }
}