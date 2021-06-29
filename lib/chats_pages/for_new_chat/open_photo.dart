import 'package:flutter/material.dart';

class OpenPhoto extends StatefulWidget {
  final String path;

  const OpenPhoto({@required this.path});

  @override
  _OpenPhotoState createState() => _OpenPhotoState();
}

class _OpenPhotoState extends State<OpenPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.save_alt_rounded), onPressed: () async {}),
            IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
      body: Center(child: Image.network(widget.path)),
    );
  }
}
