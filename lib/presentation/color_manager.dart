import 'package:flutter/material.dart';

class ColorManager{
  static Color primaryGreen = Color.fromRGBO(58, 67, 94, 1);
  static Color accentGreen = Color(0xffd4e01e);
  static Color accentGreenOverlay = Color.fromARGB(100, 172, 208, 54);
// static Color accentGreenBg = Color.fromARGB(10, 240, 106, 44);

  static Color prtimaryPurple = Color(0xff00827F);
  static Color accentPurple = Color(0xff1bbaf2);
  static Color accentPurpleOverlay = Color.fromARGB(32, 26, 114, 162);

  static Color greyColor = Color.fromARGB(80, 158, 158, 158);

  Color bg = const Color(0xff0d1736);
  static Color sliverColor = Color(0xffC0C0C0);
  static Color goldColor = Color.fromARGB(255, 214, 183, 7);
  static Color platinumColor = Color.fromARGB(255, 112, 112, 112);

  Gradient gradient4 = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffffdb91),
      Color(0xff0d1736),
      Color(0xff0d1736),
      Color(0xff3a435e),
      Color(0xffff97ab),
    ],
  );
  Gradient gradient3 = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff29ABE2),
      Color(0xff8CC63F),
    ],
  );
  Gradient gradient2 = const LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      Color(0xff009245),
      Color(0xffD9E021),
    ],
  );

}