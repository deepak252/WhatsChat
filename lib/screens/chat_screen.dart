import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth = FirebaseAuth.instance;  
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) print(message.data());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEDEEF3),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(
          'My Chat',  //⚡
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff2E253E),
            fontWeight: FontWeight.bold,
          ),
        ),
        
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
            
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      
                      if(messageText=='')
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Message Can't be empty",
                            textAlign:TextAlign.center,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 80,left: 40,right: 40),
                          duration: Duration(seconds: 2),
                          // padding: EdgeInsets.symmetric(horizontal: 0,vertical: ),
                          
                        ));
                      }
                      else
                      {
                        _firestore.collection('messages').add({
                          'sender': loggedInUser.email,
                          'text': messageText,
                          'time':FieldValue.serverTimestamp(),
                        });
                      }                      
                      
                      // print(FieldValue.serverTimestamp());
                      messageTextController.clear();
                      messageText='';
                    },
                    child: Icon(
                      Icons.send,
                      size: 30.0,
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time',descending:false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final messageTime = message['time'];          
          final currentUser=loggedInUser.email;
          

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser==messageSender,
            time: messageTime,
          ); 
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse:  true,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final Timestamp time;
  
  MessageBubble({this.sender,this.text,this.isMe,Timestamp time}):time = time ?? Timestamp.now();
  
  String getTime()
  {
    String timeInMilliSec= DateTime.fromMillisecondsSinceEpoch(time.seconds*1000).toString().split(' ')[1];
    List<String> splitTime= timeInMilliSec.split(':');
    return '${splitTime[0]}:${splitTime[1]}';
  }

  Widget senderNameLabel()
  {
    if(!isMe )
    {
      return Text(
              '${sender.split('@')[0]}',
              style: TextStyle(color: Colors.black54,),
            );
    }      
    else
    {
      // print(previousMessageSender);
      return SizedBox();
    } 
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      // constraints: BoxConstraints(minWidth: 10, maxWidth: 20),
      padding: EdgeInsets.all(8.0),
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end :  CrossAxisAlignment.start,
        children: <Widget>[
          senderNameLabel(), 
          SizedBox(height: 3,),
          Container(
            constraints: BoxConstraints(minWidth: 10, maxWidth: 370),
            child: Material(
              color:isMe ? Color(0xffd89a0e) : Colors.white,   //f7d283
              elevation: 5.0,
              borderRadius: isMe ? BorderRadius.only( 
                topLeft: Radius.circular(15),
                bottomLeft:  Radius.circular(15),
                bottomRight:  Radius.circular(15)
                ) :  BorderRadius.only( 
                topRight: Radius.circular(15),
                bottomLeft:  Radius.circular(15),
                bottomRight:  Radius.circular(15)
              ),
              
              child:Stack(
                children:<Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20,top: 15,bottom: 20,right: 20),
                    child: Text(
                      '$text',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: isMe? Colors.white : Color(0xff2A2A2A),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,height: 10,),
                  Positioned(
                  bottom: 5.0,
                  right: 5.0,
                  child: Text(
                    getTime(),
                    style: TextStyle(
                      color: isMe ? Colors.white60: Colors.black54,
                      fontSize: 12.0,
                    )
                  ),
                )
                  
                  
                ]
              ),
            ),
          ),
        ]
      ),
    );
  }
}
