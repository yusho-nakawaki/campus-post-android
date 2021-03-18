import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SubjectTasks extends HookWidget{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(child: Text('task')),
      ],
    );
  }

}