import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafchatapp/helper/constants.dart';
import 'package:deafchatapp/services/database.dart';
import 'package:deafchatapp/views/conversation_screen.dart';
import 'package:deafchatapp/widgets/widget.dart';
import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder:  (context, index){
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  initiateSearch(){
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val){
       setState(() {
         searchSnapshot = val;
       });
    });
  }

  /// create chatroom, send user to conversation screen , push replacement
  createChatroomAndStartConversation({String userName}){
    if(userName != Constants.myName){
      print(Constants.myName);
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatRoomId
          )
      ));
    }
    else{
      print("You cannot send message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle(),),
              Text(userEmail, style: mediumTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
              onTap: (){
                print("hello");
                createChatroomAndStartConversation(
                    userName: userName
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text("Message", style: simpleTextFeildStyle(),),
              )
          )
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sappBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x0FFFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child:Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: "Search username...",
                          hintStyle: TextStyle(
                            color: Colors.black
                          ),
                          border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: (){
                          initiateSearch();
                        },
                        child: Container(
                          height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF),
                            ]
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/searchIocn.png"))

                      )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b){
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}
