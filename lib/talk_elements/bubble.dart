import 'package:campuspost/Models/bubble_model.dart';
import 'package:campuspost/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Bubble extends HookWidget {
  BubbleModel _bubbleModel;

  String readStamp(bool){
    if(bool){return 'read';}
    else{return '';}
  }

  Bubble({BubbleModel bubbleModel}) {
    _bubbleModel = bubbleModel;
  }

  @override
  Widget build(BuildContext context) {
    // スマホの横幅
    final Size size = MediaQuery.of(context).size;
    final String _userID = useProvider(userIDProvider).state;

    if ((_bubbleModel.senderEmail ?? "") == _userID) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Text("", style: TextStyle(fontSize: 8, color: Colors.white),),
              Text((_bubbleModel.date ?? ""), style: TextStyle(fontSize: 8, color: Colors.white),),
            ],
          ),
          Container(
            constraints: ((_bubbleModel.type ?? "") == "text") ?
              BoxConstraints(minWidth: 0, maxWidth: size.width - 100)
              : BoxConstraints(minWidth: 200, maxWidth: 230),
            child: Stack(
              children: [
                Visibility(
                  visible: ((_bubbleModel.type ?? "") == "text"),
                  child: Text(
                    _bubbleModel.content ?? "error in database",
                    style: TextStyle(fontSize: 16),
                    maxLines: 10,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Visibility(
                  visible: (_bubbleModel.type ?? "") == "photo",
                  child: Image.network(_bubbleModel.content ?? "") ?? Image.asset('assets/images/noImage.png'),
                ),
              ],
            ),

            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: ((_bubbleModel.type ?? "") == "text") ? Colors.lightGreenAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ],
      );
    }
    else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: ((_bubbleModel.type ?? "") == "text") ?
            BoxConstraints(minWidth: 0, maxWidth: size.width - 100)
                : BoxConstraints(minWidth: 200, maxWidth: 230),
            child: Stack(
              children: [
                Visibility(
                  visible: (_bubbleModel.type ?? "") == "text",
                  child: Text(
                    _bubbleModel.content ?? "error in database",
                    style: TextStyle(fontSize: 16),
                    maxLines: 10,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Visibility(
                  visible: ((_bubbleModel.type ?? "") == "photo") ?? false,
                  child: Image.network(_bubbleModel.content ?? "") ?? Image.asset('assets/images/noImage.png'),
                ),
              ],
            ),

            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color:  ((_bubbleModel.type ?? "") == "text") ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Column(
            children: [
              Text(readStamp(_bubbleModel.isRead ?? false), style: TextStyle(fontSize: 8, color: Colors.white),),
              Text((_bubbleModel.date ?? ""), style: TextStyle(fontSize: 8, color: Colors.white),),
            ],
          ),
        ],
      );
    }
  }
}