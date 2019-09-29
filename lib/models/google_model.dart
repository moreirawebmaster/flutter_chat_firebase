import 'package:google_sign_in/google_sign_in.dart';

class GoogleModel {
  String photoUrl;
  String email;
  String id;
  String displayName;

  GoogleModel.fromGoogleSignin(GoogleSignInAccount account) {
    if(account == null)
      return;
    this.photoUrl = account.photoUrl;
    this.displayName = account.displayName;
    this.email = account.email;
    this.id = account.id;
  }
  GoogleModel.fromFirebaseStore(Map<dynamic, dynamic> data){
    this.photoUrl = data['photoUrl'];
    this.displayName = data['displayName'];
    this.email = data['email'];
    this.id = data['id'];
  }
}
