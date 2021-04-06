
import 'dart:io';

import 'package:campuspost/friend_files/friends_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

final imageFile = StateProvider<File>((ref) => null);
final yearProvider = StateProvider<String>((ref) => "");
final uniProvider = StateProvider<String>((ref) => "");
final facProvider = StateProvider<String>((ref) => "");
final depProvider = StateProvider<String>((ref) => "");


class SetupProfile extends ConsumerWidget {

  Friend friendInfo;
  SetupProfile({@required Friend friendInfo}) {
    this.friendInfo = friendInfo;
  }


  final _databaseReference = FirebaseDatabase.instance.reference();
  var _userNameController = TextEditingController();
  var _userIntroductionController = TextEditingController();

  File _image;
  String _urlString;
  final picker = ImagePicker();



  @override
  Widget build(BuildContext context, watch) {

    final _selectedImage = watch(imageFile);
    final _selectedYear = watch(yearProvider);
    final _selectedUni = watch(uniProvider);
    final _selectedFac = watch(facProvider);
    final _selectedDep = watch(depProvider);



    // スマホの横幅
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                          friendInfo.avatar = _urlString,
                        });
                        FirebaseStorage storage = FirebaseStorage.instance;
                        Reference ref = storage.ref().
                        child("profile_picture/" +  friendInfo.email + "-profile.png");
                        UploadTask uploadTask = ref.putFile(_image);
                        await uploadTask.whenComplete(() async {
                          String urlString = await ref.getDownloadURL();
                          _urlString = urlString;
                          friendInfo.avatar = urlString;
                          _selectedImage.state = _image;
                          print(_urlString);
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                      child: Container(
                          width: 100,
                          height: 100,
                          child: _displaySelectionImageOrGrayImage(_selectedImage)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 250,
                      child: TextField(
                        onChanged: (value) {
                          friendInfo.name = value;
                        },
                        controller: _userNameController
                          ..text = friendInfo.name,
                        maxLength: 20,
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "名前",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: 250,
                      child: TextField(
                        onChanged: (value) {
                          friendInfo.introduction = value;
                        },
                        controller: _userIntroductionController
                          ..text = friendInfo.introduction,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
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
                                child: ElevatedButton(
                                  child: Text('学年を選択'),
                                  onPressed: () => {
                                    _showReportDialog(
                                        1, _selectedUni.state, _selectedFac.state, context
                                    )
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 130,
                              child: Text(
                                _selectedYear.state,
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
                            Container(
                              width: 105,
                              child: RepaintBoundary(
                                child: ElevatedButton(
                                  child: Text('大学を選択'),
                                  onPressed: () => {
                                    _showReportDialog(2, _selectedUni.state, _selectedFac.state, context)
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 130,
                              child: Text(
                               _selectedUni.state != "" ? friendInfo.university : _selectedUni.state,
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
                            Container(
                              width: 105,
                              child: RepaintBoundary(
                                child: ElevatedButton(
                                  child: Text('学部を選択'),
                                  onPressed: () => {
                                    if (_selectedUni.state != "" && _selectedUni.state != null) {
                                      _showReportDialog(3, _selectedUni.state, _selectedFac.state, context)
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 130,
                              child: Text(
                                _selectedFac.state != "" ? friendInfo.faculty : _selectedFac.state,
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
                            Container(
                              width: 105,
                              child: RepaintBoundary(
                                child: ElevatedButton(
                                  child: Text('学科を選択'),
                                  onPressed: () => {
                                    if (_selectedFac.state != "" && _selectedFac.state != null) {
                                      _showReportDialog(4, _selectedUni.state, _selectedFac.state, context)
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 130,
                              child: Text(
                                _selectedDep.state != "" ? friendInfo.department : _selectedDep.state,
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
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: OutlinedButton(
                          child: const Text('登録する'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(color: Colors.blue,),
                          ),
                          onPressed: () async {
                            if (_selectedFac.state == "" || _selectedFac.state == null) {
                              await showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text('名前・学年・大学・学部を入力してください'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            else {
                              CircularProgressIndicator();

                              String age = _selectedYear.state.substring(0, 4);
                              String uni = _selectedUni.state;
                              String fac = _selectedFac.state;
                              String dep = _selectedDep.state ?? "";
                              await _databaseReference.child("users/${friendInfo.email}/info/")
                                  .set({
                                "email": friendInfo.email,
                                "name": friendInfo.name,
                                "introduction": friendInfo.introduction,
                                "picture": friendInfo.avatar,
                                "age": age,
                                "university": uni,
                                "faculty": fac,
                                "department": dep ?? "",
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    // _image = File(pickedFile.path);
    _image = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.black,
        toolbarTitle: "",
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        backgroundColor: Colors.black,
        cropFrameColor: Colors.transparent,
        showCropGrid: false,
        hideBottomControls: true,
        initAspectRatio: CropAspectRatioPreset.original,
      ),
      iosUiSettings: IOSUiSettings(
        hidesNavigationBar: true,
        aspectRatioPickerButtonHidden: true,
        doneButtonTitle: "次へ",
        cancelButtonTitle: "戻る",
      ),
      // 正方形
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      // cropStyle: CropStyle.circle, // 切り抜き領域表示
    );
    // _image = await _cropImage(pickedFile.path);

    // File croppedFile = await ImageCropper.cropImage(
    //   sourcePath: image.path,
    //   aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    // );

    // var result = await FlutterImageCompress.compressAndGetFile(
    //   croppedFile.path,
    //   croppedFile.path,
    //   quality: 50,
    // );
    // _image = result;


    // 画素を下げる
    var bytes = (await _image.readAsBytes()).lengthInBytes;
    var kb = bytes / 1024;
    print(kb);
    while (kb > 220) {
      _image = await FlutterNativeImage.compressImage(
          _image.path,
          quality: 96);
      bytes = (await _image.readAsBytes()).lengthInBytes;
      kb = bytes / 1024;
      print(kb);
    }
  }

  // square frame image
  // Future<File> _cropImage(_sourcePath) async {
  //
  //   print("crop image done");
  //   return croppedFile;
  // }

  Future<void> _upload(File _image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().
    child("profile_picture/" +  friendInfo.email + "-profile.png");
    UploadTask uploadTask = ref.putFile(_image);
    await uploadTask.whenComplete(() async {
      String urlString = await ref.getDownloadURL();
      _urlString = urlString;
      // setState(() {});
    }).catchError((onError) {
      print(onError);
    });
  }




  Widget _displaySelectionImageOrGrayImage(StateController<File> imageProvider) {
    if (imageProvider.state == null) {
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
            imageProvider.state,
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }


  void _showReportDialog(int whichTable, String uni, String fac, BuildContext context) {
    FocusScope.of(context).unfocus();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('選択してください'),
            content: MultiSelectChipList(whichTable: whichTable, uni: uni, fac: fac,),
            actions: <Widget>[
              TextButton(
                  child: Text("決定"),
                  // style: TextButton.styleFrom(
                  // ),
                  onPressed: () => {
                    Navigator.pop(context),
                  }
              )
            ],
          );
        });
  }

}


class MultiSelectChipList extends ConsumerWidget {

  final int whichTable;
  final String uni;
  final String fac;
  MultiSelectChipList({@required this.whichTable, this.uni, this.fac});

  @override
  Widget build(BuildContext context, watch) {

    final _selectedYear = watch(yearProvider);
    final _selectedUni = watch(uniProvider);
    final _selectedFac = watch(facProvider);
    final _selectedDep = watch(depProvider);


    if (whichTable == 1) {
      return Wrap( children: _choiceList(_selectedYear, _selectedFac, _selectedDep), );
    }
    if (whichTable == 2) {
      var component = _choiceList(_selectedUni, _selectedFac, _selectedDep);
      return Container(
        width: 280,
        height: 500,
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return component[index];
            },
            itemCount: component.length,
        ),
      );
    }
    if (whichTable == 3) {
      return Wrap( children: _choiceList(_selectedFac, _selectedFac, _selectedDep), );
    }
    if (whichTable == 4) {
      return Wrap( children: _choiceList(_selectedDep, _selectedFac, _selectedDep), );
    }

  }

  List<Widget> _choiceList(StateController<String> selectedChoice, StateController<String> facState, StateController<String> depState) {
    List<String> strings = [];
    List<String> table1 = ["2021年度入学", "2020年度入学", "2019年度入学", "2018年度入学"];
    List<String> table2 =
    [
      "uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2","uni1", "uni2",
    ];

    Map<String, List<String>> table3 =
    {
      "uni1": ["fac1-1", "fac1-2"],
      "uni2": ["fac2-1", "fac2-2"],
      "uni3": ["fac3-1", "fac3-2"],
    };

    Map<String, Map<String, List<String>>> table4 =
    {
      "uni1": { "fac1-1": ["dep1-1-1", "dep1-1-2"] },
      "uni1": { "fac1-2": ["dep1-2-1", "dep1-2-2"] },
      "uni2": { "fac2-1": ["dep2-1-1", "dep2-1-2"] },
      "uni2": { "fac2-2": ["dep2-2-1", "dep2-2-2"] },
      "uni3": { "fac3-1": ["dep3-1-1", "dep3-1-2"] },
      "uni3": { "fac3-2": ["dep3-2-1", "dep3-2-2"] },
    };


    if (whichTable == 1) { strings = table1; }
    if (whichTable == 2) { strings = table2; }
    if (whichTable == 3) { strings = table3[uni]; }
    if (whichTable == 4) { strings = table4[uni][fac]; }
    List<Widget> choices = [];

    strings.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item, style: TextStyle(fontSize: 16.0)),
          selected: selectedChoice.state == item, // 判定
          onSelected: (selected) {
              if (whichTable == 2) {
                if (selectedChoice.state != item) {
                  facState.state = "";
                  depState.state = "";
                }
              }
              if (whichTable == 3) {
                depState.state = "";
              }
              selectedChoice.state = item; // 代入
          },
        ),
      ));
    });
    return choices;
  }
}

