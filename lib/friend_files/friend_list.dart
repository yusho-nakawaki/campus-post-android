
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FriendsCard extends StatelessWidget {

  final String friendId;
  final _databaseReference = FirebaseDatabase.instance.reference();
  final _storageRef = FirebaseStorage.instance.ref();

  FriendsCard({@required this.friendId});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 30,
              width: 80,
              height: 80,
              child:
    // FutureBuilder(
                // future:
                // _storageRef
                //     .child('profile_picture')
                //     .child(friendId + '-profile.png')
                //     .getDownloadURL(),
                // builder: (context, snap) {
                /*  if (snap.hasData && !snap.hasError &&
                      snap.data.value != null) {
                    print(snap.data.value);
                    String urlString = snap.data.value;
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        image: DecorationImage(
                          image: NetworkImage(urlString),
                        ),
                      ),
                    );
                   }*/
                //   else {
                //     return
                Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        image: DecorationImage(
                          image: AssetImage('assets/images/noImage.png'),
                        ),
                      ),
                    )
                  // }
                // }
              // ),
            ),
            Positioned(
              top: 10,
              right: 1400,
              width: 80,
              height: 80,
              child: FutureBuilder(
                  future: _databaseReference
                      .child('users')
                      .child(friendId)
                      .child('info')
                      .child('name')
                      .once(),
                  builder: (context, snap) {
                    print(friendId);
                    print('success feth');
                    // print(snap.data.snapshot.value);
                    print('aaaaaaaa');
                    // if (snap.hasData && !snap.hasError && snap.data.value != null) {
                      print(snap.data.value);
                    print('nnnnnnnnnnnnn');
                      String name = snap.data.value;
                      print(name);
                      // return Text(
                      //   name,
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // );
                    // }
                    // else {
                      return Text(
                        "名前",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    // }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

}
