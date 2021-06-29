import 'package:ezhlha/app_localization.dart';
import 'package:ezhlha/chats_pages/add_new_group.dart';
import 'package:ezhlha/chats_pages/list_of_groups.dart';
import 'package:ezhlha/chats_pages/search_bar.dart';
import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/services/auth.dart';
import 'package:ezhlha/services/database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  bool show_add_group = false;
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reomteConfig = await RemoteConfig.instance;
      // final defaults = <String, bool>{
      //   'show_add_group': true,
      // };
      // setState(() {
      //   show_add_group = defaults['show_add_group'];
      // });

      await reomteConfig.fetch(expiration: const Duration(seconds: 0));
      await reomteConfig.activateFetched();
      setState(() {
        show_add_group = reomteConfig.getBool('show_add_group');
      });
    });
  }

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
              title: Text(Applocaliztion.of(context).translate('chat')),
              actions: <Widget>[
                Visibility(
                  visible: show_add_group,
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.mark_chat_unread_rounded,
                      color: Colors.blue[50],
                    ),
                    label: Text(''),
                    onPressed: () => _showSettingsPanel(),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SearchBarGroup()),
                      );
                    }),
              ],
            ),
            body: ListOfGroups(),
            // bottomNavigationBar: Icon(Icons.search),
          );
        });
  }
}
