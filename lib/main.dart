import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_saftey_app/child/bottom_page.dart';

import 'package:women_saftey_app/child/child_login_screen.dart';
import 'package:women_saftey_app/db/shared_pref.dart';
import 'package:women_saftey_app/firebase_options.dart';

import 'package:women_saftey_app/parents/parent_home_screen.dart';
import 'package:women_saftey_app/utils/constan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreference.init();
  // await initializeService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.firaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: MySharedPreference.getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == '') {
              return const LoginScreen();
            }
            if (snapshot.data == 'child') {
              return const BottomPage();
            }
            if (snapshot.data == 'parent') {
              return const ParentHomeScreen();
            }

            return progressIndicator(context);
          },
        ));
  }
}
