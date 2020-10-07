import 'package:deafchatapp/bloc/auth/auth_cubit.dart';
import 'package:deafchatapp/views/chatRoomsScreen.dart';
import 'package:deafchatapp/views/signin.dart';
import 'package:deafchatapp/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helper/helperfunctions.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool userIsLoggedIn = false;
  @override
  void initState(){
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit()..appStarted(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: userIsLoggedIn ? ChatRoom() : SignIn(),
        routes: {
          "/" : (context){
            return BlocBuilder<AuthCubit,AuthState>(
              builder: (context,authState){
                if (authState is Authenticated){
                  return ChatRoom();
                }
                if (authState is UnAuthenticated){
                  return SignIn();
                }
                return Container();
              },
            );
          }
        },
      )
    );
  }
}

