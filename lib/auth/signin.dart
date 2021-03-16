import 'package:campuspost/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends HookWidget {
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  String addressToID(String address){
    return address
        .replaceAll("@", "-")
        .replaceAll(".", "-");
  }
  @override
  Widget build(BuildContext context) {
    final String _alert = useProvider(signInAlertProvider).state;
    final _authReference = FirebaseAuth.instance;
    final _databaseReference = FirebaseDatabase.instance.reference();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: "your E-mail address",
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "password",
              ),
              obscureText: true,
            ),
            Text(_alert, style: TextStyle(color: Colors.red),),
            TextButton(
              child: Text('Sign In'),
              onPressed: () async {
                try {
                  UserCredential userCredential = await _authReference.signInWithEmailAndPassword(
                    email: _addressController.text,
                    password: _passwordController.text,
                  );
                  context.read(userIDProvider).state = addressToID(_authReference.currentUser.email);
                  _addressController.text = '';
                  _passwordController.text = '';
                  context.read(rootProvider).state = 1;
                  context.read(authRootProvider).state = 3;

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    context.read(signInAlertProvider).state = "ご利用のメールアドレスは登録されていません。";
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    context.read(signInAlertProvider).state = "パスワードが間違っています。";
                    print('Wrong password provided for that user.');
                  }
                }
              },
            ),
            TextButton(
              onPressed: (){
                _addressController.text = '';
                _passwordController.text = '';
                context.read(signUpAlertProvider).state = "";
                context.read(authRootProvider).state = 0;
              },
              child: Text("アカウントを新規作成"),
            ),
            TextButton(
              onPressed: (){
                // context.read(stateProvider).state = 2;
              },
              child: Text("パスワードを忘れましたか？"),
            )
          ],
        ),
      ),
    );
  }

}