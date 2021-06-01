import 'package:ezhlha/home_page.dart';
import 'package:ezhlha/login_pages/wapper.dart';
import 'package:ezhlha/module/user.dart';
import 'package:ezhlha/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}