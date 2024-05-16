import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FamilyTogetherPage extends StatefulWidget {
  const FamilyTogetherPage({super.key});

  @override
  State<FamilyTogetherPage> createState() => _FamilyTogetherPageState();
}

class _FamilyTogetherPageState extends State<FamilyTogetherPage> {
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/family_together/agenda'),
              child: Text("대화주제 작성")),
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/family_together/history'),
              child: Text("지난대화 확인하기")),
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/family_together/start'),
              child: Text("가족대화 시작하기")),
          Container(
            child: Text("대화 참여자"),
          )
        ],
      )),
    );
  }
}
