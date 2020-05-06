import 'package:flutter/material.dart';

class FriendData {
  final String name;
  final String surname;
  final String login;
  final DateTime lastActive;

  FriendData(
      {@required this.name,
      @required this.surname,
      @required this.login,
      @required this.lastActive})
      : assert(name.isNotEmpty),
        assert(surname.isNotEmpty),
        assert(login.isNotEmpty);
}
