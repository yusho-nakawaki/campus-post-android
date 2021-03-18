import 'package:campuspost/Models/subject_model.dart';
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
  final String _university = '早稲田大学';//ここもプロバイダに変更
  SubjectModel _subject;
  SubjectClassmates(SubjectModel subject){
    this._subject = subject;
  }

  @override
  Widget build(BuildContext context) {
    final String _dayKanji = _subject.dayKanji;
    final String _period = _subject.periodString;

    return StreamBuilder(
        stream: _firestoreReference
            .collection('allSubjects')
            .doc(_university)
            .collection('$_dayKanji曜$_period限')
            .doc(_subject.subjectID)
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