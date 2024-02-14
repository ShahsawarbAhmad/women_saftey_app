import 'package:flutter/material.dart';
import 'package:women_saftey_app/child/bottom_screen/addcontacts.dart';
import 'package:women_saftey_app/child/bottom_screen/chat_page.dart';
import 'package:women_saftey_app/child/bottom_screen/child_home_page.dart';

import 'package:women_saftey_app/child/bottom_screen/profile_page.dart';
import 'package:women_saftey_app/child/bottom_screen/review_page.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const AddContactsPage(),
    const ChatPage(),
    const ProfilePage(),
    const ReviewPage(),
  ];

  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: 'Contacts', icon: Icon(Icons.contacts)),
            BottomNavigationBarItem(
                label: 'Chats', icon: Icon(Icons.chat_sharp)),
            BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
            BottomNavigationBarItem(
                label: 'Reviews', icon: Icon(Icons.reviews)),
          ]),
    );
  }
}
