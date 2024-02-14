import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:women_saftey_app/child/child_login_screen.dart';
import 'package:women_saftey_app/components/custom_textfield.dart';
import 'package:women_saftey_app/components/primary_button.dart';
import 'package:women_saftey_app/utils/constan.dart';

class CheckUserStatusBeforeChatOnProfile extends StatelessWidget {
  const CheckUserStatusBeforeChatOnProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return const ProfilePage();
          } else {
            Fluttertoast.showToast(msg: 'please login first');
            return const LoginScreen();
          }
        }
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;
  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameC.text = value.docs.first['name'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isSaving == true
            ? const Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.pink,
              ))
            : SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Form(
                          key: key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 28),
                              const Text(
                                "UPDATE YOUR PROFILE",
                                style: TextStyle(fontSize: 25),
                              ),
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: () async {
                                  final XFile? pickImage = await ImagePicker()
                                      .pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 50);
                                  if (pickImage != null) {
                                    setState(() {
                                      profilePic = pickImage.path;
                                    });
                                  }
                                },
                                child: Container(
                                  child: profilePic == null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.deepPurple,
                                          radius: 80,
                                          child: Center(
                                              child: Image.asset(
                                            'assets/add_pic.jpeg',
                                            height: 80,
                                            width: 80,
                                          )),
                                        )
                                      : profilePic!.contains('http')
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              radius: 80,
                                              backgroundImage:
                                                  NetworkImage(profilePic!),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              radius: 80,
                                              backgroundImage:
                                                  FileImage(File(profilePic!))),
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: nameC,
                                hintText: nameC.text,
                                validate: (v) {
                                  if (v!.isEmpty) {
                                    return 'please enter your updated name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              PrimaryButton(
                                  title: "UPDATE",
                                  onPress: () async {
                                    if (key.currentState!.validate()) {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      profilePic == null
                                          ? Fluttertoast.showToast(
                                              msg:
                                                  'please select profile picture')
                                          : update();
                                    }
                                  }),
                              const SizedBox(height: 90),
                              PrimaryButton(
                                  title: "Sign Out",
                                  onPress: () async {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      // ignore: use_build_context_synchronously
                                      goTo(context, const LoginScreen());
                                    } on FirebaseAuthException catch (e) {
                                      // ignore: use_build_context_synchronously
                                      dialogeuBox(context, e.toString());
                                    }
                                  }),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final filenName = const Uuid().v4();
      final Reference fbStorage =
          FirebaseStorage.instance.ref('profile').child(filenName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  update() async {
    setState(() {
      isSaving = true;
    });
    uploadImage(profilePic!).then((value) {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'profilePic': downloadUrl,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
      setState(() {
        isSaving = false;
      });
    });
  }
}
