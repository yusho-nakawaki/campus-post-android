import 'package:campuspost/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectClassmates extends HookWidget{
  final _firestoreReference = FirebaseFirestore.instance;
  final String _userID = useProvider(userIDProvider).state;
  final String _university = '早稲田大学';

  int _day;
  String _dayKanji;
  int _period;
  String _periodString;
  String _subjectID;
  SubjectClassmates({int day, int period, String id}){
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
    this._subjectID = id;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestoreReference
            .collection('allSubjects')
            .doc(_university)
            .collection('$_dayKanji曜$_period限')
            .doc(_subjectID)
            .collection('users')
            .snapshots(),
        builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document.data()['id']),
                subtitle: Text(document.data()['id']),
                onTap: (){},
              );
            }).toList(),
          );},
    );
  }
}