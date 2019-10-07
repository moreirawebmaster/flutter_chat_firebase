import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/login_service.dart';

import 'login_page.dart';

void main() => runApp(BlocProvider(
      blocs: [
        Bloc((_) => LoginService()),
        Bloc((_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    ));
