import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/login_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';
import 'models/chat_model.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatService chatService;
  LoginService userService;
  GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();
  TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();
    chatService = ChatService();
    _textFieldController = TextEditingController()
      ..addListener(() {
        chatService.textChange(_textFieldController.text);
      });
  }

  @override
  Widget build(BuildContext context) {
    chatService = Provider.of<ChatService>(context, listen: false);
    userService = Provider.of<LoginService>(context, listen: false);

    print('Chat Rebuild...');
    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat Firebase'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              userService.doLogoff();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Selector<ChatService, UnmodifiableListView<ChatModel>>(
                  selector: (context, chatService) => chatService.messages,
                  builder: (context, list, child) {
                    return Column(
                        children: list.map((chat) {
                      return Align(
                        alignment:
                            chat.user.id == userService.currentUser.id ? Alignment.centerRight : Alignment.centerLeft,
                        child: buildCard(chat),
                      );
                    }).toList());
                  },
                ),
                reverse: true,
              ),
            ),
            buildBottom()
          ],
        ),
      ),
    );
  }

  Card buildCard(ChatModel chat) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width - 50,
        child:
            chat.user.id == userService.currentUser.id ? buildUserContentCard(chat) : buildOtherUserContentCard(chat),
      ),
    );
  }

  Container buildUserContentCard(ChatModel chat) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: Text(
                chat.user.displayName,
                style: TextStyle(color: Colors.grey[350]),
              )),
          SizedBox(height: 15),
          buildImage(chat),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  LayoutBuilder buildOtherUserContentCard(ChatModel chat) {
    return LayoutBuilder(
      builder: (context, contraints) {
        return Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(chat.user.photoUrl),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
            width: contraints.maxWidth / 2 + 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chat.user.displayName,
                  style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                buildImage(chat),
                SizedBox(height: 5),
              ],
            ),
          )
        ]);
      },
    );
  }

  Widget buildImage(ChatModel chat) {
    return chat.message == null
        ? Image.network(
            chat.imageUrl == null || chat.imageUrl.isEmpty
                ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS3eCTuLgpyTxikg49z4DJZkxPlMaGyB14pLXvsdSr8knxdo4FP'
                : chat.imageUrl,
            fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          })
        : Align(
            alignment: Alignment.centerLeft,
            child: Text(
              chat.message,
              softWrap: true,
            ));
  }

  Container buildBottom() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    builder: (BuildContext context) {
                      return Container(
                        height: 120,
                        child: ListView(
                          children: <Widget>[
                            ListTile(
                              title:
                                  Text('Galeria', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                              leading: Icon(Icons.image, color: Colors.black),
                              onTap: () async {
                                var file = await ImagePicker.pickImage(source: ImageSource.gallery);
                                if (file != null) await chatService.addImage(file, userService.currentUser);

                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Câmera', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                              leading: Icon(
                                Icons.photo_camera,
                                color: Colors.black,
                              ),
                              onTap: () async {
                                var file = await ImagePicker.pickImage(source: ImageSource.camera);
                                if (file != null) await chatService.addImage(file, userService.currentUser);

                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    },
                    context: _keyScaffold.currentContext);
              },
              child: CircleAvatar(
                child: Icon(Icons.camera_alt),
              )),
          SizedBox(
            width: 10,
          ),
          buildField(),
          buildSend()
        ],
      ),
    );
  }

  Expanded buildField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          minLines: 1,
          maxLines: 4,
          autofocus: false,
          controller: _textFieldController,
          decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Comece a digitar...'),
        ),
      ),
    );
  }

  Selector<ChatService, bool> buildSend() {
    return Selector<ChatService, bool>(
      selector: (context, chatService) => chatService.textWithData,
      builder: (context, textWithData, child) {
        return textWithData
            ? IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  chatService.addMessage(_textFieldController.text, null, userService.currentUser);
                  _textFieldController.clear();
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
              )
            : Container();
      },
    );
  }
}
