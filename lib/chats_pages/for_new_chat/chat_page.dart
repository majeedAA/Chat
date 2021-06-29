import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezhlha/chats_pages/for_new_chat/add_location.dart';
import 'package:ezhlha/chats_pages/for_new_chat/add_photo.dart';
// import 'package:ezhlha/chats_pages/for_new_chat/new_massage_button.dart';
import 'package:ezhlha/chats_pages/for_new_chat/space_chat.dart';
import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/module/massage.dart';
import 'package:ezhlha/module/user.dart';
import 'package:ezhlha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  Group group;
  String idGroup;
  ChatPage({this.group, this.idGroup});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // File _imageFile;
  final _controller = TextEditingController();
  String message = '';

  void sendMessage(String id, String image, String name, String email,
      String idGroup, String messageType, BuildContext context) async {
    FocusScope.of(context).unfocus();

    await DatabaseService().uploadMessage(
        id, idGroup, message ?? '', image ?? '', name, email, messageType);

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
                  email: ' ', name: ' ', id: user.uid, phone: 0, image: ' ');
          return Scaffold(
            // resizeToAvoidBottomPadding: false,
            //resizeToAvoidBottomInset: false,
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
                leading: Visibility(
                  visible: widget.group.image != '' ? true : false,
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(widget.group.image),
                    child: ClipOval(
                      child: SizedBox(
                        width: 300,
                        height: 3000,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(new FocusNode()),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 157,
                      child: ChatSpace(
                        idGroup: widget.idGroup,
                      ),
                    ),
                  ),
                  sendMassage(user.uid, userData.image ?? '', userData.name,
                      userData.email, widget.idGroup, context),
                ],
              ),
            ),
            // bottomNavigationBar: sendMassage(user.uid, userData.image ?? '',
            //     userData.name, userData.email, widget.idGroup),
          );
        },
      ),
    );
  }

///////////////////////////////////////////////////
  Widget sendMassage(String id, String image, String name, String email,
      String idGroup, BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
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
                  : sendMessage(
                      id, image, name, email, idGroup, 'message', context);
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
          SizedBox(width: 5),
          GestureDetector(
            onTap: () => showModalBottomSheet(
              enableDrag: false,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              context: context,
              builder: (context) => moreType(context, id, idGroup, image, name),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Message>> get massages {
    final refMessages = Firestore.instance
        .collection('group/${widget.idGroup}/massage')
        .orderBy('createdAt', descending: true);
    return refMessages.snapshots().map(_chatListFromSnapshot);
  }

  List<Message> _chatListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
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

  Widget moreType(BuildContext context, String userId, String groupId,
      String userImage, String userName) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50),
          FlatButton.icon(
            // minWidth: MediaQuery.of(context).size.width - 40,
            onPressed: () {
              setState(() async {
                File selected =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddPhoto(
                              imageFile: selected,
                              userId: userId,
                              userName: userName,
                              userImage: userImage,
                              groupId: groupId,
                            )));
                // Navigator.pop(context);
              });
            },
            icon: Icon(Icons.camera_alt_outlined),
            label: Text('                         Add photo'),
          ),
          SizedBox(height: 10),
          FlatButton.icon(
            minWidth: MediaQuery.of(context).size.width - 40,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddLocation()));
            },
            icon: Icon(Icons.location_on_outlined),
            label: Text('                         Add Location'),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
