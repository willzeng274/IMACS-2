import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:imacs/screens/home_screen.dart';
import 'package:imacs/widgets/artificial_horizon.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WARG IMACS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) => HomePage(title: 'WARG IMACS'),
      },
    );
  }
}
