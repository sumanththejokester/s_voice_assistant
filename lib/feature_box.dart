import 'package:flutter/material.dart';
import 'package:s_voice_assistant/pallette.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String header;
  final String desc;
  const FeatureBox(
      {super.key,
      required this.color,
      required this.header,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                header,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                desc,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
