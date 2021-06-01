import 'package:ezhlha/chats_pages/for_new_chat/chat_page.dart';
import 'package:ezhlha/module/group.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final Group group;
  GroupTile({this.group});

  @override
  _GroupTileState createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatPage(
              group: widget.group,
              idGroup: widget.group.groupId,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 100,
            // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            // margin: EdgeInsets.only(bottom: 5),
            child: Card(
              // margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.5),
              child: ListTile(
                title: Text(
                  '${this.widget.group.groupName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: SizedBox(
                      width: 300,
                      height: 3000,
                      child: widget.group.image == ''
                          ? Container()
                          : Image.network(widget.group.image),
                    ),
                  ),
                ),
                // subtitle: Text(
                //     '${widget.order.total}SAR \n$driveIt ${widget.order.time} '),
              ),
            ),
          ),
          // Divider(
          //   color: Colors.black,
          //   // height: 0.5,
          // )
        ],
      ),
    );
  }
}
