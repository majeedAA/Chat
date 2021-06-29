import 'package:ezhlha/chats_pages/for_new_chat/open_photo.dart';
import 'package:ezhlha/module/massage.dart';
import 'package:ezhlha/module/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ChatMassageTile extends StatefulWidget {
  final Message message;
  ChatMassageTile({@required this.message});
  @override
  _ChatMassageTileState createState() => _ChatMassageTileState();
}

class _ChatMassageTileState extends State<ChatMassageTile> {
  // GlobalKey globalKey = GlobalKey();
  // Future<void> _save() async {
  //   RenderRepaintBoundary boundary =
  //       globalKey.currentContext.findRenderObject();
  //   ui.Image image = await boundary.toImage();
  //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List pngBytes = byteData.buffer.asUint8List();

  //   //Request permissions if not already granted
  //   if (!(await Permission.storage.status.isGranted))
  //     await Permission.storage.request();

  //   final result = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(pngBytes),
  //       quality: 60,
  //       name: "canvas_image");
  //   print(result);
  // }
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final user = Provider.of<User>(context);
    final isMe = widget.message.idUser == user.uid;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
              radius: 16, backgroundImage: NetworkImage(widget.message.image)),
        Container(
          margin: EdgeInsets.all(16),
          padding: widget.message.messageType == 'image'
              ? EdgeInsets.all(7)
              : EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.cyan[800],
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: widget.message.messageType == 'image'
              ? buildImage(isMe)
              : buildMessage(isMe),
          //  buildMessage(isMe),
        ),
      ],
    );
  }

  Widget buildMessage(bool isMe) => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.message.message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );

  Widget buildImage(bool isMe) => GestureDetector(
      child: Image(
        image: NetworkImage(widget.message.message),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                OpenPhoto(path: widget.message.message),
          ))

      // OpenPhoto(path: widget.message.message),
      );
}
