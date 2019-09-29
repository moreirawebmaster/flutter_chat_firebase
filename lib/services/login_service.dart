import 'package:flutter/widgets.dart';
import 'package:flutter_chat/models/google_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService with ChangeNotifier {
  GoogleSignIn _googleSignIn;
  FirebaseAuth _firebaseAuth;

  LoginService() {
    _googleSignIn = GoogleSignIn();
    _firebaseAuth = FirebaseAuth.instance;
  }

  GoogleModel get currentUser => GoogleModel.fromGoogleSignin(_googleSignIn.currentUser);
  bool get isLogged => currentUser != null;

  Future<GoogleModel> doSignIn() async {
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.signIn();
      if (account == null) return null;

      var accountLogin = await account.authentication;
      var credential =
          GoogleAuthProvider.getCredential(accessToken: accountLogin.accessToken, idToken: accountLogin.idToken);

      if (credential == null) return null;

      await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      print(error);
    }

    return GoogleModel.fromGoogleSignin(account);
  }

  
  Future doLogoff() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
