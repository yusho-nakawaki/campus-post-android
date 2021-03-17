import 'package:campuspost/providers.dart';
import 'package:campuspost/subject_elements/subject_classmates.dart';
import 'package:campuspost/subject_elements/subject_counter.dart';
import 'package:campuspost/subject_elements/subject_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

class SubjectInfo extends HookWidget{
  int _day;
  String _dayKanji;
  int _period;
  String _periodString;
  String _subjectID;
  SubjectInfo({int day, int period, String id}){
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
    final List<Widget> _tabs = [
      Tab(text: 'タスク',),
      Tab(text: 'クラスメート',),
      Tab(text: '出欠管理',),
    ];
    final List<Widget> _states = [
      SubjectTasks(),
      SubjectClassmates(day: _day, period: _period, id: _subjectID),
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
                          Expanded(child: Text('_subjectID', style: TextStyle(fontSize: 18),)),
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
                                  Expanded(child: Center(child: Text('_subjectID', style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text('_subjectID', style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text('_subjectID', style: TextStyle(color: Colors.white),))),
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
                                  Expanded(child: Center(child: Text('_subjectID', style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text('_subjectID', style: TextStyle(color: Colors.white),))),
                                  Expanded(child: Center(child: Text('_subjectID', style: TextStyle(color: Colors.white),))),
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