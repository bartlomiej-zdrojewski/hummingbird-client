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
  String _messageText;
  var _messageList = List<MessageData>();
  final TextEditingController _textEditingController = TextEditingController();

  void _sendMessage(BuildContext context) {
    final message = MessageData(
        timestamp: DateTime.now(),
        text: _messageText,
        senderLogin: widget.accountData.login,
        receiverLogin: widget.friendData.login);

    _messageList.add(message);

    // TODO send + add widget.accountData.sessionId
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
  void initState() {
    _messageText = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.friendData.name + ' ' + widget.friendData.surname),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Text(_messageList.length.toString()), // TODO chatHistory
              ),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                            minLines: 1,
                            maxLines: 4,
                            controller: _textEditingController,
                            scrollPhysics: BouncingScrollPhysics(),
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                hintText: "Start typing a message...",
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)))),
                            onChanged: (value) {
                              setState(() {
                                _messageText = value;
                              });
                            })),
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
                              color: Theme.of(context).accentIconTheme.color,
                              onPressed: () {
                                if (_messageText.isNotEmpty) {
                                  _sendMessage(context);
                                  setState(() {
                                    _messageText = '';
                                    _textEditingController.clear();
                                  });
                                }
                              },
                            )))
                  ]))
            ],
          ),
        ));
  }
}
