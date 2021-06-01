import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/module/massage.dart';
import 'package:ezhlha/module/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMassageTile extends StatefulWidget {
  final Message message;
  ChatMassageTile({this.message});
  @override
  _ChatMassageTileState createState() => _ChatMassageTileState();
}

class _ChatMassageTileState extends State<ChatMassageTile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.all(1),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          color: widget.message.idUser == user.uid
              ? Colors.lightBlue[50]
              : Colors.teal[50],
          shape: BoxShape.rectangle,
        ),
        margin: EdgeInsets.all(5),
        child: Row(
          textDirection: widget.message.idUser == user.uid
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: SizedBox(
                  width: 300,
                  height: 3000,
                  child: widget.message.image == ''
                      ? Container()
                      : Image.network(widget.message.image),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              children: [
                Text(
                  widget.message.username,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.indigo[900],
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.message.message,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
