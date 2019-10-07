import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/login_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginService service = BlocProvider.getBloc<LoginService>();

    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue])),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Consumer<LoginService>(
          builder: (context, login) {
            return login.isLogged ? buttonInitializeChat(context) : buttonGoogleSignIn(service, context);
          },
        ),
      ]),
    );
  }

  Widget buttonGoogleSignIn(LoginService service, BuildContext context) {
    return SizedBox(
      height: 50,
      child: RaisedButton.icon(
        color: Colors.blue,
        icon: Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
        label: Text(
          'Login com google',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () async{
          await service.doSignIn();
          if (service.isLogged) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatPage()));
          }
        },
      ),
    );
  }

  Widget buttonInitializeChat(BuildContext context) {
    return SizedBox(
      height: 50,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          'Iniciar Chat',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatPage()));
        },
      ),
    );
  }
}
