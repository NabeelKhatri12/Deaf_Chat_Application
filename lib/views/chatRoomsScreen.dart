import 'package:deafchatapp/helper/constants.dart';
import 'package:deafchatapp/helper/helperfunctions.dart';
import 'package:deafchatapp/services/auth.dart';
import 'package:deafchatapp/services/database.dart';
import 'package:deafchatapp/views/conversation_screen.dart';
import 'package:deafchatapp/views/search.dart';
import 'package:deafchatapp/widgets/widget.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
             return ChatRoomTile(
               snapshot.data.documents[index].data["chatroomId"]
                   .toString().replaceAll("_", "")
                   .replaceAll(Constants.myName, ""),
                 snapshot.data.documents[index].data["chatroomId"]
             );
            }) : Container();
      },
    );
  }

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarMain(context),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.search ,
          color : Colors.white,
        ),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
          },
      ),
    );
  }
  }

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
          color: Colors.white70,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child:Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Text("${userName.substring(0,1).toUpperCase()}",
                  style: mediummTextStyle(),
                ),
              ),
              SizedBox(width: 8,),
              Text(userName, style: mediumTextStyle(),)
            ],
          )
      ),
    );
  }
}
