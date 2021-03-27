

import 'dart:convert';
import 'package:meta/meta.dart';

class Friend {

  Friend({
    @required this.avatar,
    @required this.name,
    @required this.email,
    this.introduction,
    this.age,
    this.university,
    this.faculty,
    this.department,
  });

  String avatar;
  String name;
  final String email;
  String introduction;
  String age; //これは年度入学　例）2021とか2020
  String university;
  String faculty;
  String department;


  static List<Friend> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Friend.fromMap(obj))
        .toList()
        .cast<Friend>();
  }

  static Friend fromMap(Map map) {
    var name = map['name'];

    return new Friend(
      avatar: map['picture']['large'],
      name: '${_capitalize(name['first'])} ${_capitalize(name['last'])}',
      email: map['email'],
    );
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
}
