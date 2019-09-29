import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class ChatService with ChangeNotifier {
  FirebaseStorage _storage;
  Firestore _store;

  ChatService() {
    _storage = FirebaseStorage.instance;
    _store = Firestore.instance;
  }

  void addMessage(String message, String userId){
    _store.collection('chat').document('messages').setData({
      'message': message,
      'userId' : userId
    });
  }

  void addImage(){
    
  }
}
