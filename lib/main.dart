import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_chat/screens/chat_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Chat Online",
    home: ChatScreen(),
    theme: ThemeData(
      primaryColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.blue
      )
    ),
  ));
}