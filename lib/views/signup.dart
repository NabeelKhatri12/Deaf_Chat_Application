import 'package:deafchatapp/helper/helperfunctions.dart';
import 'package:deafchatapp/services/auth.dart';
import 'package:deafchatapp/services/database.dart';
import 'package:deafchatapp/views/chatRoomsScreen.dart';
import 'package:deafchatapp/views/signin.dart';
import 'package:deafchatapp/widgets/password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool _obscureText = true;
  createEntry(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
        print("$val");
        Map<String,String> userInfoMap = {
          "name" :userNameTextEditingController.text,
          "email":emailTextEditingController.text
        };
        HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(
          ),
        ),
      )
          : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-0,
          alignment: Alignment.bottomCenter,
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
                        child: Text("Hey, get on board", style: TextStyle(fontFamily: 'Code128', fontSize: 20.0))
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                        width: double.infinity,
                        child: Text("Sign Up", style: TextStyle(fontFamily: 'Arial', fontSize: 35.0,fontWeight: FontWeight.bold))
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children:[
                          TextFormField(
                            validator: (val){
                              if(val.isEmpty){return "Please enter name";}
                              if(val.length <=2){return "Please enter valid name";}
                              else{return null;}
                            },
                            controller: userNameTextEditingController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                            ),
                          ),
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
                GestureDetector(
                  onTap: (){
                    createEntry();

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
                    child: Text("Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
//                Container(
//                  alignment: Alignment.center,
//                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.symmetric(vertical: 15),
//                  decoration: BoxDecoration(
//                      gradient: LinearGradient(
//                          colors: [
////                        const Color(0xff176BEF),
//                            const Color(0xffce0000),
//                            const Color(0xffce0000),
////                        const Color(0xff179C52)
//                          ]
//                      ),
//                      borderRadius: BorderRadius.circular(30)
//                  ),
//                  child: Text("Login with Google",
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 17,
//                    ),
//                  ),
//                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have account? ",style: TextStyle(fontSize: 12,color: Colors.black)),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => SignIn()
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2,),
                        child: Text("Login Now",
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
                SizedBox(height: 150,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
