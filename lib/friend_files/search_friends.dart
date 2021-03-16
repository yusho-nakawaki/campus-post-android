
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers.dart';

class SearchFriends extends HookWidget {

  @override
  Widget build(BuildContext context) {

    final _databaseReference = FirebaseDatabase.instance.reference();
    final String _userID = useProvider(userIDProvider).state;

    return Scaffold(
      appBar: AppBar(
        title: TextBox(),
      ),
        body: FutureBuilder(
            future: _databaseReference
                .child('users')
                .child('フォロー')
                .once(),
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                Map data = snap.data.snapshot.value;
                List item = [];
                data.forEach((index, data) => item.add({"key": index, ...data}));
                item.sort((a, b) => a['date'].toString().compareTo(b['date'].toString()));
                return ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    return Tile(
                      icon: Icons.person,
                      conversation: ConversationModel(
                        id: item[index]['id'],
                        myName: item[index]['my_name'],
                        partnerName: item[index]['partner_name'],
                        partnerEmail: item[index]['partner_email'],
                        myNotification: item[index]['my_notification'],
                        partnerNotification: item[index]['partner_notification'],
                        date: item[index]['latest_message']['date'],
                        message: item[index]['latest_message']['message'],
                        sender: item[index]['latest_message']['sender'],
                        isRead: item[index]['latest_message']['is_read'],
                      ),
                    );
                  },
                );
              }
              else{
                return Center(child: Text("友達がここに表示されます。友達追加をして友達を増やそう！"),);}
            }
        )
    );
  }

}


class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        decoration:
        InputDecoration(border: InputBorder.none, hintText: '友達を探す...'),
      ),
    );
  }
}