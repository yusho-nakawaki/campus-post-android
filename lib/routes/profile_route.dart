import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:campuspost/providers.dart';

class Profile extends HookWidget with PreferredSizeWidget{
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  var i = 10;

  @override
  Widget build(BuildContext context) {
    final String _userID = useProvider(userIDProvider).state;
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(FirebaseAuth.instance.currentUser.email),
              Text(_userID),
              TextButton(
                  onPressed: ()async{
                    context.read(signInAlertProvider).state = "";
                    context.read(signUpAlertProvider).state = "";
                    context.read(authRootProvider).state = 0;
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Text("sign out"),
              )
            ],
          )
      ),
    );
  }
}