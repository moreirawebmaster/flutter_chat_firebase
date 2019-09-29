import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat Firebase'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.grey[700],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(children: <Widget>[
                Container( color: Colors.white, height: 50,),
                SizedBox(height: 20,),
                Container( color: Colors.white, height: 50,),
                SizedBox(height: 20,),
                Container( color: Colors.white, height: 50,),
                SizedBox(height: 20,),
              ],),
              reverse: true,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              height: 60,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        child: Icon(Icons.camera_alt),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
