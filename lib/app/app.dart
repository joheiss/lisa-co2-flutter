import 'package:flutter/material.dart';
import 'my_router.dart';
import 'widgets/my_theme.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meine Räume',
      theme: MyTheme.darkTheme(),
      onGenerateRoute: MyRouter().generateRoute,
    );
  }
}
