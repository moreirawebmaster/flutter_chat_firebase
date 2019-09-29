import 'package:flutter_chat/models/google_model.dart';

class ChatModel {
  final String message;
  final String imageUrl;
  final GoogleModel user;
  ChatModel({this.message, this.imageUrl, this.user});
}
