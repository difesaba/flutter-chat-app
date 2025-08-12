import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Melissa Flores',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),

        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                physics: BouncingScrollPhysics(),
                reverse: true,
              ),
            ),
            Divider(height: 1),
            Container(
              // height: 100,
              decoration: BoxDecoration(color: Colors.white),
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                onSubmitted: (String value) {
                  _handleSubmit(value);
                },
                controller: _textController,
                onChanged: (texto) {
                  setState(() {
                    if (texto.trim().isNotEmpty) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: Text('Enviar'),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: _estaEscribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      texto: text,
      uid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    // TODO: OFF SOCKET
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
