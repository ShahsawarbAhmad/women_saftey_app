import 'dart:math';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women_saftey_app/db/db_services.dart';
import 'package:women_saftey_app/model/contactsm.dart';
import 'package:women_saftey_app/utils/quotes.dart';
import 'package:women_saftey_app/widgets/home_widgets.dart/custom_app_bar.dart';
import 'package:women_saftey_app/widgets/home_widgets.dart/custom_carousel.dart';
import 'package:women_saftey_app/widgets/home_widgets.dart/emergency.dart';
import 'package:women_saftey_app/widgets/home_widgets.dart/live_safe.dart';
import 'package:women_saftey_app/widgets/home_widgets.dart/safe_home/safe_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int qIndex = 0;
  Position? curentPosition;
  String? curentAddress;
  LocationPermission? permission;

  getPermission() async => await [Permission.sms].request();
  isPermissionGranted() async => await Permission.sms.status.isGranted;
  sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      if (kDebugMode) {
        print("Sent");
      }
      Fluttertoast.showToast(msg: "send");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  getCurrentLocation() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        curentPosition = position;
        // ignore: avoid_print
        print(curentPosition!.latitude);
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          curentPosition!.latitude, curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getRandomQuote() {
    Random random = Random();

    setState(() {
      qIndex = random.nextInt(sweetSying.length);
    });
  }

  getAndSendSms() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();

    // ignore: unused_local_variable
    String messageBody =
        "https://maps.google.com/?daddr=${curentPosition!.latitude},${curentPosition!.longitude}";
    if (await isPermissionGranted()) {
      // ignore: avoid_function_literals_in_foreach_calls
      contactList.forEach((element) {
        // _sendSms("${element.number}", "i am in trouble $messageBody");
      });
    } else {
      Fluttertoast.showToast(msg: "something wrong");
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPermission();

    super.initState();
    getRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.0004,
            ),
            CustomAppBar(
              quoteIndex: qIndex,
              onTap: getRandomQuote(),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const CustomCarousel(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Emergency",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Emergency(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Explore LiveSafe",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const LiveSafe(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SafeHome(),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
