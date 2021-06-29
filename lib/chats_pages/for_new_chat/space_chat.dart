import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezhlha/chats_pages/for_new_chat/massage_tile.dart';
// import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/module/massage.dart';
// import 'package:ezhlha/module/user.dart';
// import 'package:ezhlha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatSpace extends StatefulWidget {
  String idGroup;
  ChatSpace({this.idGroup});
  @override
  _ChatSpaceState createState() => _ChatSpaceState();
}

class _ChatSpaceState extends State<ChatSpace> {
  @override
  Widget build(BuildContext context) {
    // final CollectionReference refMessages =
    //     Firestore.instance.collection('group/${widget.idGroup}/massage');
    // final user = Provider.of<User>(context);
    var chat = Provider.of<List<Message>>(context) ?? [];
    // print(widget.idGroup);
    return StreamBuilder<List<Message>>(
        stream: massages,
        builder: (context, snapshot) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: true,
            shrinkWrap: true,
            itemCount: chat.length,
            itemBuilder: (conbtext, index) {
              return ChatMassageTile(
                message: chat[index],
              );
            },
          );
        });
  }

  Stream<List<Message>> get massages {
    final refMessages = Firestore.instance.collection('massage');
    return refMessages.snapshots().map(_chatListFromSnapshot);
  }

  List<Message> _chatListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Message(
        idUser: doc.data['userId'] ?? ' ',
        username: doc.data['username'] ?? ' ',
        image: doc.data['image'] ?? ' ',
        message: doc.data['message'] ?? '',
        createdAt: doc.data['createdAt'].toDate(),
        email: doc.data['email'] ?? ' ',
        messageType: doc.data['messageType'] ?? ' ',
      );
    }).toList();
  }
}
//  Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);
//     final chat = Provider.of<List<Message>>(context) ?? [];
//     return StreamBuilder<UserData>(
//         stream: DatabaseService(uid: user.uid).userData,
//         builder: (context, snapshot) {
//           return ListView.builder(
//             itemCount: chat.length,
//             itemBuilder: (conbtext, index) {
//               return ChatMassageTile(
//                 message: chat[index],
//               );
//             },
//           );
//         });
