import 'package:campuspost/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectEdit extends HookWidget{
  int _day;
  String _dayKanji;
  int _period;
  String _periodString;
  SubjectEdit({int day, int period}){
    switch(day){
      case 0:
        _dayKanji = '月';
        break;
      case 1:
        _dayKanji = '火';
        break;
      case 2:
        _dayKanji = '水';
        break;
      case 3:
        _dayKanji = '木';
        break;
      case 4:
        _dayKanji = '金';
        break;
      case 5:
        _dayKanji = '土';
        break;
      default:
        break;
    }
    this._day = day;
    this._period = period;
    this._periodString = period.toString();
  }

  @override
  Widget build(BuildContext context) {
    // final _authReference = FirebaseAuth.instance;
    // final _databaseReference = FirebaseDatabase.instance.reference();
    final _firestoreReference = FirebaseFirestore.instance;
    final String _userID = useProvider(userIDProvider).state;
    final _searchTextController = TextEditingController();
    final _nameTextController = TextEditingController();
    final _teacherTextController = TextEditingController();
    final _facultyTextController = TextEditingController();
    final _placeTextController = TextEditingController();
    final String _university = '早稲田大学';

    void _addSubject(){
      DocumentReference _docRef = _firestoreReference
          .collection('allSubjects')
          .doc(_university)
          .collection('$_dayKanji曜$_period限').doc();
      _docRef.set({
        'name': _nameTextController.text,
        'teacher': _teacherTextController.text,
        'faculty': _facultyTextController.text,
        'id': _docRef.id,
        'created_by': _userID,
        'period': _period,
        'day': _dayKanji,
        'university': _university,
        'place': _placeTextController.text,
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("時間割編集")),
      body: StreamBuilder(
        stream:  _firestoreReference
            .collection('allSubjects')
            .doc(_university)
            .collection('$_dayKanji曜$_periodString限')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Column(
            children: [
              Container(height: 50, child: Center(child: Text('$_dayKanji曜$_period限'))),
              Container(height: 50, child: Center(child: Text(_university))),
              Container(
                height: 50,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){},
                      )),
                      Expanded(flex: 4, child: TextField(controller: _searchTextController,),),
                      Expanded(child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('授業の新規作成'),
                                content: Column(
                                  children: [
                                    Container(
                                        height: 50,
                                        child: Center(
                                            child: Row(
                                              children: [
                                                Expanded(child: Text('科目名:', style: TextStyle(fontSize: 14))),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    controller: _nameTextController,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                    ),
                                    Container(
                                        height: 50,
                                        child: Center(
                                            child: Row(
                                              children: [
                                                Expanded(child: Text('担当教員:', style: TextStyle(fontSize: 14),)),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    controller: _teacherTextController,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                    ),
                                    Container(
                                        height: 50,
                                        child: Center(
                                            child: Row(
                                              children: [
                                                Expanded(child: Text('開講学部:', style: TextStyle(fontSize: 14))),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    controller: _facultyTextController,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                    ),
                                    Container(
                                        height: 50,
                                        child: Center(
                                            child: Row(
                                              children: [
                                                Expanded(child: Text('教室:', style: TextStyle(fontSize: 14),)),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    controller: _placeTextController,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: Text("戻る"),
                                    onPressed: (){
                                      // _firestoreReference
                                      //     .collection('allSubjects')
                                      //     .doc(_university)
                                      //     .collection('月曜1限')
                                      //     .doc('99999999')
                                      //     .set({
                                      //   'name': 'blank',
                                      //   'created_by': 'blank',
                                      //   'faculty': 'blank',
                                      //   'teacher': 'blank',
                                      //   'day': '月',
                                      //   'period': 1,
                                      //   'university': _university,
                                      //   'id': '99999999',
                                      //   'users': {
                                      //     _userID:{
                                      //       'id': _userID,
                                      //       'absent': 0,
                                      //       'late': 0,
                                      //       'attend': 0
                                      //     }
                                      //   }
                                      // });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("登録"),
                                    onPressed: () {
                                      _addSubject();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      return ListTile(
                        title: Text(document.data()['name']),
                        subtitle: Text(document.data()['teacher']),
                        onTap: (){
                          _firestoreReference
                              .collection('users')
                              .doc(_userID)
                              .update({
                            ((_day * 6) + _period - 1).toString(): document.data()['id'],
                          });
                          _firestoreReference
                              .collection('allSubjects')
                              .doc(_university)
                              .collection('$_dayKanji曜$_period限')
                              .doc(document.data()['id'])
                              .collection('users')
                              .doc(_userID)
                              .set({
                            'id': _userID,
                            'absent': 0,
                            'late': 0,
                            'attend': 0
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}