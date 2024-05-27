import 'package:flutter/material.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Text("data"),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                  context, '/family_together/select_agenda'),
              child: const Text("대화시작"))
        ],
      )),
    ));
  }
}
