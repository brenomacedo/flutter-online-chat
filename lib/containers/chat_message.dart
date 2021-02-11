import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          !mine ?
          Padding(
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl'])
            ),
            padding: EdgeInsets.only(right: 10.0),
          ) : Container(

          ),
          Expanded(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.end,
              children: [
                data['imageUrl'] != null ?
                  Image.network(data['imageUrl'], width: 250,) :
                  Text(data['text'], style: TextStyle(fontSize: 16.0),
                  textAlign: mine ? TextAlign.end : TextAlign.start),
                Text(data['senderName'], style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500))
              ]
            )
          ),
          mine ?
          Padding(
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl'])
            ),
            padding: EdgeInsets.only(left: 10.0),
          ) : Container(
            
          ),
        ],
      )
    );
  }
}