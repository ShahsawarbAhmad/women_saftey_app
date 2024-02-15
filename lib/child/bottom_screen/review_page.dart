import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_saftey_app/components/custom_textfield.dart';
import 'package:women_saftey_app/components/primary_button.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController locationC = TextEditingController();
  TextEditingController viewsC = TextEditingController();
  bool isSaving = false;

  showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Review your place"),
            content: Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    hintText: 'enter location',
                    controller: locationC,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: viewsC,
                    hintText: 'enter reviews detail',
                    maxLines: 2,
                  ),
                ),
              ],
            )),
            actions: [
              PrimaryButton(
                  title: "SAVE",
                  onPress: () {
                    saveReview();
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  saveReview() async {
    setState(() {
      isSaving = true;
    });
    await FirebaseFirestore.instance
        .collection('reviews')
        .add({'location': locationC.text, 'views': viewsC.text}).then((value) {
      setState(() {
        isSaving = false;
        Fluttertoast.showToast(msg: 'review uploaded successfully');
      });
    });
  }

  void deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(documentId)
          .delete()
          .then((value) {
        Fluttertoast.showToast(msg: "deleted successfully");
      }).catchError((error) {
        Fluttertoast.showToast(msg: error.toString());
      });

      print('Document $documentId deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSaving == true
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Recent Review by other",
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('reviews')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final data = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Card(
                                  elevation: 10,
                                  // color: Colors.primaries[Random().nextInt(17)],
                                  child: ListTile(
                                    title: Text(
                                      data['location'],
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    subtitle: Text(data['views']),
                                    trailing: IconButton(
                                        onPressed: () {
                                          deleteDocument(
                                              snapshot.data!.docs[index].id);
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          showAlert(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
