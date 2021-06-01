import 'package:ezhlha/chats_pages/add_new_group.dart';
import 'package:ezhlha/chats_pages/list_of_groups.dart';
import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/services/auth.dart';
import 'package:ezhlha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: AddGroup(),
            );
          });
    }

    return StreamProvider<List<Group>>.value(
        value: DatabaseService().groups,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[300],
              elevation: 0.0,
              title: Text('Chats'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.mark_chat_unread_rounded,
                    color: Colors.blue[50],
                  ),
                  label: Text(''),
                  onPressed: () => _showSettingsPanel(),
                ),
              ],
            ),
            body: ListOfGroups(),
          );
        });
  }
}
