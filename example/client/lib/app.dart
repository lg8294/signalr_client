import 'package:client/views/pages/chatPage.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  // Properties

  // Methods
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}
