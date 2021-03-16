
import 'package:campuspost/timetable_elements/day_frame.dart';
import 'package:campuspost/timetable_elements/task_tile.dart';
import 'package:campuspost/timetable_elements/tasks.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:campuspost/providers.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class Timetable extends HookWidget{
  final _pageController = PageController(
    initialPage: 1,
  );
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,

      // floating action button
      floatingActionButton: BoomMenu(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        //child: Icon(Icons.add),
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        children: [
          MenuItem(
            child: Icon(Icons.apps_sharp, color: Colors.black),
            title: "時間割編集",
            subtitle: "Classes in Table-style",
            titleColor: Colors.white,
            subTitleColor: Colors.white,
            backgroundColor: Colors.blueGrey,
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Scaffold(
                            appBar: AppBar(title: Text("表形式")),
                            body: Center(
                              child: Text("表形式はここで見れる"),
                            )
                        );},
                      fullscreenDialog: true
                  )
              );
            },
          ),
          MenuItem(
            child: Icon(Icons.apps_sharp, color: Colors.black),
            title: "Table",
            subtitle: "Classes in Table-style",
            titleColor: Colors.white,
            subTitleColor: Colors.white,
            backgroundColor: Colors.deepOrange,
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Scaffold(
                            appBar: AppBar(title: Text("表形式")),
                            body: Center(
                              child: Text("表形式はここで見れる"),
                            )
                        );},
                      fullscreenDialog: true
                  )
                );
              },
          ),
          MenuItem(
            child: Icon(Icons.check_box_outlined, color: Colors.black),
            title: "Tasks",
            titleColor: Colors.white,
            subtitle: "Check all of your tasks out",
            subTitleColor: Colors.white,
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Scaffold(
                            appBar: AppBar(title: Text("タスク一覧")),
                            body: Tasks(),
                        );
                      },
                      fullscreenDialog: true
                  )
              );
            },
          ),
        ],
      ),


      // grabbing
      body: SnappingSheet(
        snapPositions: [
          SnapPosition(positionFactor: 0.05),
          SnapPosition(positionFactor: 0.5),
          SnapPosition(positionFactor: 0.8)
        ],
        initSnapPosition: SnapPosition(positionFactor: 0.8),
        grabbingHeight: MediaQuery.of(context).padding.top + 30,
        grabbing: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
              blurRadius: 20.0,
              color: Colors.black.withOpacity(0.2),
            )],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),


          // drawer
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 2.0,
                margin: EdgeInsets.only(left: 20, right: 20, top: 1.0),
                color: Colors.grey[300],
              ),
              Row(
                children: [
                  Expanded(child: Container(margin: EdgeInsets.only(left: 20), color: Colors.white, child: Text('直近のタスク'),), ),
                  Expanded(
                    child: Container(
                      width: 100.0,
                      height: 5.0,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                    ),
                  ),
                  Expanded(child: Container(color: Colors.white,), ),
                ],
              ),
            ],
          ),
        ),


        //タスクシートの内容
        sheetAbove: SnappingSheetContent(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text("タスク一覧")),
                            body: Tasks(),
                          );
                        },
                        fullscreenDialog: true
                    )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    blurRadius: 20.0,
                    color: Colors.black.withOpacity(0.2),
                  )],
                ),
                child: Center(
                  child: Tasks(),
                ),
              ),
            ),
            heightBehavior: SnappingSheetHeight.fit()
        ),


        // 時間割部分
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
              ),
            ),
            Expanded(
              flex: 3,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 0.6,
                  enlargeCenterPage: true,
                ),
                items: ['月','火','水','木','金','土'].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: Center(child: Text(i, style: TextStyle(color: Colors.white),))),
                          Expanded(
                            flex: 15,
                            child: DayFrame(day: i,),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}