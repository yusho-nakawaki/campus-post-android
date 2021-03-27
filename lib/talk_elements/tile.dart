import 'dart:typed_data';

import 'package:campuspost/Models/conversation_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import '../providers.dart';
import '../routes/chat_route.dart';


class Tile extends HookWidget {
  IconData _icon;
  ConversationModel _conversation;


  Tile({IconData icon, ConversationModel conversation}) {
    this._icon = icon;
    this._conversation = conversation;
  }


  @override
  Widget build(BuildContext context) {

    final _databaseReference = FirebaseDatabase.instance.reference();
    final _storage = FirebaseStorage.instance.ref();
    final String _userID = useProvider(userIDProvider).state;

    // imageを取得
    Future<String> _getFriendUrl() async {
      Reference ref = _storage.child("profile_picture/${_conversation.partnerEmail}-profile.png");
      var imageUrl = await ref.getDownloadURL();
      if (imageUrl != null) {
        return imageUrl;
      }
      else {
        return null;
      }

    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: Container(
        height: 90,
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            child: FutureBuilder(
                future: _getFriendUrl(),
                builder: (context, snapshot) {

                  // エラー時に表示するWidget
                  if (snapshot.hasError) {
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        color: Colors.blue,
                      ),
                    );
                  }

                  // Firebaseのinitialize完了したら表示したいWidget
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.data);
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: (snapshot.data == null) ? AssetImage('assets/images/noImage.png') :
                          NetworkImage(
                              snapshot.data
                          ),
                        ),
                      ),
                    );
                  }

                  // Firebaseのinitializeが完了するのを待つ間に表示するWidget
                  return Center(child: CircularProgressIndicator());
                }
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              _conversation.partnerName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          subtitle: Text(
              (_conversation.message.contains("https://firebasestorage")) ? "写真が送信されました"
                  :  (_conversation.message ?? "message"),
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 15,
              )
          ),
          trailing: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: Container(
                  constraints: BoxConstraints(minWidth: 0, maxWidth: 80),
                  child: Text(
                    _conversation.date ?? "no date",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: (_conversation.isRead == false),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: new BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () => {
            if (_conversation.isRead == false) {
              // _conversation.isRead = true,
              _databaseReference.child('all_users')
                  .child(_userID).child('conversations')
                  .child(_conversation.id).child('latest_message').update({
                'is_read': true,
              }),
            },

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                      chatID: _conversation.id,
                      partnerID: _conversation.partnerEmail,
                      partnerName: _conversation.partnerName,
                      isNew: false,
                    )
                )
            )

          },
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          color: Colors.blue,
          icon: Icons.flash_off,
          onTap: () => {},
        ),
        IconSlideAction(
          color: Colors.indigo,
          icon: Icons.flash_off,
          onTap: () => {},
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.black45,
          iconWidget: Text(
            "非表示",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          onTap: () => {},
        ),
        IconSlideAction(
          color: Colors.indigo,
          iconWidget: Text(
            "消去",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          onTap: () => {},
        ),
      ],
    );
  }
}
