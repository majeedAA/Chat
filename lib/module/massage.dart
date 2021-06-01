import 'package:ezhlha/module/utils.dart';
import 'package:flutter/material.dart';

class Message {
  final String idUser;
  final String image;
  final String username;
  final String message;
  final DateTime createdAt;
  final String email;

  const Message(
      {@required this.idUser,
      @required this.image,
      @required this.username,
      @required this.message,
      this.createdAt,
      @required this.email});
}
