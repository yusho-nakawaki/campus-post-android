import 'package:campuspost/friend_files/frienddetails/footer/friend_detail_footer.dart';
import 'package:campuspost/friend_files/frienddetails/friend_detail_body.dart';
import 'package:campuspost/friend_files/frienddetails/header/friend_detail_header.dart';
import 'package:campuspost/friend_files/friends_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:campuspost/providers.dart';



class FriendDetailsPage extends StatefulWidget {
  FriendDetailsPage({
    this.friend,
    this.avatarTag,
    this.isFriend,
    this.isMe
  });

  final Friend friend;
  final Object avatarTag;
  final bool isFriend;
  final bool isMe;

  @override
  _FriendDetailsPageState createState() => new _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {



  @override Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FriendDetailHeader(
                friend: widget.friend,
                avatarTag: widget.avatarTag,
                isFriend: widget.isFriend,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new FriendDetailBody(widget.friend),
              ),
              new FriendShowcase(widget.friend),
            ],
          ),
        ),
      ),
    );
  }
}





// class Profile extends HookWidget with PreferredSizeWidget{
// @override
// Size get preferredSize => Size.fromHeight(kToolbarHeight);
//
// var i = 10;
//
// @override
// Widget build(BuildContext context) {
//   final String _userID = useProvider(userIDProvider).state;
//   return Scaffold(
//     body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(FirebaseAuth.instance.currentUser.email),
//             Text(_userID),
//             TextButton(
//                 onPressed: ()async{
//                   context.read(signInAlertProvider).state = "";
//                   context.read(signUpAlertProvider).state = "";
//                   context.read(authRootProvider).state = 0;
//                   await FirebaseAuth.instance.signOut();
//                 },
//                 child: Text("sign out"),
//             )
//           ],
//         )
//     ),
//   );
// }
// }