import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/color.dart';
import 'package:mobile_platform_2024/family_together/agenda.dart';
import 'package:mobile_platform_2024/family_together/family_together.dart';
import 'package:mobile_platform_2024/family_together/family_history.dart';
import 'package:mobile_platform_2024/home.dart';
import 'package:mobile_platform_2024/question_history.dart';
import 'package:mobile_platform_2024/today_question.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Mobile Platform 2024',
      home: const MainPage(),
      initialRoute: '/',
      routes: {
        // '/' : (context) => MainPage(),
        '/family_together' : (context) => FamilyTogetherPage(),
        '/family_together/agenda' : (context) => AgendaInputPage(),
        '/family_together/history' : (context) => FamilyHistoryPage(),

      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _index = 0;
  List<Widget> _pages = [
    Home(),
    TodayQuestion(),
    QuestionHistory(),
    FamilyTogetherPage(),
  ];

  @override
  void initState () => super.initState();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("오리함께"),
      ),
      body: SafeArea(
        child: _pages[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: '오늘문답'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '문답기록'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: '가족회의'),
        ],
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        selectedItemColor: color_orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
