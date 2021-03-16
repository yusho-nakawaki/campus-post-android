import 'package:campuspost/timetable_elements/subject_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class DayFrame extends HookWidget {
  int _day;
  DayFrame({String day}){
    switch (day){
      case '月':
        _day = 0;
        break;
      case '火':
        _day = 1;
        break;
      case '水':
        _day = 2;
        break;
      case '木':
        _day = 3;
        break;
      case '金':
        _day = 4;
        break;
      case '土':
        _day = 5;
        break;
      default:
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(
          blurRadius: 5,
          color: Colors.black.withOpacity(0.2),
        )],
        // border: Border.all(color: Colors.black26),
      ),
      child: Column(
        children: [
          SubjectFrame(period: 1, day: _day),
          SubjectFrame(period: 2, day: _day),
          SubjectFrame(period: 3, day: _day),
          SubjectFrame(period: 4, day: _day),
          SubjectFrame(period: 5, day: _day),
          SubjectFrame(period: 6, day: _day),
        ],
      ),
    );
  }
}