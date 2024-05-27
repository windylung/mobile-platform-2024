import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/color.dart';

class AgendaInputPage extends StatefulWidget {
  const AgendaInputPage({super.key});

  @override
  State<AgendaInputPage> createState() => _AgendaInputPageState();
}

class _AgendaInputPageState extends State<AgendaInputPage> {
  final List<String> _agendas = ["아침에 밥 먹기 싫어요", "재민아 결혼하자", "가족여행을 가고 싶어요"];

  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Column(
            children: _agendas
                .map((agenda) => Container(
                      width: screenWidth * 0.9, // 화면 너비의 90%를 차지하도록 설정
                      height: 65,
                      color: colorLightBlue,
                      child: Text(agenda),
                    ))
                .toList(),
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '안건',
            ),
            textAlignVertical: TextAlignVertical.center,
            controller: _controller,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _agendas.add(_controller.text);
                  _controller.text = '';
                });
              },
              child: const Text("저장")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("대화 시작"))
        ]),
      ),
    );
  }
}


// Container(
// width: screenWidth * 0.9,  // 화면 너비의 90%를 차지하도록 설정
// height: 65,
// color: color_blue,
// child: Center(child: Text("아침에 밥 먹기 싫어요")),
// ),
