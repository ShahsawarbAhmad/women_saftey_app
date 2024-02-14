import 'package:flutter/material.dart';

class PoliceStationCard extends StatelessWidget {
  final Function? onMapFunction;
  const PoliceStationCard({super.key, this.onMapFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onMapFunction!('Police station near me');
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              // ignore: sized_box_for_whitespace
              child: Container(
                height: 50,
                width: 50,
                child: const Center(
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/police_badge.jpg'),
                  ),
                ),
              ),
            ),
          ),
          const Text("Police Stations")
        ],
      ),
    );
  }
}
