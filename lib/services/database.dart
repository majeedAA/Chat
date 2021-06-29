import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezhlha/module/group.dart';
import 'package:ezhlha/module/massage.dart';
import 'package:ezhlha/module/user.dart';

class DatabaseService {
  final String uid;
  // final String idGroup;

  DatabaseService({
    this.uid,
  });

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  final CollectionReference groupCollection =
      Firestore.instance.collection('group');

  final CollectionReference chatCollection =
      Firestore.instance.collection('chat');

  // final CollectionReference massageCollection =
  //     Firestore.instance.collection('group/$idUser/messages');

  Future<void> updateUserData(
    String id,
    String image,
    String name,
    String email,
    int phone,
  ) async {
    return await userCollection.document(uid).setData({
      'idUser': id,
      'image': image,
      'name': name,
      'email': email,
      'phone': phone,
    });
  }

  Future<void> updateGroup(
    String userId,
    String image,
    String name,
  ) async {
    return await groupCollection.document().setData({
      'userId': userId,
      'image': image,
      'groupName': name,
    });
  }

  Future<void> updateImageUserData(
    String image,
  ) async {
    return await userCollection.document(uid).updateData({
      'image': image,
    });
  }

  Future uploadMessage(String idUser, String idGroup, String message,
      String image, String name, String email, String messageType) async {
    final refMessages = Firestore.instance.collection('group/$idGroup/massage');

    await refMessages.document().setData({
      'userId': idUser,
      'image': image,
      'username': name,
      'message': message,
      'createdAt': DateTime.now(),
      'email': email,
      'messageType': messageType
    });
  }

  // item list from snapshot
  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return UserData(
        id: doc.data['idUser'] ?? ' ',
        name: doc.data['name'] ?? ' ',
        email: doc.data['email'] ?? ' ',
        phone: doc.data['phone'] ?? 0,
        image: doc.data['image'] ?? ' ',
      );
    }).toList();
  }

  // List<Message> _chatListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc) {
  //     //print(doc.data);
  //     return Message(
  //       idUser: doc.data['userId'] ?? ' ',
  //       username: doc.data['username'] ?? ' ',
  //       image: doc.data['image'] ?? ' ',
  //       message: doc.data['message'] ?? '',
  //       createdAt: doc.data['createdAt'].toDate(),
  //       email: doc.data['email'] ?? ' ',
  //     );
  //   }).toList();
  // }

  List<Group> _groupListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Group(
        groupId: doc.documentID,
        groupName: doc.data['groupName'] ?? '',
        createBy: doc.data['createBy'] ?? '',
        image: doc.data['image'] ?? '',
      );
    }).toList();
  }

  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

// Stream<List<Message>> getMassages(){
  // Stream<List<Message>> get massages {
  //   // print(uid);
  //   final CollectionReference refMessages =
  //       Firestore.instance.collection('massage');
  //   return refMessages.snapshots().map(_chatListFromSnapshot);
  // }

  Stream<List<Group>> get groups {
    return groupCollection.snapshots().map(_groupListFromSnapshot);
  }

  // get market stream
  Stream<QuerySnapshot> get info {
    return userCollection.snapshots();
  }

  Stream<QuerySnapshot> get allGroup {
    return groupCollection.snapshots();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      id: uid,
      name: snapshot.data['name'],
      phone: snapshot.data['phone'],
      email: snapshot.data['email'],
      image: snapshot.data['image'],
    );
  }

  // user data from snapshots
  Message _chatDataFromSnapshot(DocumentSnapshot snapshot) {
    return Message(
      idUser: snapshot.data['userId'],
      username: snapshot.data['username'],
      image: snapshot.data['image'],
      message: snapshot.data['message'],
      createdAt: snapshot.data['createdAt'],
      email: snapshot.data['email'],
      messageType: snapshot.data['messageType'],
    );
  }

  Group _groupDataFromSnapshot(DocumentSnapshot snapshot) {
    return Group(
      groupId: snapshot.data['groupId'],
      groupName: snapshot.data['groupName'],
      createBy: snapshot.data['createBy'],
      image: snapshot.data['image'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<Message> get chatData {
    // print(uid);
    final CollectionReference refMessages =
        Firestore.instance.collection('massage');
    return refMessages.document(uid).snapshots().map(_chatDataFromSnapshot);
  }

  Stream<Group> get groupData {
    return groupCollection
        .document(uid)
        .snapshots()
        .map(_groupDataFromSnapshot);
  }
}
