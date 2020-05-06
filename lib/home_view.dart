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
  var _filterPattern = "";

  Future<bool> _login(BuildContext context) async {
    if (_account != null) {
      return true;
    }

    final result = ModalRoute.of(context).settings.arguments;
    if (result is AccountData) {
      _account = result;
      return _fetchFriends(context).then((_) {
        return true;
      }).catchError((e) {
        // TODO error alert
        return false;
      });
    }

    final preferences = await SharedPreferences.getInstance();
    final login = preferences.getString('login') ?? '';
    final password = preferences.getString('password') ?? '';
    if (login.isNotEmpty && password.isNotEmpty) {
      // TODO create session request
      return Future.delayed(Duration(seconds: 3)).then((_) {
        _account = AccountData(login: login, sessionId: "abc");
        return _fetchFriends(context).then((_) {
          return true;
        }).catchError((e) {
          // TODO error alert
          return false;
        });
      }).catchError((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }

    return false;
  }

  void _logout(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('login');
    preferences.remove('password');

    // TODO invalidate session request
    Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<bool> _fetchFriends(BuildContext context) async {
    // TODO fetch friend list, sort by lastActivity
    await Future.delayed(new Duration(seconds: 3));
    setState(() {
      //_friends.clear();
      _friends.add(FriendData(
          name: "Bartłomiej",
          surname: "Zdrojewski",
          login: "bartlomiej-zdrojewski",
          lastActive: DateTime.now()));
      _filterFriends(_filterPattern);
    });
    return null;
  }

  void _filterFriends(String pattern) {
    var matchingFriends = List<FriendData>();
    _filterPattern = pattern.toLowerCase();
    if (_filterPattern.isNotEmpty) {
      _friends.forEach((item) {
        if (item.name.toLowerCase().contains(_filterPattern) ||
            item.surname.toLowerCase().contains(_filterPattern)) {
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

  @override
  Widget build(BuildContext context) {
    final loginFuture = _login(context);
    return FutureBuilder(
        future: loginFuture,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Hummingbird'),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        _logout(context);
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
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                                decoration: InputDecoration(
                                    hintText: "Type to search for friends...",
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)))),
                                onChanged: (value) {
                                  _filterFriends(value);
                                }),
                          ),
                          _friends.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                      'Press button below to add new friends.\nSwipe up to refresh.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black54)),
                                )
                              : _filteredFriends.isEmpty
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Text('No matching friends found.',
                                          style:
                                              TextStyle(color: Colors.black54)),
                                    )
                                  : Container(),
                          Expanded(
                              child: RefreshIndicator(
                                  onRefresh: () {
                                    return _fetchFriends(context)
                                        .catchError((e) {
                                      // TODO error alert
                                    });
                                  },
                                  child: ListView.separated(
                                      physics: AlwaysScrollableScrollPhysics()
                                          .applyTo(BouncingScrollPhysics()),
                                      itemCount: _filteredFriends.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                              child: Icon(Icons.person)),
                                          title: Text(_filteredFriends[index]
                                                  .name +
                                              ' ' +
                                              _filteredFriends[index].surname),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatView(
                                                            accountData:
                                                                _account,
                                                            friendData:
                                                                _filteredFriends[
                                                                    index])));
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider();
                                      })))
                        ],
                      ),
                    )),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.person_add),
                  onPressed: () {
                    // TODO new message dialog
                  },
                ));
          } else {
            return Scaffold(
                appBar: AppBar(title: Text('Hummingbird'), centerTitle: true),
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
