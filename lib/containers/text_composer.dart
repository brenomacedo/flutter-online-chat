import 'package:flutter/material.dart';

class TextCompose extends StatefulWidget {
  @override
  _TextComposeState createState() => _TextComposeState();
}

class _TextComposeState extends State<TextCompose> {

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () {

            },
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar uma mensagem'
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {

              }, 
            )
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? () {

            } : null,
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}