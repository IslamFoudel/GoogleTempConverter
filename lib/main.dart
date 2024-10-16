import 'package:flutter/material.dart';
import 'package:google_temperature_task/screens/home.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Home.ROUTE,
      routes: {
        Home.ROUTE: (_) => Home(),
      },
    );
  }
}
