import 'dart:io';

import 'package:ezhlha/app_localization.dart';
import 'package:ezhlha/module/user.dart';
import 'package:ezhlha/services/database.dart';
import 'package:ezhlha/shareing/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddGroup extends StatefulWidget {
  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  String _groupName = '';
  File _image;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _groupImage = '';
    final user = Provider.of<User>(context);

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
    }

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Center(
            child: Text(
              Applocaliztion.of(context).translate('newGroup'),
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: CircleAvatar(
              backgroundColor: Colors.lightBlue[50],
              radius: 70,
              child: ClipOval(
                child: SizedBox(
                    width: 300,
                    height: 2000,
                    child: _image == null
                        ? Icon(
                            Icons.camera,
                            size: 130,
                            color: Colors.lightBlue[800],
                          )
                        : Image.file(_image)),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
              child: Text(
            Applocaliztion.of(context).translate('imageGroup'),
            style: TextStyle(color: Colors.deepPurple[700], fontSize: 17),
          )),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: Applocaliztion.of(context).translate('groupName'),
            ),
            validator: (val) => val.isEmpty ? 'you must make a name' : null,
            onChanged: (val) => setState(() => _groupName = val),
          ),
          SizedBox(height: 10.0),
          Builder(
            builder: (context) => RaisedButton(
                color: Color(0xff515c5e),
                child: Text(
                  Applocaliztion.of(context).translate('Add'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (_image != null) {
                      _image = File(_image.path);
                      String fileName = _image.path.split('/').last;
                      StorageReference firebaseStorgeRef =
                          FirebaseStorage.instance.ref().child(fileName);

                      StorageUploadTask uploadTask =
                          firebaseStorgeRef.putFile(_image);
                      var dowurl = await (await uploadTask.onComplete)
                          .ref
                          .getDownloadURL();
                      var url = dowurl.toString();

                      _groupImage = url;
                    }
                    await DatabaseService(uid: user.uid).updateGroup(
                      user.uid ?? '',
                      _groupImage ?? '',
                      _groupName ?? '',
                    );
                    Navigator.pop(context);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("error"),
                    ));
                  }
                }),
          ),
        ],
      ),
    );
  }
}
