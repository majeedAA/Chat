// import 'dart:io';

import 'package:ezhlha/services/auth.dart';
import 'package:ezhlha/shareing/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';

  String name = '';

  String email = '';

  String pass = '';

  int phone = 0;

  bool loading = false;

  String theImage;

String defoltImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRISxBTQ88B9PvlreCwRY0_wqZK7y4XoG4zIQ&usqp=CAU';

// final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

//  File _image;
//      Future getImage() async {
//       var image = await ImagePicker.pickImage(source: ImageSource.gallery);
     
//       if (image != null) {
//         theImage = image.path;
//         print(theImage);
        // _image = File(image.path);
        // String fileName = _image.path.split('/').last;
        // StorageReference firebaseStorgeRef =
        //     FirebaseStorage.instance.ref().child(fileName);
        // StorageUploadTask uploadTask = firebaseStorgeRef.putFile(_image);
        // var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
        // var url = dowurl.toString();
        // theImage = url;
        // DatabaseService(uid: user.uid).updateImageUserData(theImage);
        // print('done');
     // } 
      // else {
      //   print('No image selected.');
      // }
  //  }
    
    
    return  loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'SignUp',
                style: TextStyle(color: Color(0xffffffff)),
              ),
               backgroundColor: Colors.redAccent[700],),
         
            body: Form(
              key: _formKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //      getImage();
                  //   },
                  //   child: CircleAvatar(
                      
                  //                 backgroundColor: Colors.white,
                  //                  radius:  70,
                  //                 child: ClipOval(
                  //                   child: SizedBox(
                  //                     width: 300,
                  //                     height: 3000,
                  //                     child: theImage == ''
                  //                         ? Image.network(defoltImage)
                  //                         : Image.network(theImage),
                  //                   ),
                  //                 ),
                  //               ),
                  // ),
                 // Center(child: Text('Add photo',style: TextStyle(color: Colors.deepPurple[700], fontSize: 17),)),
                 SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter a correct email' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Full Name',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                    child: TextFormField(
                      validator: (val) =>
                          !val.contains(("gmail")) || !val.contains(("hotmail"))
                              ? null
                              : 'Enter a correct email',
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                    child: TextFormField(
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => pass = val);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password',
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter a correct phone' : null,
                      onChanged: (val) {
                        setState(() => phone = int.parse(val));
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone',
                      ),
                    ),
                  ),
                  
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 10),
                            child: new FloatingActionButton(
                              heroTag: "btn1",
                              backgroundColor: Color(0xff4a6fa5),
                              child: Text("Sign Up"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email,
                                          pass,
                                         theImage ?? defoltImage,
                                          name,
                                          phone,
                                          );

                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Please supply a valid email';
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 10),
                            child: new FloatingActionButton(
                              heroTag: "btn2",
                              backgroundColor: Color(0xff4a6fa5),
                              child: Text("Back"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () {
                                setState(() => loading = true);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  )
                ],
              ),
            ),
          );
  }
 }
