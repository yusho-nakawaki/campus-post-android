import 'package:campuspost/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpPage extends HookWidget{
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String _alert = useProvider(signUpAlertProvider).state;
    final _authReference = FirebaseAuth.instance;
    final _databaseReference = FirebaseDatabase.instance.reference();
    String addressToID(String address){
      return address
          .replaceAll("@", "-")
          .replaceAll(".", "-");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
              child: Text('Sign Up'),
              onPressed: () async {
                try {
                  UserCredential userCredential = await _authReference.createUserWithEmailAndPassword(
                      email: _addressController.text,
                      password: _passwordController.text
                  );
                  _databaseReference
                      .child('users')
                      .child(addressToID(_authReference.currentUser.email))
                      .set({
                    'email': addressToID(_authReference.currentUser.email),
                  });
                  _databaseReference
                      .child('all_users')
                      .child(addressToID(_authReference.currentUser.email))
                      .set({
                    'name': addressToID(_authReference.currentUser.email),
                  });
                  _addressController.text = "";
                  _passwordController.text = "";
                  context.read(authRootProvider).state = 1;

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    context.read(signUpAlertProvider).state = "安全性が低いパスワードです。";
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    context.read(signUpAlertProvider).state = "既に使用されているメールアドレスです。";
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            TextButton(
              onPressed: (){
                _addressController.text = '';
                _passwordController.text = '';
                context.read(signInAlertProvider).state = "";
                context.read(authRootProvider).state = 1;
              },
              child: Text("アカウントをお持ちですか？"),
            )
          ],
        ),
      ),
    );
  }
}