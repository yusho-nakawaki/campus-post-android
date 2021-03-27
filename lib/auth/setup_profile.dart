
import 'dart:io';

import 'package:campuspost/friend_files/friends_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';



class SetupProfile extends StatefulWidget {

  Friend friendInfo;
  SetupProfile({@required Friend friendInfo}) {
    this.friendInfo = friendInfo;
  }

  @override
  _SetupProfileState createState() => new _SetupProfileState();

}


class _SetupProfileState extends State<SetupProfile> {

  final _databaseReference = FirebaseDatabase.instance.reference();
  var _userNameController = TextEditingController();
  var _userIntroductionController = TextEditingController();

  File _image;
  String _urlString;
  final picker = ImagePicker();



  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);
    // 画素を下げる
    var bytes = (await _image.readAsBytes()).lengthInBytes;
    var kb = bytes / 1024;
    print(kb);
    while (kb > 300) {
      _image = await FlutterNativeImage.compressImage(
          _image.path,
          quality: 96);
      bytes = (await _image.readAsBytes()).lengthInBytes;
      kb = bytes / 1024;
      print(kb);
    }

  }

  Future<void> _upload(File _image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().
    child("profile_picture/" +  widget.friendInfo.email + "-profile.png");
    UploadTask uploadTask = ref.putFile(_image);
    await uploadTask.whenComplete(() async {
      String urlString = await ref.getDownloadURL();
      _urlString = urlString;
      setState(() {});
    }).catchError((onError) {
      print(onError);
    });
  }


  @override void dispose() {
    _userNameController.dispose();
    _userIntroductionController.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context) {

    // スマホの横幅
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          child: _bodyProfile(size)
      ),
    );
  }


  Widget _bodyProfile(Size size) {

    return new Container(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 40,
            left: 20,
            bottom: 20,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: (size.width) - 40,
            ),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Text(
                    "アイコンを選ぶ",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _getImage();
                      _upload(_image).whenComplete(() => {
                        widget.friendInfo.avatar = _urlString,
                      });
                    },
                    child: Container(
                        width: 100,
                        height: 100,
                        child: _displaySelectionImageOrGrayImage()
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 250,
                    child: TextField(
                      onChanged: (value) {
                        widget.friendInfo.name = value;
                      },
                      controller: _userNameController
                        ..text = widget.friendInfo.name,
                      maxLength: 20,
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "名前",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 250,
                    child: TextField(
                      onChanged: (value) {
                        widget.friendInfo.introduction = value;
                      },
                      controller: _userIntroductionController
                        ..text = widget.friendInfo.introduction,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      maxLength: 140,
                      decoration: InputDecoration(
                        hintText: "自己紹介文（後からでも設定できます）",
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Row(
                        children: [
                          Container(
                            width: 105,
                            child: RepaintBoundary(
                              child: RaisedButton(
                                child: Text('学年を選択'),
                                onPressed: () => {
                                  
                                  // **** タップして、選択画面を表示 ****
                                  
                                  _showReportDialog(
                                      1,
                                      widget.friendInfo.university,
                                      widget.friendInfo.faculty
                                  )
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 130,
                            child: Text(
                              "2021年度入学（1年生）",
                              style: TextStyle(fontSize: 16),
                              maxLines: 10,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ]
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          Container(
                            width: 105,
                            child: RepaintBoundary(
                              child: RaisedButton(
                                child: Text('大学を選択'),
                                onPressed: () => {
                                  // **** タップして、選択画面を表示 ****
                                  _showReportDialog(2, widget.friendInfo.university, widget.friendInfo.faculty)
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 130,
                            child: Text(
                              "早稲田大学",
                              style: TextStyle(fontSize: 16),
                              maxLines: 10,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ]
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          Container(
                            width: 105,
                            child: RepaintBoundary(
                              child: RaisedButton(
                                child: Text('学部を選択'),
                                onPressed: () => {
                                  // **** タップして、選択画面を表示 ****
                                  _showReportDialog(2, widget.friendInfo.university, widget.friendInfo.faculty)
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 130,
                            child: Text(
                              "基幹理工学部",
                              style: TextStyle(fontSize: 16),
                              maxLines: 10,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ]
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          Container(
                            width: 105,
                            child: RepaintBoundary(
                              child: RaisedButton(
                                child: Text('学科を選択'),
                                onPressed: () => {
                                  // **** タップして、選択画面を表示 ****
                                  _showReportDialog(2, widget.friendInfo.university, widget.friendInfo.faculty)
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 130,
                            child: Text(
                              "情報通信学科",
                              style: TextStyle(fontSize: 16),
                              maxLines: 10,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _displaySelectionImageOrGrayImage() {
    if (_image == null) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xffdfdfdf),
          border: Border.all(
            width: 1,
            color: const Color(0xff000000),
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xff000000),
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            _image,
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }

  // ダイアログ
  String _showReportDialog(int whichTable, String uni, String fac) {
    FocusScope.of(context).unfocus();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('選択してください'),
            content: MultiSelectChipList(whichTable: whichTable, uni: uni, fac: fac,),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  child: Text("決定"),
                  onPressed: () => {
                    print(context),
                    Navigator.of(context).pop("string"),
                  }
              )
            ],
          );
        });
  }



}



// 他クラスであり、ここで値を選択している

class MultiSelectChipList extends StatefulWidget {

  String selectedChoice = "";

  final int whichTable;
  final String uni;
  final String fac;
  MultiSelectChipList({@required this.whichTable, this.uni, this.fac});

  @override
  _MultiSelectChipListState createState() => _MultiSelectChipListState();
}

class _MultiSelectChipListState extends State<MultiSelectChipList> {

  List<String> strings = [];
  List<String> table1 = ["1", "2"];
  List<String> table2 = ["uni1", "uni2"];
  Map<String, List<String>> table3 = {"uni1": ["1-1", "1-2"], "uni2": ["2-1 2-2"]};


  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    if (widget.whichTable == 1) {
      strings = table1;
    }
    if (widget.whichTable == 2) {
      strings = table2;
    }
    if (widget.whichTable == 3) {
      strings = table3[widget.uni];
    }
    return Wrap(
      children: _choiceList,
    );
  }

  List<Widget> get _choiceList {
    List<Widget> choices = [];
    strings.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: widget.selectedChoice == item, // 判定
          onSelected: (selected) {
            setState(() {
              widget.selectedChoice = item; // 代入
            });
          },
        ),
      ));
    });
    return choices;
  }
}

