import 'dart:collection';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/models/chat_model.dart';
import 'package:flutter_chat/models/google_model.dart';

class ChatService extends BlocBase {
  FirebaseStorage _storage;
  Firestore _store;
  String _collectionName = 'messages';
  String text;
  bool isSended;
  bool textWithData = false;
  List<ChatModel> _messages = [];
  UnmodifiableListView<ChatModel> get messages => UnmodifiableListView<ChatModel>(_messages);

  ChatService() {
    _storage = FirebaseStorage.instance;
    _store = Firestore.instance;
    _store.collection(_collectionName).snapshots().listen(listeningMessages);
  }

  void listeningMessages(QuerySnapshot query) {
    if (query.documentChanges.length > 0) {
      _messages.addAll(query.documentChanges.reversed.map((chat) {
        var doc = chat.document;
        return ChatModel(
            user: GoogleModel.fromFirebaseStore(doc.data['user']),
            message: doc.data['message'],
            imageUrl: doc.data['imageUrl']);
      }));

      notifyListeners();
    }
  }

  void textChange(String text) {
    this.text = text;
    textWithData = text != null && text.isNotEmpty;
    isSended = false;
    notifyListeners();
  }

  void addMessage(String message, String imageUrl, GoogleModel user) {
    _store.collection(_collectionName).document().setData({'message': message, 'imageUrl': imageUrl, 'user': {
      'id' : user.id,
      'email' : user.email,
      'photoUrl' : user.photoUrl,
      'displayName' : user.displayName,
    }});
    isSended = true;
  }

  Future addImage(File file, GoogleModel user) async {
    var img = await _storage.ref().child('images/${user.id}/${DateTime.now().millisecondsSinceEpoch}').putFile(file).onComplete;
    var imageUrl = await img.ref.getDownloadURL();
    addMessage(null, imageUrl.toString(), user);
  }
}
