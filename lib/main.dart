import 'package:flutter/material.dart';
import 'package:hummingbird/login_view.dart';
import 'package:hummingbird/register_view.dart';
import 'home_view.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hummingbird',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.green
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView()
      }
    );
  }
}
