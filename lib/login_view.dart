import 'package:flutter/material.dart';
import 'package:hummingbird/account_data.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool logging = false;
  String login = "";
  String password = "";

  bool _validate() {
    return !logging && login.isNotEmpty && password.isNotEmpty;
  }

  void _login(BuildContext context) async {
    setState(() {
      logging = true;
    });

    // TODO login request
    Future.delayed(Duration(seconds: 5)).then((_) {
      logging = false;
      // TODO save preferences
      Navigator.pushReplacementNamed(context, '/',
          arguments: AccountData(login: login, sessionId: "abc"));
    });
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
                                }),
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
                                padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
                                child: SizedBox(
                                    width: 160,
                                    child: RaisedButton(
                                        color: _validate()
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context).disabledColor,
                                        textColor: Theme.of(context)
                                            .accentTextTheme
                                            .button
                                            .color,
                                        child: Text('Let\'s fly!'),
                                        onPressed: () {
                                          if (_validate()) {
                                            FocusScope.of(context).unfocus();
                                            _login(context);
                                          }
                                        }))),
                            Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 16),
                                child: logging
                                    ? SizedBox(
                                        width: 160,
                                        child: LinearProgressIndicator())
                                    : InkWell(
                                        child: Text('Don\'t have an account?',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor)),
                                        onTap: () async {
                                          final accountData =
                                              await Navigator.pushNamed(
                                                  context, '/register');
                                          if (accountData != null) {
                                            Navigator.pushReplacementNamed(
                                                context, '/',
                                                arguments: accountData);
                                          }
                                        }))
                          ]))));
        })));
  }
}
