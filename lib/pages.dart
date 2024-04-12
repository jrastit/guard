import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const RootPage(),
    );
  }
}
/** Root Page **/
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(64, 158, 158, 240),
        title: const Text('APP'),
      ),
      backgroundColor: const Color.fromARGB(128, 128, 128, 240),
      body: const Text('Text'),
    );
  }
}

/* LANDING PAGE */

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(64, 158, 158, 240),
        title: const Text('LANDING PAGE'),
      ),
      backgroundColor: const Color.fromARGB(128, 128, 128, 240),
      body: const Text('Text'),
    );
  }
}

/* LOGIN PAGE */



/* GPS TRACKING  */
