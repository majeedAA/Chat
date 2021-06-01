import 'package:ezhlha/home_page.dart';
import 'package:ezhlha/login_pages/authenticate.dart';
import 'package:ezhlha/module/user.dart';
// import 'package:ezhlha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // return either the Home or Authenticate widget
    if (user != null){
      return Authenticate();
    } else {
      return EzhlhaHomePage();
    }
    
  }
}