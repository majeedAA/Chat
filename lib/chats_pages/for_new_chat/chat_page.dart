import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ezhlha/chats_pages/for_new_chat/new_massage_button.dart';
import 'package:ezhlha/chats_pages/for_new_chat/space_chat.dart';
import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/module/massage.dart';
import 'package:ezhlha/module/user.dart';
import 'package:ezhlha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  Group group;
  String idGroup;
  ChatPage({this.group, this.idGroup});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage(String id, String image, String name, String email,
      String idGroup) async {
    FocusScope.of(context).unfocus();

    await DatabaseService()
        .uploadMessage(id, idGroup, message ?? '', image ?? '', name, email);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Message>>.value(
        value: massages,
        child: StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              UserData userData = snapshot.data ??
                  UserData(
                      email: ' ',
                      name: ' ',
                      id: user.uid,
                      phone: 0,
                      image: ' ');
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey[300],
                  title: ListTile(
                    title: Text(
                      '${this.widget.group.groupName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // leading: CircleAvatar(
                    //   radius: 25.0,
                    //   backgroundColor: Colors.white,
                    //   child: ClipOval(
                    //     child: SizedBox(
                    //       width: 300,
                    //       height: 3000,
                    //       child: widget.group.image == ''
                    //           ? Container()
                    //           : Image.network(widget.group.image),
                    //     ),
                    //   ),
                    // ),
                    // subtitle: Text(
                    //     '${widget.order.total}SAR \n$driveIt ${widget.order.time} '),
                  ),
                ),
                body: Container(
                  child: ChatSpace(
                    idGroup: widget.idGroup,
                  ),
                ),
                bottomNavigationBar: sendMassage(user.uid, userData.image ?? '',
                    userData.name, userData.email, widget.idGroup),
              );
            }));
  }

  Widget sendMassage(
      String id, String image, String name, String email, String idGroup) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                labelText: 'Type your message',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) => setState(() {
                message = value;
              }),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              message.trim().isEmpty
                  ? null
                  : sendMessage(id, image, name, email, idGroup);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Message>> get massages {
    final refMessages = Firestore.instance
        .collection('group/${widget.idGroup}/massage')
        .orderBy('createdAt');
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
      );
    }).toList();
  }
}
