import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_saftey_app/child/bottom_page.dart';
import 'package:women_saftey_app/components/custom_textfield.dart';
import 'package:women_saftey_app/components/primary_button.dart';
import 'package:women_saftey_app/components/seconday_button.dart';
import 'package:women_saftey_app/child/register_child_user.dart';
import 'package:women_saftey_app/db/shared_pref.dart';

import 'package:women_saftey_app/parents/parent_home_screen.dart';
import 'package:women_saftey_app/parents/parent_register_screen.dart';
import 'package:women_saftey_app/utils/constan.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShow = true;
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_collection_literals
  final formData = Map<String, Object>();
  bool isLoading = false;

  onSubmitt() async {
    _formKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: formData['email'].toString(),
              password: formData['password'].toString());
      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then(
          (value) {
            if (value['type'] == 'parent') {
              MySharedPreference.saveUserType('parent');
              goTo(context, const ParentHomeScreen());
              if (kDebugMode) {
                print(value['type']);
              }
            } else {
              MySharedPreference.saveUserType('child');
              goTo(context, const BottomPage());
            }
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        dialogeuBox(context, 'user not found for that email');
        if (kDebugMode) {
          print('user not found');
        }
      } else if (e.code == 'wrong-password') {
        // ignore: use_build_context_synchronously
        dialogeuBox(context, 'wrong password provided by the user');
        if (kDebugMode) {
          print('wrong password provided by the user');
        }
      }
    }

    if (kDebugMode) {
      print(formData['email']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(
                            'USER LOGIN',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          const Image(
                              height: 130,
                              width: 130,
                              image: AssetImage('assets/logo.jpg')),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  hintText: 'Enter email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  validate: (email) {
                                    if (email!.isEmpty ||
                                        email.length < 3 ||
                                        !email.contains('@')) {
                                      return 'Enter Correct email';
                                    }
                                    return null;
                                  },
                                  onSave: (email) {
                                    formData['email'] = email ?? '';
                                    return null;
                                  },
                                  prefix: const Icon(Icons.person),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomTextField(
                                  hintText: 'Enter password',
                                  prefix: const Icon(Icons.vpn_key_rounded),
                                  onSave: (password) {
                                    formData['password'] = password ?? '';
                                    return null;
                                  },
                                  validate: (password) {
                                    if (password!.isEmpty ||
                                        password.length < 6) {
                                      return 'Enter Password 6 digit';
                                    }
                                    return null;
                                  },
                                  isPassword: isPasswordShow,
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordShow = !isPasswordShow;
                                      });
                                    },
                                    icon: isPasswordShow
                                        // ignore: dead_code
                                        ? const Icon(
                                            Icons.visibility_off_outlined)
                                        : const Icon(Icons.visibility),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                PrimaryButton(
                                    title: 'Login',
                                    onPress: () {
                                      setState(() {});
                                      if (_formKey.currentState!.validate()) {
                                        onSubmitt();
                                      }
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SecondaryButton(
                                  title: 'click here', onPress: () {}),
                            ],
                          ),
                          SecondaryButton(
                              title: 'Register as Child ',
                              onPress: () {
                                goTo(context, const RegisterChidlScreen());
                              }),
                          SecondaryButton(
                              title: 'Register as Parent ',
                              onPress: () {
                                goTo(context, const RegisterParentScreen());
                              }),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
