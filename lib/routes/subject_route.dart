import 'package:campuspost/Models/subject_model.dart';
import 'package:campuspost/providers.dart';
import 'package:campuspost/subject_elements/subject_classmates.dart';
import 'package:campuspost/subject_elements/subject_counter.dart';
import 'package:campuspost/subject_elements/subject_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

class SubjectInfo extends HookWidget{
  SubjectModel _subject;
  SubjectInfo(SubjectModel subject){
    this._subject = subject;
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      Tab(text: 'タスク',),
      Tab(text: 'クラスメート',),
      Tab(text: '出欠管理',),
    ];
    final List<Widget> _states = [
      SubjectTasks(),
      SubjectClassmates(_subject),
      SubjectCounter(),
    ];

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(title: Text("科目情報")),
        body: Column(
          children: [
            Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20,),
                      padding: EdgeInsets.all(2),
                      child: Row(
                        children: [
                          Expanded(child: Text(_subject.name, style: TextStyle(fontSize: 18),)),
                          Expanded(flex: 3, child: Container()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.lightBlueAccent,
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20,),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(child: Center(child: Text(_subject.university, style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text(_subject.teacher, style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text(_subject.dayKanji, style: TextStyle(color: Colors.white),))),
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(child: Center(child: Text(_subject.faculty, style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text(_subject.place, style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text(_subject.periodString, style: TextStyle(color: Colors.white),))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ),

            Expanded(
                flex: 4,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    flexibleSpace: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TabBar(
                          tabs: _tabs,
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: _states,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}