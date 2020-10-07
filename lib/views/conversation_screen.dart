import 'dart:async';

import 'package:deafchatapp/helper/constants.dart';
import 'package:deafchatapp/keyboard/deaf_keyboard.dart';
import 'package:deafchatapp/services/database.dart';
import 'package:deafchatapp/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _changeKeyboardType = false;
  int _menuIndex = 0;
  Stream chatMessagesStream;

  Widget ChatMessageList() {
    Timer(
        Duration(milliseconds: 100),
            () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 500)));
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          controller: _scrollController,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.documents[index].data["message"],
                      snapshot.data.documents[index].data["sendBy"] ==
                          Constants.myName);
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarMain(context),
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          Switch(
            onChanged: (value) {
              setState(() {
                _changeKeyboardType = value;
              });
            },
            value: _changeKeyboardType,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: ChatMessageList()),
            _changeKeyboardType
                ? DeafKeyBoardEditor(
                    uid: "",
                    receiverName: "",
                    senderName: "",
                    name: "",
                    otherUID: "",
                    chatRoomId: widget.chatRoomId,
                    onScrollDown: (){
                      Timer(
                          Duration(milliseconds: 100),
                              () => _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              curve: Curves.decelerate,
                              duration: Duration(milliseconds: 500)));
                    },
                    channelId: "",
                    messageType: _menuIndex,
                  )
                : Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Color(0x54ffffff),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: messageController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintText: "Message",
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none),
                          )),
                          GestureDetector(
                              onTap: () {
                                sendMessage();
                                Timer(
                                    Duration(milliseconds: 100),
                                        () => _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        curve: Curves.decelerate,
                                        duration: Duration(milliseconds: 500)));
                              },
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        const Color(0x36FFFFFF),
                                        const Color(0x0FFFFFFF),
                                      ]),
                                      borderRadius: BorderRadius.circular(40)),
                                  padding: EdgeInsets.all(12),
                                  child: Image.asset(
                                    "assets/images/send.png",
                                    fit: BoxFit.cover,
                                  )))
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(
            left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isSendByMe
                      ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                      : [const Color(0xff007EF4), const Color(0xff2A75BC)]),
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23))),
          child: ListView.builder(
            itemCount: message.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx,index){

              return message[index]==" "?Text(" "):Image.asset(signToText(text: message[index]));
            },
          ),
        ),
      ),
    );
  }
//Text(
//           message,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 17,
//           ),
//         )
  String signToText({String text}) {
    switch (text) {
      case 'a':
        return "assets/data/a.jpg";
      case 'b':
        return "assets/data/b.jpg";
      case 'c':
        return "assets/data/c.jpg";
      case 'd':
        return "assets/data/d.jpg";
      case 'e':
        return "assets/data/e.jpg";
      case 'f':
        return "assets/data/f.jpg";
      case 'g':
        return "assets/data/g.jpg";
      case 'h':
        return "assets/data/h.jpg";
      case 'i':
        return "assets/data/i.jpg";
      case 'j':
        return "assets/data/j.jpg";
      case 'k':
        return "assets/data/k.jpg";
      case 'l':
        return "assets/data/l.jpg";
      case 'm':
        return "assets/data/m.jpg";
      case 'n':
        return "assets/data/n.jpg";
      case 'o':
        return "assets/data/o.jpg";
      case 'p':
        return "assets/data/p.jpg";
      case 'q':
        return "assets/data/q.jpg";
      case 'r':
        return "assets/data/r.jpg";
      case 's':
        return "assets/data/s.jpg";
      case 't':
        return "assets/data/t.jpg";
      case 'u':
        return "assets/data/u.jpg";
      case 'v':
        return "assets/data/v.jpg";
      case 'w':
        return "assets/data/w.jpg";
      case 'x':
        return "assets/data/x.jpg";
      case 'y':
        return "assets/data/y.jpg";
      case 'z':
        return "assets/data/z.jpg";
      case 'A':
        return "assets/data/a.jpg";
      case 'B':
        return "assets/data/b.jpg";
      case 'C':
        return "assets/data/c.jpg";
      case 'D':
        return "assets/data/d.jpg";
      case 'E':
        return "assets/data/e.jpg";
      case 'F':
        return "assets/data/f.jpg";
      case 'G':
        return "assets/data/g.jpg";
      case 'H':
        return "assets/data/h.jpg";
      case 'I':
        return "assets/data/i.jpg";
      case 'J':
        return "assets/data/j.jpg";
      case 'K':
        return "assets/data/k.jpg";
      case 'L':
        return "assets/data/l.jpg";
      case 'M':
        return "assets/data/m.jpg";
      case 'N':
        return "assets/data/n.jpg";
      case 'O':
        return "assets/data/o.jpg";
      case 'P':
        return "assets/data/p.jpg";
      case 'Q':
        return "assets/data/q.jpg";
      case 'R':
        return "assets/data/r.jpg";
      case 'S':
        return "assets/data/s.jpg";
      case 'T':
        return "assets/data/t.jpg";
      case 'U':
        return "assets/data/u.jpg";
      case 'V':
        return "assets/data/v.jpg";
      case 'W':
        return "assets/data/w.jpg";
      case 'X':
        return "assets/data/x.jpg";
      case 'Y':
        return "assets/data/y.jpg";
      case 'Z':
        return "assets/data/z.jpg";
      case '1':
        return "assets/data/1.jpg";
      case '2':
        return "assets/data/2.jpg";
      case '3':
        return "assets/data/3.jpg";
      case '4':
        return "assets/data/4.jpg";
      case '5':
        return "assets/data/5.jpg";
      case '6':
        return "assets/data/6.jpg";
      case '7':
        return "assets/data/7.jpg";
      case '8':
        return "assets/data/8.jpg";
      case '9':
        return "assets/data/9.jpg";
      case '0':
        return "assets/data/0.jpg";
      default:
        return ",";
    }
  }
}
