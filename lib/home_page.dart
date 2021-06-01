import 'package:ezhlha/login_pages/signUp_page.dart';
import 'package:ezhlha/services/auth.dart';
import 'package:ezhlha/shareing/loading.dart';
import 'package:flutter/material.dart';

class EzhlhaHomePage extends StatefulWidget {
  @override
  _EzhlhaHomePageState createState() => _EzhlhaHomePageState();
}

class _EzhlhaHomePageState extends State<EzhlhaHomePage> {
   final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
   String error = '';
  bool loading = false;
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        :Scaffold(
      appBar: AppBar(title: Text('Ezhlha Chat'),
      backgroundColor: Colors.redAccent[700],),
      backgroundColor: Colors.deepOrange[50],
      body: Form(
        key: _formKey,
              child: ListView(
          children: [
            Container(
              child:Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Container(
                   height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 165,vertical: 10),
                   child: Image(image: NetworkImage('https://ezhalha.com.sa/theme/images/default_img.png',),),),
                   SizedBox(height: 100,),
                  Text('Welcome in Ezhlha Chat <3',
                  style: TextStyle(color: Color(0xffbc3908),
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
                  
                  ),
                  SizedBox(height: 70,),
                  //Email
                   Container(
                     padding: EdgeInsets.symmetric(horizontal:10),
                     child: TextFormField(
                              validator: (val) =>
                                  !val.contains(("gmail")) && !val.contains(("hotmail"))
                                      ? 'Enter correct an email'
                                      : null,
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
                  //password 
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
                          ),),
                          buildForgotPassword(),

                  Container(
                          child: Row(
                            children: <Widget>[
                              // for Singin
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 7.0, vertical: 10),
                                  child: FloatingActionButton(
                                      //  heroTag: "btn1",
                                      backgroundColor: Color(0xffec5766),
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                       
                                       onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result =
                                          await _auth.signInWithEmailAndPassword(
                                              email, pass);
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                          error =
                                              'The username or password you provided is incorrect. Please try again.';
                                        });
                                      }
                                    }
                                  }),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 7.0, vertical: 10),
                                  child: new FloatingActionButton(
                                    heroTag: "btn2",
                                    backgroundColor: Color(0xffec5766),
                                    child: Text("Sign Up"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SignUp(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   width: 250,
                        //   padding: EdgeInsets.all(10),
                        //   child: new FloatingActionButton(
                        //     heroTag: "btn3",
                        //     backgroundColor: Color(0xffc42348),
                        //     child: Text("Sign Up"),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(5.0),
                        //     ),
                        //     onPressed: () {
                        //     //  Navigator.pushNamed(context, '/SingUp');
                        //     },
                        //   ),
                        // ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),      
                ],
              )
            ),
          ],
        ),
      ),
    ); 
  }
  Widget buildForgotPassword() => Container(
        alignment: Alignment.centerRight,
        
        child: TextButton(
          child: Text('Forgotten Password?',style: TextStyle(color: Colors.orange[900],),),
          onPressed: () {

          },
        ),
      );
}