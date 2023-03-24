import 'package:flutter/material.dart';

//please add the colors you need for your views in this theme

ThemeData odatafyTheme() {
  return ThemeData(
    // Colors
    backgroundColor: Color(0xFF001B48),
    primaryColor: Color(0xFF018ABE),
    primaryColorLight: Color(0xFF97CADB),
    highlightColor: Color(0xFFD6E8EE),
    indicatorColor: Color(0xFFF19D1A),

    /*
    backgroundColor: Color.fromARGB(255, 27, 42, 49),
    primaryColor: Color.fromARGB(176, 32, 60, 71),
    primaryColorLight: Color.fromARGB(255, 40, 91, 95),
    highlightColor: Color.fromARGB(255, 115, 171, 172),
    indicatorColor: Color.fromARGB(255, 241, 157, 26),
*/
/*
 backgroundColor: Color.fromARGB(255, 14, 35, 28),
    primaryColor: Color.fromARGB(176, 35, 90, 79),
    primaryColorLight: Color.fromARGB(255, 76, 140, 125),
    highlightColor: Color.fromARGB(255, 137, 171, 177),
    indicatorColor: Color.fromARGB(255, 241, 157, 26), 
    */

    // Icons
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 27, 42, 49),
    ),

    // Text Theme:
    // fontSizes comply to Material-Design guidelines
    textTheme: const TextTheme(
      // Headlines
      headlineLarge: TextStyle(
        fontSize: 32,
        fontFamily: 'Proxima Nova Bold',
        color: Color(0xff003050),
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontFamily: 'Proxima Nova Bold',
        color: Color(0xff003050),
        letterSpacing: -0.5,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontFamily: 'Proxima Nova Bold',
        color: Color(0xff003050),
        letterSpacing: -0.5,
      ),

      // Title
      titleLarge: TextStyle(
        fontSize: 22,
        fontFamily: 'Proxima Nova',
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontFamily: 'Proxima Nova',
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontFamily: 'Proxima Nova',
        color: Colors.white,
        letterSpacing: -0.5,
      ),

      // Labels
      labelLarge: TextStyle(
        fontSize: 14,
        fontFamily: 'Proxima Nova',
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontFamily: 'Proxima Nova',
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontFamily: 'Proxima Nova',
        color: Colors.white,
        letterSpacing: -0.5,
      ),

      // Indicator
      displayLarge: TextStyle(
        fontSize: 22,
        fontFamily: 'Proxima Nova Bold',
        color: Color(0xff838FA4),
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontFamily: 'Proxima Nova Bold',
        color: Color(0xff838FA4),
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        fontFamily: 'Proxima Nova Bold',
        color: Color(0xff838FA4),
        letterSpacing: -0.5,
      ),

      // Body
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Proxima Nova',
        color: Color(0xff838FA4),
        letterSpacing: -0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: 'Proxima Nova',
        color: Color(0xff838FA4),
        letterSpacing: -0.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontFamily: 'Proxima Nova',
        color: Color(0xff838FA4),
        letterSpacing: -0.5,
      ),
    ),
  );
}
