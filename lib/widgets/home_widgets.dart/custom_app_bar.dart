import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_saftey_app/utils/quotes.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  Function? onTap;
  final int quoteIndex;
  CustomAppBar({super.key, this.onTap, required this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                sweetSying[quoteIndex],
                style: GoogleFonts.aBeeZee(
                  fontSize: 18,
                ),
              ),
            ),
          )),
    );
  }
}
