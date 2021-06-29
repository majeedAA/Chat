import 'dart:io';

import 'package:ezhlha/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class AddPhoto extends StatefulWidget {
  File imageFile;
  final String userId;
  final String groupId;
  final String userImage;
  final String userName;

  AddPhoto(
      {@required this.imageFile,
      @required this.userId,
      @required this.groupId,
      @required this.userImage,
      @required this.userName});

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  Future _cropImage(File imageFile) async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square]
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth:512,
        // maxHeight: 512,
        // toolbarColor: Colors.purple,
        );
    setState(() {
      widget.imageFile = cropped ?? imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    File _image = widget.imageFile ?? null;
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                if (_image != null) {
                  _image = File(_image.path);
                  String fileName = _image.path.split('/').last;
                  StorageReference firebaseStorgeRef =
                      FirebaseStorage.instance.ref().child(fileName);

                  StorageUploadTask uploadTask =
                      firebaseStorgeRef.putFile(_image);
                  var dowurl =
                      await (await uploadTask.onComplete).ref.getDownloadURL();
                  var url = dowurl.toString();

                  await DatabaseService().uploadMessage(
                      widget.userId,
                      widget.groupId,
                      url ?? '',
                      widget.userImage ?? '',
                      widget.userName,
                      widget.userImage,
                      'image');
                  print('Done');
                  Navigator.pop(context);
                } else {
                  print('No image selected.');
                }
              },
            ),
            IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (widget.imageFile != null) ...[
            Image.file(widget.imageFile),
            FlatButton(
              child: Icon(
                Icons.crop,
                color: Colors.white,
              ),
              onPressed: () {
                _cropImage(widget.imageFile);
              },
            )
          ]
        ],
      ),
    );
  }
}
