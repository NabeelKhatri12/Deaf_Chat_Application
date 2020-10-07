import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafchatapp/views/keyboard_layout.dart';
import 'package:deafchatapp/views/signup.dart';
import 'package:deafchatapp/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deafchatapp/services/auth.dart';
import 'package:deafchatapp/helper/helperfunctions.dart';
import 'package:deafchatapp/views/chatRoomsScreen.dart';
import 'package:deafchatapp/services/database.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn(){
    //HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
    HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xff007EF4),
                  const Color(0xffFFFFFF),
                  const Color(0xffFFFFFF),
                  const Color(0xffFFFFFF),
                  const Color(0xffFFFFFF),
                ]
            ),
          ),
          height: MediaQuery.of(context).size.height-0,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 60,),
                Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: Text("Welcome Back", style: TextStyle(fontFamily: 'Code128', fontSize: 20.0))
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                        width: double.infinity,
                        child: Text("Login", style: TextStyle(fontFamily: 'Arial', fontSize: 35.0,fontWeight: FontWeight.bold))
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val) ? null : "Enter correct email";
                      },
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      validator:  (val){
                        return val.length < 6 ? "Enter Password 6+ characters" : null;
                      },
                      controller: passwordTextEditingController,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon:  GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText   = ! _obscureText;
                            });
                          },
                          child: Icon(_obscureText ? Icons.visibility: Icons.visibility_off,color: Colors.black45,),
                        ),
                      ),
                    ),
                  ],)
                ),

                SizedBox(height:8 ,),
                Container(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Text("Forgot Password?",style: TextStyle(fontSize: 12),),
                  ),
                ),
                SizedBox(height: 8,),
                InkWell(
                  onTap: (){
                    signIn();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => KeyboardTest()
                    ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
//                        const Color(0xff176BEF),
                            const Color(0xffce0000),
                            const Color(0xffce0000),
//                        const Color(0xff179C52)
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Login with Google",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? ",style: TextStyle(fontSize: 12,color: Colors.black)),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                      child: Container(
                        child: Text("Register Now",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 120,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}