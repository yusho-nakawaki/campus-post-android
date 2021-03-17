import 'package:campuspost/providers.dart';
import 'package:campuspost/routes/subject_edit_route.dart';
import 'package:campuspost/routes/subject_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectModel {
  int period;
  int dayNum;
  String dayKanji;
  String name;
  String faculty;
  String university;
  String teacher;
  String subjectID;
  String createdBy;
  SubjectModel({
    int period,
    int dayNum,
    String name,
    String faculty,
    String university,
    String teacher,
    String subjectID,
    String createdBy,
  }){
    this.period = period;
    this.dayNum = dayNum;
    this.name = name;
    this.faculty = faculty;
    this.university = university;
    this.teacher = teacher;
    this.subjectID = subjectID;
    this.createdBy = createdBy;

}
}

class SubjectFrame extends HookWidget{
  int _period;
  String _periodString;
  int _day;
  String _dayKanji;
  int _taskLeft = 3;
  SubjectFrame({int period, int day}){
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
    this._period = period;
    this._periodString = period.toString();
    this._day = day;
  }

  @override
  Widget build(BuildContext context) {
    final _authReference = FirebaseAuth.instance;
    final _databaseReference = FirebaseDatabase.instance.reference();
    final _firestoreReference = FirebaseFirestore.instance;
    final String _userID = useProvider(userIDProvider).state;
    final String _university = '早稲田大学';

    return StreamBuilder<DocumentSnapshot> (
      stream: _firestoreReference.collection('users').doc(_userID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        // final String _subjectName = snapshot.data.data()['name'];
        final String _subjectID = snapshot.data.data()[((_day*6)+_period-1).toString()];

        return StreamBuilder<DocumentSnapshot> (
          stream: _firestoreReference
              .collection('allSubjects')
              .doc(_university)
              .collection('$_dayKanji曜$_periodString限')
              .doc(_subjectID)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            final String _subjectName = snapshot.data.data()['name'];
            return Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.2),
                    )],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Center(child: Text(' $_period\n限'))),
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onLongPress: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return SubjectEdit(day: _day, period: _period,);
                                    },
                                    fullscreenDialog: true
                                )
                            );
                          },
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return SubjectInfo(day: _day, period: _period,  id: _subjectID);
                                    },
                                    fullscreenDialog: true
                                )
                            );
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(child: Center(child: Text(_subjectName))),
                                Expanded(child: Center(child: Text('クラスメート：塩原さん他', style: TextStyle(fontSize: 10),))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(child: Text(_taskLeft.toString())),
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.lightGreenAccent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            );
          },
        );
      },
    );
  }

}