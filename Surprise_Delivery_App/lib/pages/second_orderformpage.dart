import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';

class SecondOrderPage extends StatefulWidget {
  const SecondOrderPage({super.key});

  @override
  State<SecondOrderPage> createState() => _SecondOrderPageState();
}

class _SecondOrderPageState extends State<SecondOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Help Us Pick!",
            style: GoogleFonts.lilitaOne(
              fontSize: 30,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color.fromARGB(255, 249, 160, 34).withValues(alpha: 0.5),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("2ec7a3"),
            hexStringToColor("12e0b0"),
            hexStringToColor("0fb5ec")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ));
  }
}
