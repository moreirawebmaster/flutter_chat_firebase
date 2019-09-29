import 'package:flutter/material.dart';
import 'package:flutter_chat/login_page.dart';
import 'package:flutter_chat/services/login_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [ChangeNotifierProvider(builder: (context) => LoginService())],
        child: LoginPage(),
      ),
    ));
