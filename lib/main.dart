import 'package:flutter/material.dart';
import 'package:flutter_chat/login_page.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/login_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => LoginService()),
        ChangeNotifierProvider(builder: (context) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    ));
