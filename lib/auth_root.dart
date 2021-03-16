import 'package:campuspost/auth/pw_check.dart';
import 'package:campuspost/auth/signin.dart';
import 'package:campuspost/auth/signup.dart';
import 'package:campuspost/providers.dart';
import 'package:campuspost/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class AuthRootWidget extends HookWidget {
  var _authRoutes = [
    SignUpPage(),
    SignInPage(),
    PasswordCheckPage(),
    RootWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    final int _state = useProvider(authRootProvider).state;

    return Scaffold(
      body: _authRoutes[_state],
    );
  }
}
