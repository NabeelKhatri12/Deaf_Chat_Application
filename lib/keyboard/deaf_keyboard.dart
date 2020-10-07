import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafchatapp/helper/constants.dart';
import 'package:deafchatapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_keyboard.dart';

typedef scrollDownVoidCallBack = Function();

class DeafKeyBoardEditor extends StatefulWidget {
  final String name;
  final String uid;
  final scrollDownVoidCallBack onScrollDown;
  final String otherUID;
  final String senderName;
  final String receiverName;
  final String chatRoomId;
  final String channelId;
  final int messageType;

  DeafKeyBoardEditor(
      {Key key,
      this.onScrollDown,
      this.name,
      this.uid,
      this.otherUID,
      this.senderName,
      this.chatRoomId,
      this.receiverName,
      this.channelId,
      this.messageType})
      : super(key: key);

  @override
  _DeafKeyBoardEditorState createState() => _DeafKeyBoardEditorState();
}

class _DeafKeyBoardEditorState extends State<DeafKeyBoardEditor> {
  String _singleTextPicker = "";
  List<String> _signToText = [];
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final filterList =
        _suggested.where((word) => word.startsWith(_singleTextPicker)).toList();
    Timer(
        Duration(milliseconds: 100),
        () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 500)));
    return Column(
      children: <Widget>[
        // Container(
        //   height: 30,
        //   width: double.infinity,
        //   child: widget.messageType == 0
        //       ? ListView.builder(
        //           scrollDirection: Axis.horizontal,
        //           itemCount: filterList.length,
        //           itemBuilder: (context, index) {
        //             return GestureDetector(
        //               onTap: () {
        //                 if (mounted)
        //                   setState(() {
        //                     _singleTextPicker = filterList[index];
        //                   });
        //               },
        //               child: Card(
        //                 color: Colors.grey[300],
        //                 child: Padding(
        //                   padding: const EdgeInsets.symmetric(horizontal: 4),
        //                   child: Text(
        //                     filterList[index],
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //             );
        //           })
        //       : Text(''),
        // ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.4),
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: deafKeyboard(),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          color: Colors.white,
          child: CustomKeyboard(
            onSend: () {
              Fluttertoast.showToast(msg: "working");
            },
            onSpace: () {
              setState(() {
                _singleTextPicker += " ";
                _signToText.add('-');
              });
            },
            onLongPressed: () {
              setState(() {
                _signToText.clear();
                _singleTextPicker = "";
              });
            },
            onBackPress: () {
              if (mounted)
                setState(() {
                  _signToText.removeAt(_signToText.length - 1);
                });
            },
            onSave: (text) {
              if (mounted)
                setState(() {
                  if (widget.messageType == 1) {
                    _singleTextPicker += text;
                    final image = signToText(text: text);
                    _signToText.add(image);
                    print(_singleTextPicker);
                  } else if (widget.messageType == 2) {
                    _singleTextPicker += text;
                    final image = signToText(text: text);
                    _signToText.add(image);
                    print(_singleTextPicker);
                  } else {
                    _singleTextPicker += text;
                    // _singleTextPicker += text;
                    final image = signToText(text: text);
                    _signToText.add(image);
                    print(_signToText.length);
                  }
                });
            },
          ),
        ),
      ],
    );
  }

  Widget deafKeyboard() => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.5, 0.2),
                color: Colors.black54,
                blurRadius: .2,
              )
            ],
            color: Colors.grey[100]),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.image,
                color: Colors.grey,
              ),
            ),

            //TODO:add layout message
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 150),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: 50,
                      child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _signToText.length,
                          itemBuilder: (context, index) {
                            if (_signToText[index] == "-")
                              return Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  ",",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            else
                              return Image.asset(_signToText[index]);
                          }),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _signToText.isEmpty
                  ? null
                  : () async {
                      //TODO: send message
                      sendMessage();
                      print(_singleTextPicker);
                      widget.onScrollDown();
                      print("send");
                      if (mounted)
                        setState(() {
                          _singleTextPicker = "";
                          _signToText.clear();
                        });
                    },
              icon: Icon(
                Icons.send,
                color:
                    _signToText.isEmpty ? Colors.green[200] : Colors.green[700],
              ),
            ),
          ],
        ),
      );

  // String _recognizerText(String text) {
  //   if (_singleTextPicker.contains("hello") ||
  //       _singleTextPicker.contains("Hello") ||
  //       _singleTextPicker.contains("hi") ||
  //       _singleTextPicker.contains("Hi"))
  //     return "assets/data/hello.gif";
  //   else if (_singleTextPicker.contains("sorry") ||
  //       _singleTextPicker.contains("Sorry"))
  //     return "assets/data/sorry.gif";
  //   else if (_singleTextPicker.contains("well done") ||
  //       _singleTextPicker.contains("Well done"))
  //     return "assets/data/welldone.gif";
  //   else if (_singleTextPicker.contains("what'sup") ||
  //       _singleTextPicker.contains("What'sup"))
  //     return "assets/data/whatup.gif";
  //   else if (_singleTextPicker.contains("thank you") ||
  //       _singleTextPicker.contains("Thank you"))
  //     return "assets/data/thanku.gif";
  //   else if (_singleTextPicker.contains("where are you from?") ||
  //       _singleTextPicker.contains("Where are you from?"))
  //     return "assets/data/wrufrom.gif";
  //   else if (_singleTextPicker.contains("run") ||
  //       _singleTextPicker.contains("Run"))
  //     return "assets/data/run.gif";
  //   else if (_singleTextPicker.contains("are you ok?") ||
  //       _singleTextPicker.contains("Are you ok?"))
  //     return "assets/data/ruok.gif";
  //   else if (_singleTextPicker.contains("i don't no") ||
  //       _singleTextPicker.contains("I don't no"))
  //     return "assets/data/idk.gif";
  //   else if (_singleTextPicker.contains("cool") ||
  //       _singleTextPicker.contains("Cool"))
  //     return "assets/data/cool.gif";
  //   else if (_singleTextPicker.contains("Air plane") ||
  //       _singleTextPicker.contains("air plane") ||
  //       _singleTextPicker.contains("plane"))
  //     return "assets/data/airplane.gif";
  //   else if (_singleTextPicker.contains("alive") ||
  //       _singleTextPicker.contains("Alive") ||
  //       _singleTextPicker.contains("live"))
  //     return "assets/data/alive.gif";
  //   else if (_singleTextPicker.contains("angel") ||
  //       _singleTextPicker.contains("Angel"))
  //     return "assets/data/angel.gif";
  //   else if (_singleTextPicker.contains("ballon") ||
  //       _singleTextPicker.contains("Ballon"))
  //     return "assets/data/ballon.gif";
  //   else if (_singleTextPicker.contains("Board") ||
  //       _singleTextPicker.contains("board"))
  //     return "assets/data/board.gif";
  //   else if (_singleTextPicker.contains("cat") ||
  //       _singleTextPicker.contains("Cat"))
  //     return "assets/data/cat.gif";
  //   else if (_singleTextPicker.contains("cow") ||
  //       _singleTextPicker.contains("Cow"))
  //     return "assets/data/cow.gif";
  //   else if (_singleTextPicker.contains("dead") ||
  //       _singleTextPicker.contains("dead"))
  //     return "assets/data/dead.gif";
  //   else if (_singleTextPicker.contains("Fishion") ||
  //       _singleTextPicker.contains("fishion"))
  //     return "assets/data/fishion.gif";
  //   else if (_singleTextPicker.contains("fire") ||
  //       _singleTextPicker.contains("Fire"))
  //     return "assets/data/fire.gif";
  //   else if (_singleTextPicker.contains("flirt") ||
  //       _singleTextPicker.contains("Flirt"))
  //     return "assets/data/flirt.gif";
  //   else if (_singleTextPicker.contains("hilicoptor") ||
  //       _singleTextPicker.contains("Hilicoptor"))
  //     return "assets/data/hilicoptor.gif";
  //   else if (_singleTextPicker.contains("Isolated") ||
  //       _singleTextPicker.contains("isolated"))
  //     return "assets/data/isolated.gif";
  //   else if (_singleTextPicker.contains("it") ||
  //       _singleTextPicker.contains("It"))
  //     return "assets/data/it.gif";
  //   else if (_singleTextPicker.contains("kiss") ||
  //       _singleTextPicker.contains("Kiss"))
  //     return "assets/data/kiss.gif";
  //   else if (_singleTextPicker.contains("model") ||
  //       _singleTextPicker.contains("Model"))
  //     return "assets/data/model.gif";
  //   else if (_singleTextPicker.contains("money") ||
  //       _singleTextPicker.contains("Money"))
  //     return "assets/data/money.gif";
  //   else if (_singleTextPicker.contains("morning") ||
  //       _singleTextPicker.contains("Morning"))
  //     return "assets/data/morning.gif";
  //   else if (_singleTextPicker.contains("motivation") ||
  //       _singleTextPicker.contains("Motivation"))
  //     return "assets/data/motivation.gif";
  //   else if (_singleTextPicker.contains("no") ||
  //       _singleTextPicker.contains("No"))
  //     return "assets/data/no.gif";
  //   else if (_singleTextPicker.contains("nougty") ||
  //       _singleTextPicker.contains("Nougty"))
  //     return "assets/data/nougty.gif";
  //   else if (_singleTextPicker.contains("piaon") ||
  //       _singleTextPicker.contains("Piaon"))
  //     return "assets/data/piaon.gif";
  //   else if (_singleTextPicker.contains("rain") ||
  //       _singleTextPicker.contains("Rain"))
  //     return "assets/data/rain.gif";
  //   else if (_singleTextPicker.contains("Seriously") ||
  //       _singleTextPicker.contains("seriously"))
  //     return "assets/data/seriously.gif";
  //   else if (_singleTextPicker.contains("shark") ||
  //       _singleTextPicker.contains("Shark"))
  //     return "assets/data/shark.gif";
  //   else if (_singleTextPicker.contains("sochked") ||
  //       _singleTextPicker.contains("Sochked"))
  //     return "assets/data/sochked.gif";
  //   else if (_singleTextPicker.contains("thunder") ||
  //       _singleTextPicker.contains("Thunder"))
  //     return "assets/data/thunder.gif";
  //   else if (_singleTextPicker.contains("war") ||
  //       _singleTextPicker.contains("War"))
  //     return "assets/data/war.gif";
  //   else if (_singleTextPicker.contains("Water") ||
  //       _singleTextPicker.contains("water"))
  //     return "assets/data/water.gif";
  //   else if (_singleTextPicker.contains("weeked") ||
  //       _singleTextPicker.contains("Weeked"))
  //     return "assets/data/weeked.gif";
  //   else
  //     Fluttertoast.showToast(
  //         msg: "Not Recognized",
  //         gravity: ToastGravity.CENTER,
  //         toastLength: Toast.LENGTH_LONG);
  //
  //   if (mounted)
  //     setState(() {
  //       _singleTextPicker = "";
  //     });
  //   return "";
  // }

  List<String> _suggested = [
    "thank you",
    'run',
    "i don't no",
    "well done",
    "where are you from?",
    "sorry",
    "hello",
    "hi",
    "how are you?",
    "what are you doing",
    "are you ok?",
    "where are you going?",
    "i'm fine",
    "ok",
    "what'sup",
    "air plane",
    "alive",
    "angel",
    "ballon",
    "board",
    "cat",
    "cool",
    "cow",
    "dead",
    "fashion",
    "fire",
    "flirt",
    "hilicoptor",
    "isolated",
    "it",
    "model",
    "nougty",
    "paion",
    "rain",
    "seriously",
    "shocked",
    "shark",
    "strong wind",
    "thunder",
    "war",
    "water",
    "weeked",
    "well done",
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

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
        return " ";
    }
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();

  sendMessage() {
    if (_singleTextPicker.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _singleTextPicker,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      setState(() {
        databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
        _singleTextPicker = "";
      });
    }
  }
}
