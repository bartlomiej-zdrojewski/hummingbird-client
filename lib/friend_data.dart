import 'package:flutter/material.dart';

class FriendData {
  final String name;
  final String surname;
  final String login;

  FriendData(
      {@required this.name, @required this.surname, @required this.login})
      : assert(name.isNotEmpty),
        assert(surname.isNotEmpty),
        assert(login.isNotEmpty);
}
