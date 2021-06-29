import 'dart:io';

import 'package:ezhlha/app_localization.dart';
import 'package:ezhlha/module/user.dart';
import 'package:ezhlha/services/auth.dart';
import 'package:ezhlha/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  File _image;
  String theImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRISxBTQ88B9PvlreCwRY0_wqZK7y4XoG4zIQ&usqp=CAU';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _image = File(image.path);
        String fileName = _image.path.split('/').last;
        StorageReference firebaseStorgeRef =
            FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = firebaseStorgeRef.putFile(_image);
        var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
        var url = dowurl.toString();
        theImage = url;
        DatabaseService(uid: user.uid).updateImageUserData(theImage);
        print('done');
      } else {
        print('No image selected.');
      }
    }

    final AuthService _auth = AuthService();
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    // final users = Provider.of<List<UserData>>(context) ?? [];

    // for (var i = 0; i < users.length; i++) {
    //   if (users[i].id == user.uid) {
    //     email = users[i].email;
    //     phone = users[i].phone.toString();
    //     name = users[i].name;
    //     image = users[i].image;
    //   }
    // }
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data ??
              UserData(
                  email: ' ',
                  name: ' ',
                  id: user.uid,
                  phone: 0,
                  image:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRISxBTQ88B9PvlreCwRY0_wqZK7y4XoG4zIQ&usqp=CAU');
          theImage = userData.image;
          return Container(
            child: new Stack(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(colors: [
                    const Color(0xFF26CBE6),
                    const Color(0xFF26CBC0),
                  ], begin: Alignment.topCenter, end: Alignment.center)),
                ),
                new Scaffold(
                  backgroundColor: Colors.transparent,
                  body: new Container(
                    child: new Stack(
                      children: <Widget>[
                        new Align(
                          alignment: Alignment.center,
                          child: new Padding(
                            padding: new EdgeInsets.only(top: _height / 15),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: _height / 10,
                                  child: ClipOval(
                                      child: SizedBox(
                                          width: 300,
                                          height: 3000,
                                          child: Image.network(theImage))),
                                ),
                                IconButton(
                                  icon: Icon(Icons.camera),
                                  onPressed: () {
                                    getImage();
                                    print(userData.image);
                                  },
                                ),
                                new SizedBox(
                                  height: _height / 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(top: _height / 2.5),
                          child: new Container(
                            color: Colors.white,
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(
                              top: _height / 2.9,
                              left: _width / 20,
                              right: _width / 20),
                          child: new ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              new Padding(
                                padding: new EdgeInsets.only(top: _height / 20),
                                child: new Column(
                                  children: <Widget>[
                                    infoChild(
                                        _width, Icons.person, userData.name),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    infoChild(
                                        _width, Icons.email, userData.email),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    infoChild(_width, Icons.call,
                                        userData.phone.toString()),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Padding(
                                      padding: new EdgeInsets.only(
                                          top: _height / 30),
                                      child: new Container(
                                        decoration: new BoxDecoration(
                                            color: const Color(0xFF26CBE6),
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(
                                                    _height / 40)),
                                            boxShadow: [
                                              new BoxShadow(
                                                  color: Colors.black87,
                                                  blurRadius: 2.0,
                                                  offset: new Offset(0.0, 1.0))
                                            ]),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: FlatButton.icon(
                                            icon: Icon(Icons.person),
                                            label: Text('logout',
                                                style: new TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onPressed: () async {
                                              await _auth.signOut();
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget infoChild(double width, IconData icon, data) => new Padding(
        padding: new EdgeInsets.only(bottom: 8.0),
        child: new InkWell(
          child: new Row(
            children: <Widget>[
              new SizedBox(
                width: width / 10,
              ),
              new Icon(
                icon,
                color: const Color(0xFF26CBE6),
                size: 36.0,
              ),
              new SizedBox(
                width: width / 20,
              ),
              new Text(data)
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}

// appBar: AppBar(
//         backgroundColor: Colors.blueGrey[400],
//         title: Text(Applocaliztion.of(context).translate('account')),
//         actions: <Widget>[
//           FlatButton.icon(
//             icon: Icon(Icons.person),
//             label: Text(Applocaliztion.of(context).translate('logout')),
//             onPressed: () async {
//               await _auth.signOut();
//             },
//           ),
//         ],

//       ),
