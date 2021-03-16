import 'package:campuspost/Models/conversation_model.dart';
import 'package:firebase_database/firebase_database.dart';
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
    final String _userID = useProvider(userIDProvider).state;

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: Container(
        height: 90,
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://pbs.twimg.com/profile_images/1181141619061354496/ah2gg_Su_400x400.png'
                    ),
                  ),
                ),
                // child: Image.network(
                //   'https://www.google.com/url?sa=i&url=https%3A%2F%2Ftwitter.com%2Fminami_voyage&psig=AOvVaw1vSZTp1HiXcUvswoZdLM10&ust=1615967855471000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOiAy8OrtO8CFQAAAAAdAAAAABAP',
                //   height: 70,
                //   width: 70,
                // ),
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
