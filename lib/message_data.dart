import 'package:flutter/material.dart';

class MessageData {
  final DateTime timestamp;
  final String text;
  final String senderLogin;
  final String receiverLogin;

  MessageData(
      {@required this.timestamp,
      @required this.text,
      @required this.senderLogin,
      @required this.receiverLogin})
      : assert(text.isNotEmpty),
        assert(senderLogin.isNotEmpty),
        assert(receiverLogin.isNotEmpty);
}
