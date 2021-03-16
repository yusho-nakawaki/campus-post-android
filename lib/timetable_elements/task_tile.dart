import 'package:campuspost/routes/task_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:like_button/like_button.dart';

class TaskTile extends HookWidget {
  bool _checked;
  String _name;
  String _deadline;
  TaskTile({String name, String deadline}){
    this._name = name;
    this._deadline = deadline;
    this._checked = false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          blurRadius: 5.0,
          color: Colors.black.withOpacity(0.2),
        )],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Colors.black26),
      ),
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: CheckboxListTile(
              title: Text(_name),
              subtitle: Text(_deadline),
              value: _checked,
              onChanged: (value){},
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return TaskInfo();
                        },
                        fullscreenDialog: true
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}