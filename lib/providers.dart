
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:campuspost/talk_elements/bubble.dart';

final signInAlertProvider = StateProvider((ref) => "");
final signUpAlertProvider = StateProvider((ref) => "");
final authRootProvider = StateProvider((ref) {
  int num = 0;
  if (FirebaseAuth.instance.currentUser != null) {num = 3;}
  return num;
}); //0:signup, 1:signin, 2:pw_check, 3:authenticated
final rootProvider = StateProvider((ref) => 1);
//0:profile, 1:home, 2:talk, 3:blog
final userIDProvider = StateProvider<String>((ref) {
  String addressToID(String address){
    return address
        .replaceAll("@", "-")
        .replaceAll(".", "-");
  };
  String id = "";
  if (FirebaseAuth.instance.currentUser != null) {
    id = addressToID(FirebaseAuth.instance.currentUser.email);
  }
  return id;
});
// final StateProvider timetableProvider = StateProvider<Map<String, String>>((ref) {
//   final String _userID = useProvider(userIDProvider).state;
//   final snapshot = FirebaseFirestore
//       .instance
//       .collection('users')
//       .doc(_userID)
//       .get()
//       .then((value) {
//         final Map<String, String> map =  value.data();
//         return map;
//       }
//       );
// });
// final databaseProvider = StateProvider((ref) => FirebaseDatabase.instance.reference());
// final authProvider = StateProvider((ref) => FirebaseAuth.instance);
