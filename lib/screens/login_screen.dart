import 'package:flutter/material.dart';
import 'package:myapp/components/rounded_button.dart';
import 'package:myapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const id='Login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner=false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall:showSpinner ,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email=value;
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,              
                decoration:  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password=value;
                },
                obscureText: true,
                textAlign: TextAlign.center,
                decoration:  kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                btnText: 'Login',
                btnColor: Colors.lightBlueAccent,
                onPressed: () async{
                  setState(() {
                    showSpinner=true;
                  });
                  try{
                    final user= await _auth.signInWithEmailAndPassword(email: email,password: password);
                    if(user!=null)
                      Navigator.pushNamed(context, ChatScreen.id);
                    setState(() {
                      showSpinner=false;
                    });
                  }catch(e){
                    print(e);
                    setState(() {
                      showSpinner=false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
