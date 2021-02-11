import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextCompose extends StatefulWidget {

  final Function({String text, File imgFile}) sendMessage;

  TextCompose(this.sendMessage);

  @override
  _TextComposeState createState() => _TextComposeState();
}

class _TextComposeState extends State<TextCompose> {

  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  final ImagePicker _imagePicker = ImagePicker();

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final PickedFile imageFile = await _imagePicker.getImage(source: ImageSource.camera);
              final File selectedFile = File(imageFile.path);
              if(imageFile == null) return;
              widget.sendMessage(imgFile: selectedFile);
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
                widget.sendMessage(text: text);
                _reset();
              },
              controller: _controller,
            )
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? () {
              widget.sendMessage(text: _controller.text);
              _reset();
            } : null,
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}