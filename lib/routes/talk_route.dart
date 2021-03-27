import 'package:campuspost/Models/conversation_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:campuspost/talk_elements/tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:campuspost/providers.dart';


class Talk extends HookWidget{
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final _databaseReference = FirebaseDatabase.instance.reference();
    final String _userID = useProvider(userIDProvider).state;
    return Scaffold(
        body: StreamBuilder(
            stream: _databaseReference
                .child('all_users')
                .child(_userID)
                .child('conversations')
                .onValue,
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                Map data = snap.data.snapshot.value;
                List item = [];
                data.forEach((index, data) => item.add({"key": index, ...data}));
                item.sort((b, a) =>
                    a['latest_message']['date'].toString().compareTo(b['latest_message']['date'].toString())
                );
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
                return Center(child: Text("loading"),);}
            }
        )
    );
  }
}