import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_saftey_app/chat/caht_screen.dart';
import 'package:women_saftey_app/utils/constan.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SELECT GUARDIAN",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'parent')
            // .where('childEmail',
            //     isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if ((!snapshot.hasData)) {
            return progressIndicator(context);
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final d = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 163, 192),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      onTap: () {
                        goTo(
                            context,
                            ChatScreen(
                                currentUserId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                friendId: d.id,
                                friendName: d['name']));
                      },
                      title: Text(
                        d['name'],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
