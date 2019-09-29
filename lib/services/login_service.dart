import 'package:flutter/widgets.dart';
import 'package:flutter_chat/models/google_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService with ChangeNotifier {
  GoogleSignIn _googleSignIn;
  FirebaseAuth _firebaseAuth;
  GoogleModel _user;
  GoogleModel get currentUser => _user;
  bool get isLogged => _user?.id != null;

  LoginService() {
    _googleSignIn = GoogleSignIn();
    _firebaseAuth = FirebaseAuth.instance;
    initalizeUser().then((value) {
      _user = value;
      notifyListeners();
    });
  }

  Future<GoogleModel> initalizeUser() async {
    var account = await _googleSignIn.signInSilently(suppressErrors: true);
    await doSignInFireStore(account);
    return GoogleModel.fromGoogleSignin(account);
  }

  Future doSignIn() async {
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.signIn();
      await doSignInFireStore(account);
    } catch (error) {
      print(error);
    }
    _user = GoogleModel.fromGoogleSignin(account);
    notifyListeners();
  }

  Future doSignInFireStore(GoogleSignInAccount account) async {
    if(account == null)
      return;
    var accountLogin = await account?.authentication;
    var credential =
        GoogleAuthProvider.getCredential(accessToken: accountLogin.accessToken, idToken: accountLogin.idToken);
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future doLogoff() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }
}
