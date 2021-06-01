import 'dart:io';

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
  String _groupImage = '';
  String _groupId;
  String _createBy;

  File _image;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _image = File(image.path);
        print(_image.path);
        String fileName = _image.path.split('/').last;
        print(fileName);
        StorageReference firebaseStorgeRef =
            FirebaseStorage.instance.ref().child(fileName);

        StorageUploadTask uploadTask = firebaseStorgeRef.putFile(_image);
        var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
        var url = dowurl.toString();
        _groupImage = url;
        print(_groupImage);
        print('donkke');
      } else {
        print('No image selected.');
      }
    }

    print(_groupImage.isNotEmpty ? 'hh' : 'ff');
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Center(
            child: Text(
              'New Group',
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
                  height: 3000,
                  child: _groupImage == ''
                      ? Icon(
                          Icons.camera,
                          size: 130,
                          color: Colors.lightBlue[800],
                        )
                      : Image.network(_groupImage),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
              child: Text(
            'Group image',
            style: TextStyle(color: Colors.deepPurple[700], fontSize: 17),
          )),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Group Name',
            ),
            validator: (val) => val.isEmpty ? 'you must make a name' : null,
            onChanged: (val) => setState(() => _groupName = val),
          ),
          SizedBox(height: 10.0),
          RaisedButton(
              color: Color(0xff515c5e),
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await DatabaseService(uid: user.uid).updateGroup(
                    user.uid ?? '',
                    _groupImage ?? '',
                    _groupName ?? '',
                  );
                  Navigator.pop(context);
                } else {
                  return Loading();
                }
              }),
        ],
      ),
    );
  }
}
