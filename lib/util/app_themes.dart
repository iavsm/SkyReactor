import 'package:flutter/material.dart';

import '../shared_widgets/circle_thumb_shape.dart';
import 'constants.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
}

final appThemeData = {
  AppTheme.lightTheme: ThemeData(
    platform: TargetPlatform.iOS,
    scaffoldBackgroundColor: kColorBackground,
    toggleableActiveColor: kColorPrimary,
    appBarTheme: const AppBarTheme(
      elevation: 1,
      color: kColorPrimary,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: kColorAppBarText,
      ),
      actionsIconTheme: IconThemeData(
        color: kColorAppBarText,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kColorAppBarText,
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[300],
      thickness: 0.5,
      space: 0.5,
      indent: 10,
      endIndent: 10,
    ),
    textTheme: TextTheme(
      button: kTextStyleButton,
      subtitle1: kTextStyleSubtitle1.copyWith(color: kColorPrimary),
      subtitle2: kTextStyleSubtitle2.copyWith(color: kColorGrey),
      bodyText2: kTextStyleBody2.copyWith(color: kColorPrimary),
      bodyText1: kTextStyleBody2.copyWith(color: kColorAppBarText),
      headline4: kTextStyleHeadline4.copyWith(color: kColorPrimary),
      headline6: kTextStyleHeadline6.copyWith(color: kColorPrimary),
      headline5: kTextStyleHeadline5.copyWith(color: kColorAppBarText),
      headline3: kTextStyleHeadline6.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
      caption: kTextStyleCaption.copyWith(color: kColorPrimary),
    ),
    iconTheme: const IconThemeData(
      color: kColorPrimary,
    ),
    fontFamily: 'Poppins',
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.grey[200]),
      ),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: kColorPrimary,
      thumbShape: const CircleThumbShape(thumbRadius: 15),
      activeTrackColor: kColorPrimary,
      overlayColor: kColorPrimary.withOpacity(0.2),
      trackHeight: 4,
    ),
  ),
  AppTheme.darkTheme: ThemeData(
    brightness: Brightness.dark,
    platform: TargetPlatform.iOS,
    scaffoldBackgroundColor: const Color(0xff121212),
    toggleableActiveColor: kColorLavenderBlue,
    appBarTheme: AppBarTheme(
      elevation: 1,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.87),
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.87),
      ),
      textTheme: const TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.white54,
      thickness: 0.5,
      space: 0.5,
      indent: 10,
      endIndent: 10,
    ),
    textTheme: TextTheme(
      button: kTextStyleButton.copyWith(color: Colors.white.withOpacity(0.87)),
      subtitle1: kTextStyleSubtitle1.copyWith(color: Colors.white.withOpacity(0.87)),
      subtitle2: kTextStyleSubtitle2.copyWith(color: Colors.white.withOpacity(0.87)),
      bodyText2: kTextStyleBody2.copyWith(color: Colors.white.withOpacity(0.87)),
      headline6: kTextStyleHeadline6.copyWith(color: Colors.white.withOpacity(0.87)),
    ),
    iconTheme: IconThemeData(
      color: Colors.white.withOpacity(0.87),
    ),
    fontFamily: 'Poppins',
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: kColorLavenderBlue,
      thumbShape: const CircleThumbShape(thumbRadius: 15),
      activeTrackColor: kColorLavenderBlue,
      overlayColor: kColorLavenderBlue.withOpacity(0.2),
      trackHeight: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.87)),
      ),
    ),
  ),
};
