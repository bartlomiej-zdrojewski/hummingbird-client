import 'package:flutter/material.dart';
import 'package:hummingbird/account_data.dart';
import 'package:hummingbird/friend_data.dart';
import 'package:hummingbird/chat_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AccountData _account;
  var _friends = List<FriendData>();
  var _filteredFriends = List<FriendData>();

  void _filterFriends(String pattern) {
    var matchingFriends = List<FriendData>();
    if (pattern.isNotEmpty) {
      _friends.forEach((item) {
        if (item.name.toLowerCase().contains(pattern.toLowerCase()) ||
            item.surname.toLowerCase().contains(pattern.toLowerCase())) {
          matchingFriends.add(item);
        }
      });
    } else {
      matchingFriends.addAll(_friends);
    }
    setState(() {
      _filteredFriends.clear();
      _filteredFriends.addAll(matchingFriends);
    });
  }

  void _login() async {
    final preferences = await SharedPreferences.getInstance();
    final login = preferences.getString('login') ?? '';
    final password = preferences.getString('password') ?? '';

    if (login.isEmpty || password.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      String sessionId;
      // TODO fetch session id
      setState(() {
        _account = AccountData(login: login, sessionId: sessionId);
      });
    }
  }

  void _logout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences..remove('login');
    preferences.remove('password');
    setState(() {
      _account = null;
    });
    _login();
  }

  @override
  void initState() {
    // TODO fetch
    _friends.addAll(
        [FriendData(name: "Adam", surname: "Zaleski", login: "azaleski")]);
    _filteredFriends.addAll(_friends);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_account == null) {
      final result = ModalRoute.of(context).settings.arguments;
      if (result is AccountData) {
        _account = result;
      } else {
        _login();
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Hummingbird'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _logout();
              },
            )
          ],
        ),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "Type to search for friends...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
                        onChanged: (value) {
                          _filterFriends(value);
                        }),
                  ),
                  _friends.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Press button below to add new friends.',
                              style: TextStyle(color: Colors.black54)),
                        )
                      : _filteredFriends.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text('No matching friends found.',
                                  style: TextStyle(color: Colors.black54)),
                            )
                          : Container(),
                  Expanded(
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemCount: _filteredFriends.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(child: Icon(Icons.person)),
                              title: Text(_filteredFriends[index].name +
                                  ' ' +
                                  _filteredFriends[index].surname),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatView(
                                            accountData: _account,
                                            friendData:
                                                _filteredFriends[index])));
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          }))
                ],
              ),
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.person_add),
          onPressed: () {
            // TODO new message dialog
          },
        ));
  }
}
