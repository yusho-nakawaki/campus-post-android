import 'package:campuspost/timetable_elements/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Tasks extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TaskTile(name: 'kadai1', deadline: '2021-04-09',),
        TaskTile(name: 'test junbi', deadline: '2021-05-01',),
        TaskTile(name: 'kadai2', deadline: '2021-04-22',),
      ],
    );
  }

}