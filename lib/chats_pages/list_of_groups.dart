import 'package:ezhlha/chats_pages/all_groups_tile.dart';
import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/module/user.dart';
import 'package:ezhlha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfGroups extends StatefulWidget {
  @override
  _ListOfGroupsState createState() => _ListOfGroupsState();
}

class _ListOfGroupsState extends State<ListOfGroups> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final allGroups = Provider.of<List<Group>>(context) ?? [];

    return StreamBuilder<Group>(
        stream: DatabaseService(uid: user.uid).groupData,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: allGroups.length,
            itemBuilder: (conbtext, index) {
              return GroupTile(
                group: allGroups[index],
              );
            },
          );
        });
  }
}
