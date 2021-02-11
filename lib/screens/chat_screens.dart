import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_chat/containers/chat_message.dart';
import 'package:online_chat/containers/text_composer.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  User _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User> _getUser() async {

    if(_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount googleSignInAccout = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccout.authentication;
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = authResult.user;

      return user;

    } catch(e) {
      return null;
    }
  }

  void _sendMessage({String text, File imgFile}) async {

    final User user = await _getUser();

    if(user == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Não foi possível fazer o login, tente novamente!"),
          backgroundColor: Colors.red,
        )
      );
    }

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
      "time": Timestamp.now()
    };

    if(imgFile != null) {

      setState(() {
        _isLoading = true;
      });

      TaskSnapshot task = await FirebaseStorage.instance.ref().child(_currentUser.uid)
        .child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);


      String url = await task.ref.getDownloadURL();
      data['imageUrl'] = url;

      setState(() {
        _isLoading = false;
      });
    }

    if(text != null) {
      data['text'] = text;
    }

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentUser != null ? 'Olá, ${_currentUser.displayName}' : 'Chat App'
        ),
        elevation: 0,
        actions: [
          _currentUser != null ? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text("Deslogado com sucesso!")
                )
              );
            }
          ) : SizedBox(),
        ],
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator()
                    );
                  default:
                    List<QueryDocumentSnapshot> documents = snapshot.data.docs.reversed.toList();

                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ChatMessage(documents[index].data(),
                        documents[index].data()['uid'] == _currentUser?.uid);
                      },
                    );
                }
              },
            )
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextCompose(_sendMessage)
        ],
      )
    );
  }
}