import 'package:ezhlha/app_localization.dart';
import 'package:ezhlha/login_pages/signUp_page.dart';
import 'package:ezhlha/main.dart';
import 'package:ezhlha/module/language.dart';
import 'package:ezhlha/services/auth.dart';
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
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(Applocaliztion.of(context).translate('first_string')),
        backgroundColor: Colors.redAccent[700],
        actions: [
          // FlatButton.icon(
          //   icon: Icon(Icons.translate, color: Colors.white),
          //   label: Text(Applocaliztion.of(context).translate('translate'),
          //       style: TextStyle(
          //         color: Colors.white,
          //       )),
          //   onPressed: () async {},
          // ),

          Padding(
            padding: EdgeInsets.all(8),
            child: DropdownButton(
              underline: SizedBox(),
              icon: Icon(
                Icons.translate_rounded,
                color: Colors.white,
              ),
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (lang) => DropdownMenuItem(
                      value: lang,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(lang.flag),
                          Text(lang.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (Language lang) {
                Locale _temp;
                switch (lang.languageCode) {
                  case 'en':
                    _temp = Locale(lang.languageCode, 'US');
                    break;
                  case 'ar':
                    _temp = Locale(lang.languageCode, ' EG');
                    break;
                  default:
                    _temp = Locale('en', 'US');
                    break;
                }
                MyApp.setLocal(context, _temp);
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.deepOrange[50],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 165, vertical: 10),
                  child: Image(
                    image: NetworkImage(
                      'https://ezhalha.com.sa/theme/images/default_img.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text(
                  Applocaliztion.of(context).translate('second_string'),
                  style: TextStyle(
                      color: Color(0xffbc3908),
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 70,
                ),
                //Email
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    validator: (val) => !val.contains(("mail"))
                        ? 'Enter correct an email'
                        : null,
                    onChanged: (val) {
                      setState(() => email = val.trim());
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Applocaliztion.of(context).translate('email'),
                    ),
                  ),
                ),
                //password
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                  child: TextFormField(
                    validator: (val) => val.length < 6
                        ? 'Enter a password 6+ chars long'
                        : null,
                    onChanged: (val) {
                      setState(() {
                        pass = val.toString().trim();
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          Applocaliztion.of(context).translate('password'),
                    ),
                  ),
                ),
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
                                Applocaliztion.of(context).translate('login'),
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  dynamic result = await _auth
                                      .signInWithEmailAndPassword(email, pass);
                                  if (result == null) {
                                    setState(() {
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
                            child: Text(
                              Applocaliztion.of(context).translate('signUp'),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp(),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForgotPassword() => Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          child: Text(
            Applocaliztion.of(context).translate('forgetPassword'),
            style: TextStyle(
              color: Colors.orange[900],
            ),
          ),
          onPressed: () {},
        ),
      );

  void _changeLanguage(Language lang) {
    print(lang.languageCode);
  }
}
