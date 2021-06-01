import 'package:flutter/cupertino.dart';

class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String id;

  final String name;
  final String email;
  final int phone;
  final String image;
  final DateTime lastMessageTime;

  UserData(
      {@required this.id,
      @required this.name,
      @required this.email,
      @required this.phone,
      @required this.image,
      this.lastMessageTime});
}
