import 'package:flutter/material.dart';
import 'package:hummingbird/account_data.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool registering = false;
  String name = "";
  String surname = "";
  String login = "";
  String password = "";
  String passwordRepeat = "";
  final _loginTextController = TextEditingController();

  bool _validate() {
    return !registering &&
        name.isNotEmpty &&
        surname.isNotEmpty &&
        login.isNotEmpty &&
        password.isNotEmpty &&
        password == passwordRepeat;
  }

  void _register(BuildContext context) async {
    if (password.length < 8) {
      _onError(context, 'Password too short',
          'The password must consist of at least 8 characters.', 'OK');
      return;
    }

    setState(() {
      registering = true;
    });

    // TODO register request
    Future.delayed(Duration(seconds: 10)).then((_) {
      registering = false;
      final sessionId = "abc";
      // TODO save preferences
      Navigator.pop(context, AccountData(login: login, sessionId: sessionId));
    });
  }

  Future<void> _onError(BuildContext context, String title, String content,
      String confirmation) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(content)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(confirmation),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Hummingbird'), centerTitle: true),
        body: GestureDetector(onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }, child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // TODO logo
                            TextField(
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    labelText: "Name",
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)))),
                                onChanged: (value) {
                                  setState(() {
                                    if (login.isEmpty ||
                                        login ==
                                            name.toLowerCase() +
                                                '-' +
                                                surname.toLowerCase()) {
                                      if (value.isNotEmpty &&
                                          surname.isNotEmpty) {
                                        setState(() {
                                          login = value.toLowerCase() +
                                              '-' +
                                              surname.toLowerCase();
                                          _loginTextController.text = login;
                                        });
                                      }
                                    }
                                    name = value;
                                  });
                                }),
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: TextField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        labelText: "Surname",
                                        prefixIcon: Icon(Icons.person),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                    onChanged: (value) {
                                      setState(() {
                                        if (login.isEmpty ||
                                            login ==
                                                name.toLowerCase() +
                                                    '-' +
                                                    surname.toLowerCase()) {
                                          if (name.isNotEmpty &&
                                              value.isNotEmpty) {
                                            setState(() {
                                              login = name.toLowerCase() +
                                                  '-' +
                                                  value.toLowerCase();
                                              _loginTextController.text = login;
                                            });
                                          }
                                        }
                                        surname = value;
                                      });
                                    })),
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: TextField(
                                    controller: _loginTextController,
                                    decoration: InputDecoration(
                                        labelText: "Login",
                                        prefixIcon: Icon(Icons.person),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                    onChanged: (value) {
                                      setState(() {
                                        login = value;
                                      });
                                    })),
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        prefixIcon: Icon(Icons.lock),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    })),
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Repeated password",
                                        prefixIcon: Icon(Icons.lock),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                    onChanged: (value) {
                                      setState(() {
                                        passwordRepeat = value;
                                      });
                                    })),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 16, bottom: registering ? 0 : 16),
                                child: SizedBox(
                                    width: 160,
                                    child: RaisedButton(
                                      color: _validate()
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context).disabledColor,
                                      textColor: Theme.of(context)
                                          .primaryTextTheme
                                          .button
                                          .color,
                                      child: Text('Sign me up!'),
                                      onPressed: () {
                                        if (_validate()) {
                                          _register(context);
                                        }
                                      },
                                    ))),
                            registering
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(top: 8, bottom: 16),
                                    child: SizedBox(
                                        width: 160,
                                        child: LinearProgressIndicator()))
                                : Container()
                          ],
                        ))));
          },
        )));
  }
}
