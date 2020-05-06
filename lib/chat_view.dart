import 'package:flutter/material.dart';
import 'package:hummingbird/friend_data.dart';
import 'package:hummingbird/message_data.dart';
import 'account_data.dart';

class ChatView extends StatefulWidget {
  final AccountData accountData;
  final FriendData friendData;

  ChatView({Key key, @required this.accountData, @required this.friendData})
      : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  var _messageList = List<MessageData>();
  final _messageTextController = TextEditingController();

  void _sendMessage(BuildContext context) {
    final message = MessageData(
        timestamp: DateTime.now(),
        text: _messageTextController.text,
        senderLogin: widget.accountData.login,
        receiverLogin: widget.friendData.login);

    _messageList.add(message);

    // TODO send message request (add session id)
    Future.delayed(Duration(seconds: 3)).then((_) {
      _onError(context, 'Error', 'Sending error', 'OK').then((_) {
        setState(() {
          _messageList.remove(message);
        });
      });
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
          content: SingleChildScrollView(child: Text(content)),
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
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                  widget.friendData.name + ' ' + widget.friendData.surname),
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Text(_messageList.length
                        .toString()), // TODO display message list
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: TextField(
                                minLines: 1,
                                maxLines: 4,
                                controller: _messageTextController,
                                scrollPhysics: BouncingScrollPhysics(),
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    hintText: "Start typing a message...",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)))))),
                        Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Ink(
                                decoration: ShapeDecoration(
                                  color: Theme.of(context).accentColor,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.chat),
                                  tooltip: 'Send message',
                                  color:
                                      Theme.of(context).accentIconTheme.color,
                                  onPressed: () {
                                    if (_messageTextController
                                        .text.isNotEmpty) {
                                      _sendMessage(context);
                                      _messageTextController.clear();
                                    }
                                  },
                                )))
                      ]))
                ],
              ),
            )));
  }
}
