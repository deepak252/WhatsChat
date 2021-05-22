import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:myapp/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  
  AnimationController controller;
  Animation animation;
  Animation animation2;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(
      vsync:  this,
      duration: Duration(seconds: 1),
      // upperBound: 100.0,
    );
    animation=CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn
    );
    // controller.reverse(from: 100.0);
    controller.forward();
    controller.addListener((){
        setState(() {});
      }
    );
    // controller.addStatusListener((status){
    //   print(status);
    //   if(status==AnimationStatus.completed)
    //     controller.reverse(from: 100.0);
    //   else if(status==AnimationStatus.dismissed)
    //     controller.forward();
    // });

    ////////////////////////////
    animation2=ColorTween(
      begin:Colors.blueGrey,
      end: Colors.white 
    ).animate(controller);
    @override
    void dispose(){
      controller.dispose();
      super.dispose();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(controller.value),
      // backgroundColor: Colors.white,
      backgroundColor: animation2.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                    // height: controller.value,
                    // height: controller.value*100,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      'My Chat',
                      textStyle: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w900,
                      )
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              btnColor: Colors.lightBlueAccent,
              btnText: 'Log In',
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            SizedBox(height: 12,),
            Text(
              'Not registered yet?',
              textAlign: TextAlign.center,
            ),
            RoundedButton(
              btnColor: Colors.blueAccent,
              btnText: 'Register',
              onPressed: (){
                Navigator.pushNamed(context,RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}


