import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User?> data() async {
      return FirebaseAuth.instance.currentUser;
    }
    return FutureBuilder(
      future:data(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt',descending: true,)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                  chatDocs[index]['userId'] == FirebaseAuth.instance.currentUser!.uid,
                  key: ValueKey(chatDocs[index].id),
                ),
              );
            });
      },
    );
  }
}
