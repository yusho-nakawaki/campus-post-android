


import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FriendsCard extends StatelessWidget {

  final String friendId;
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
              child: FutureBuilder(
                future: _storageRef
                    .child('profile_picture')
                    .child(friendId + '-profile.png')
                    .getDownloadURL(),
                builder: (context, snap) {
                  if (snap.hasData && !snap.hasError &&
                      snap.data.snapshot.value != null) {
                    String urlString = snap.data.snapshot.value;
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
                  }
                  else {
                    return Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        image: DecorationImage(
                          image: AssetImage('assets/images/noImage.png'),
                        ),
                      ),
                    );
                  }
                }
              ),
            ),
            Positioned(
              child: FutureBuilder(

              ),
            ),
          ],
        ),
      ),
    );
  }

}
