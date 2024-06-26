import 'package:ducktogether/color.dart';
import 'package:flutter/material.dart';
import 'package:ducktogether/shared_button.dart';

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
    return (const Scaffold(
      body: SafeArea(
          child: Center(
        child: OrangeButton(
            text: "대화 시작", route: '/family_together/select_agenda'),
      )),
    ));
  }
}
