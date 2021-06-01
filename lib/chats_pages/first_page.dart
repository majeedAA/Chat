import 'package:ezhlha/chats_pages/account.dart';
import 'package:ezhlha/chats_pages/sign_in.dart';
import 'package:flutter/material.dart';

class AllPagesOfChat extends StatefulWidget {
  @override
  _AllPagesOfChatState createState() => _AllPagesOfChatState();
}

class _AllPagesOfChatState extends State<AllPagesOfChat> {
  int _curruntIndex = 1;

  List<Widget> _widgetOption = <Widget>[
    Account(),
    SignIn(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(_curruntIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curruntIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            // label: 'Account',
            title: Text('Account'),
            backgroundColor: Colors.lightBlue[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
            backgroundColor: Colors.lightBlue[600],
          ),
         
        ],
        onTap: (index) {
          setState(() {
            _curruntIndex = index;
          });
        },
      ),
    );
  }
}