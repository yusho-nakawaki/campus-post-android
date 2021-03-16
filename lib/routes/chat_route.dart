
import 'dart:async';
import 'dart:io';

import 'package:campuspost/Models/bubble_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:campuspost/talk_elements/bubble.dart';
import 'package:campuspost/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';



class Chat extends HookWidget {

  var _textController = TextEditingController();

  String _chatID;
  String _partnerID;
  String _timeStamp;
  String _partnerName;
  String getTimeStamp() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toLocal());
  }
  Chat({String chatID, String partnerID, String partnerName}) {
    this._chatID = chatID;
    this._partnerName = partnerName;
    this._partnerID = partnerID;
  }


  @override
  Widget build(BuildContext context) {

    final _authReference = FirebaseAuth.instance;
    final _databaseReference = FirebaseDatabase.instance.reference();
    final String _userID = useProvider(userIDProvider).state;


    //写真をアップロード iosのinfo.plistは設定していないのでiphoneはクラッシュする
    File _image;
    String _urlString;
    final picker = ImagePicker();

    Future _takeAPicture() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      _image = File(pickedFile.path);
    }

    Future _getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      _image = File(pickedFile.path);
    }

    Future<void> upload(File _image) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().
      child("message_pictures/" +  _partnerID + "_isReceived/" + "image_" + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(_image);
      await uploadTask.whenComplete(() async {
        String urlString = await ref.getDownloadURL();
        _urlString = urlString;
      }).catchError((onError) {
        print(onError);
      });
    }


    // realtimeの４つのノードを更新する関数
    Future<void> _insertRealtimeNode(String content, String type) async {
      _timeStamp = getTimeStamp();
      _databaseReference
          .child('allConversations')
          .child(_userID)
          .child(_chatID)
          .child(_timeStamp)
          .set({
        "content": content,
        "date": _timeStamp,
        "id": _chatID + "_" + _timeStamp,
        "is_Read": true,
        "sender_email": _userID,
        "type": type,
      });
      _databaseReference
          .child('allConversations')
          .child(_partnerID)
          .child(_chatID)
          .child(_timeStamp)
          .set({
        "content": content,
        "date": _timeStamp,
        "id": _chatID + "_" + _timeStamp,
        "is_Read": false,
        "sender_email": _userID,
        "type": type,
      });
      _databaseReference
          .child('all_users')
          .child(_userID)
          .child('conversations')
          .child(_chatID)
          .child('latest_message')
          .set({
        "message": content,
        "date": _timeStamp,
        "is_read": true,
        "sender": _userID,
      });
      _databaseReference
          .child('all_users')
          .child(_partnerID)
          .child('conversations')
          .child(_chatID)
          .child('latest_message')
          .set({
        "message": content,
        "date": _timeStamp,
        "is_read": false,
        "sender": _userID,
      });
    }



    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._partnerName ?? '',
        ),
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
                icon: Icon(Icons.dehaze),
                onPressed: () => {},
              )),
        ],
      ),
      body: Scaffold(
        body: StreamBuilder(
          stream: _databaseReference
              .child('allConversations')
              .child(_userID)
              .child(_chatID)
              .onValue,
          builder: (context, snap) {
            if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              List item = [];
              data.forEach((index, data) => item.add({"key": index, ...data}));
              item.sort((a, b) => b['date'].toString().compareTo(a['date'].toString()));

              //既読処理
              var i = 0;
              if (item.length > 0 ) {
                while (item[i]['is_Read'] == false) {
                  if (i > 10) { break; }
                  _databaseReference.child('allConversations').child(_userID)
                      .child(_chatID).child(item[i]['date']).update({
                    'is_Read': true,
                  });
                  print(i);
                  i += 1;
                }
              }
              print(item[0]['content']);

              return ListView.builder(
                // 下まで移動させるためにreverseして、日付順番も逆に
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                reverse: true,
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return Bubble(
                    bubbleModel: BubbleModel(
                        id: item[index]['id'],
                        senderEmail: item[index]['sender_email'],
                        content: item[index]['content'],
                        type: item[index]['type'],
                        date: item[index]['date'],
                        isRead: item[index]['is_Read'],
                      )
                  );
                },
              );
            }
            else
              return Text("No data");
          },
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
              children: <Widget>[
                // IconButton(
                //   icon: Icon(Icons.add),
                //   onPressed: () => {},
                // ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    await _takeAPicture();
                    upload(_image).whenComplete(() => {
                      _insertRealtimeNode(_urlString, "photo")
                    });
                  }
                ),
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
                    await _getImage();
                    upload(_image).whenComplete(() => {
                      _insertRealtimeNode(_urlString, "photo")
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'メッセージを入力',
                    ),
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if(_textController.text != ''){
                      _insertRealtimeNode(_textController.text, "text");
                      _textController.text = "";
                    }
                  },
                ),
              ],
            ),
        ),
        backgroundColor: Colors.black12,
      ),
    );
  }
}