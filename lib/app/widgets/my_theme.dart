import 'package:flutter/material.dart';

class MyTheme {
  static const axisColor = Colors.white;
  static final List<Color> diagramGradientColors = [
    Colors.orange[50],
    Colors.orange[300],
  ];
  static const diagramLabelColor = Colors.white;
  static final diagramLineColors = [Colors.orange[200], Colors.orange, Colors.orange[400]];

  static final toggleButtonBorderColor = Colors.blueGrey[200];
  static const smallButtonColor = Colors.orange;

  static final smallTextBoxColor = Colors.blueGrey[900];

  static final bubbleColor1 = Colors.blueGrey[600];
  static final bubbleColor2 = Colors.blueGrey[300].withOpacity(0.8);
  static final bubbleColor3 = Colors.blueGrey[100].withOpacity(0.6);

  static final highlightColor = Colors.orange[100];

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey[900],
      accentColor: Colors.orange[400],
      canvasColor: Colors.blueGrey[50],
      shadowColor: Colors.blueGrey[700],
      scaffoldBackgroundColor: Colors.blueGrey[600],
      bottomAppBarColor: Colors.blueGrey[50],
      floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
        backgroundColor: Colors.orange[400],
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'Comfortaa',
      ).copyWith(
        headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        headline3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        subtitle2: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
        bodyText1: TextStyle(fontFamily: 'Hind', fontSize: 16.0, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(fontFamily: 'Hind', fontSize: 12.0, fontWeight: FontWeight.normal),
        caption: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        overline: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
