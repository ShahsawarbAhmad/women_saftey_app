import 'package:flutter/material.dart';
import 'package:women_saftey_app/widgets/home_widgets.dart/emergency/police_emergency.dart';

import 'emergency/ambulance_emergecny.dart';
import 'emergency/army_emergency.dart';
import 'emergency/firebrigade_emergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: const [
          PoliceEmergency(),
          AmbulanceEmergency(),
          FirebrigadeEmergency(),
          ArmyEmergency(),
        ],
      ),
    );
  }
}
