import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_saftey_app/chat/caht_screen.dart';
import 'package:women_saftey_app/utils/constan.dart';

import '../child/child_login_screen.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(),
            ),
            ListTile(
                title: TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        goTo(context, LoginScreen());
                      } on FirebaseAuthException catch (e) {
                        dialogeuBox(context, e.toString());
                      }
                    },
                    child: const Text(
                      "SING OUT",
                    ))),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        // backgroundColor: Color.fromARGB(255, 250, 163, 192),
        title: const Text("SELECT CHILD"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'child')
            .where('guardiantEmail',
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: progressIndicator(context));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final d = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 163, 192),
                      borderRadius: BorderRadius.circular(12)),
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
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(d['name']),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
