import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_saftey_app/child/child_login_screen.dart';
import 'package:women_saftey_app/model/user_model.dart';
import 'package:women_saftey_app/utils/constan.dart';

import '../components/custom_textfield.dart';
import '../components/primary_button.dart';
import '../components/seconday_button.dart';

class RegisterChidlScreen extends StatefulWidget {
  const RegisterChidlScreen({super.key});

  @override
  State<RegisterChidlScreen> createState() => _RegisterChidlUserState();
}

class _RegisterChidlUserState extends State<RegisterChidlScreen> {
  bool isPasswordShow = true;
  bool isRetypePasswordShow = true;
  final _formKey = GlobalKey<FormState>();
  final formData = Map<String, Object>();
  bool isLoading = false;

  onSubmitt() async {
    _formKey.currentState!.save();
    if (formData['password'] != formData['rpassword']) {
      dialogeuBox(context, 'password and retype password should be equal');
    } else {
      progressIndicator(context);

      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: formData['email'].toString(),
                password: formData['password'].toString());

        if (userCredential.user != null) {
          setState(() {
            isLoading = true;
          });
          final value = userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db =
              FirebaseFirestore.instance.collection('users').doc(value);

          final user = UserModel(
            name: formData['name'].toString(),
            phone: formData['phone'].toString(),
            id: value,
            childEmail: formData['email'].toString(),
            guardiantEmail: formData['gemail'].toString(),
            type: 'child',
          );

          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            goTo(context, const LoginScreen());

            setState(() {
              isLoading = false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          if (kDebugMode) {
            print('the password is provided is too weak');
            dialogeuBox(context, e.toString());
          }
        } else if (e.code == 'email-already-in-use') {
          if (kDebugMode) {
            print('the account already exists for that email');
            dialogeuBox(context, 'the account already exists for that email');
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        if (kDebugMode) {
          dialogeuBox(context, e.toString());
          print(e);
        }
      }
    }
    if (kDebugMode) {
      print(formData['email']);
    }
    if (kDebugMode) {
      print(formData['password']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
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
                            height: height * 0.02,
                          ),
                          Text(
                            'REGISTER AS CHILD',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 37,
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
                            height: height * 0.05,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  hintText: 'Enter name',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  validate: (name) {
                                    if (name!.isEmpty || name.length < 3) {
                                      return 'Enter Correct name';
                                    }
                                    return null;
                                  },
                                  onSave: (name) {
                                    formData['name'] = name ?? '';
                                    return null;
                                  },
                                  prefix: const Icon(Icons.person),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                CustomTextField(
                                  hintText: 'Enter phone',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  validate: (phone) {
                                    if (phone!.isEmpty || phone.length < 3) {
                                      return 'Enter Correct Phone';
                                    }
                                    return null;
                                  },
                                  onSave: (phone) {
                                    formData['phone'] = phone ?? '';
                                    return null;
                                  },
                                  prefix: const Icon(Icons.phone),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                CustomTextField(
                                  hintText: 'Enter email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  validate: (email) {
                                    if (email!.isEmpty ||
                                        email.length < 3 ||
                                        !email.contains('@gmail.com')) {
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
                                  height: height * 0.01,
                                ),
                                CustomTextField(
                                  hintText: 'Enter guardian email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  validate: (gemail) {
                                    if (gemail!.isEmpty ||
                                        gemail.length < 3 ||
                                        !gemail.contains('@gmail.com')) {
                                      return 'Enter Correct guardian email';
                                    }
                                    return null;
                                  },
                                  onSave: (gemail) {
                                    formData['gemail'] = gemail ?? '';
                                    return null;
                                  },
                                  prefix: const Icon(Icons.person),
                                ),
                                SizedBox(
                                  height: height * 0.01,
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
                                  height: height * 0.01,
                                ),
                                CustomTextField(
                                  hintText: 'Enter retype password',
                                  prefix: const Icon(Icons.vpn_key_rounded),
                                  onSave: (rpassword) {
                                    formData['rpassword'] = rpassword ?? '';
                                    return null;
                                  },
                                  validate: (rpassword) {
                                    if (rpassword!.isEmpty ||
                                        rpassword.length < 6) {
                                      return 'Enter rPassword 6 digit';
                                    }
                                    return null;
                                  },
                                  isPassword: isRetypePasswordShow,
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isRetypePasswordShow =
                                            !isRetypePasswordShow;
                                      });
                                    },
                                    icon: isRetypePasswordShow
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
                                    title: 'REGISTER',
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
                            height: height * 0.01,
                          ),
                          SecondaryButton(
                              title: 'Login with your account',
                              onPress: () {
                                goTo(context, const LoginScreen());
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
