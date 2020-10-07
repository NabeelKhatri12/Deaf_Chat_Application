import 'package:deafchatapp/services/auth.dart';
import 'package:deafchatapp/services/database.dart';
import 'package:deafchatapp/views/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget appBarMain(BuildContext context){
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  return AppBar(
   title: Padding(
     padding: const EdgeInsets.all(20),
     child: Text("Chats",style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold,),),
   ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        onPressed: () {
          // do something
          authMethods.signOut();
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SignIn()
          ));
        },
      )
    ],
    backgroundColor: Color(0xff007EF4),
    elevation: 0.0,
  );
}
Widget searchBarMain(BuildContext context){
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    title: TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.black),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: ()
              { //TODO
            },
            child: Icon(
             Icons.search,
              color: Colors.white,
            ),
          )
      ),
    ),
    elevation: 0.0,
  );
}
TextStyle simpleTextFeildStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
    color: Colors.black,
    fontSize: 18,
  );
}

TextStyle mediummTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
}

TextStyle singleTextFeildStyle(){
  return TextStyle(
    color: Colors.red,
    fontSize: 16,
  );
}

Widget sappBarMain(BuildContext context){
  return AppBar(
    title: Padding(
      padding: const EdgeInsets.all(20),
      child: Text("Search",style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold,),),
    ),
    backgroundColor: Color(0xff007EF4),
    elevation: 0.0,
  );
}