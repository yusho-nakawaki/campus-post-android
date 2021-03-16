import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:like_button/like_button.dart';

class PostTile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Icon(Icons.insert_emoticon, size: 60,),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      child: Text('name', style: TextStyle(fontSize: 16),),
                      alignment: Alignment.topLeft,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 70),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          child: Text('say something\nat this space\n\nnanika itte kudasai',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    ),
                    Container(
                      height: 25,
                      child: Row(
                        children: [
                          Expanded(child: LikeButton(size: 20,)),
                          Expanded(
                            child: LikeButton(
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.replay,
                                  color: isLiked ? Colors.green : Colors.grey,
                                  size: 20,
                                );},
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.subdirectory_arrow_left),
                              iconSize: 20,
                              padding: EdgeInsets.all(3),
                              onPressed: (){},
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.more_horiz),
                              iconSize: 20,
                              padding: EdgeInsets.all(3),
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("削除"),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("ミュート"),
                                        ),
                                      ],
                                    );},
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}