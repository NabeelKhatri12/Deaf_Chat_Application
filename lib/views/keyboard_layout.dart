
import 'package:deafchatapp/keyboard/deaf_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class KeyboardTest extends StatefulWidget {
  @override
  _KeyboardTestState createState() => _KeyboardTestState();
}

class _KeyboardTestState extends State<KeyboardTest> {

  //permission Service
//  PermissionServices _permissionServices = PermissionServices();

  TextEditingController _messageController;
  ScrollController _scrollController = ScrollController();
  bool _changeKeyboardType = false;
  int _menuIndex = 0;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }
  Scaffold _buildScaffold() {
    return Scaffold(
      body: WillPopScope(
        onWillPop:null,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  _changeKeyboardType
                      ? DeafKeyBoardEditor(
                    uid: "",
                    receiverName: "",
                    senderName:"",
                    name: "",
                    otherUID: "",
                    channelId:"",
                    messageType: _menuIndex,
                  )
                      : buildNormalKeyboard()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildNormalKeyboard() {
    return Container(
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
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 150,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TextField(
                    controller: _messageController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "type feel free.. :) <3"),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.send,
              color: _messageController.text.isEmpty
                  ? Colors.green[200]
                  : Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

}