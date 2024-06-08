import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/shared_button.dart';

import 'family_answer.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "answer screen",
      home: TodayQuestion(),
    );
  }
}

class TodayQuestion extends StatelessWidget {
  const TodayQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('오늘의 질문'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "질문",
              style: TextStyle(fontSize: 24),

            ),
            const SizedBox(height: 20),
            const OrangeButton(
              text: "답변하기",
              route: '/family_answer'
            ),
          ],
        ),
      ),
    );
  }
}

