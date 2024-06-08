import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/LoginScreen.dart';
import 'package:mobile_platform_2024/my_answer.dart';
import 'package:mobile_platform_2024/family_answer.dart';
import 'package:mobile_platform_2024/SignUpScreen.dart';
import 'package:mobile_platform_2024/color.dart';
import 'package:mobile_platform_2024/family_together/agenda.dart';
import 'package:mobile_platform_2024/family_together/family_together.dart';
import 'package:mobile_platform_2024/family_together/family_history.dart';
import 'package:mobile_platform_2024/family_together/select_agenda.dart';
import 'package:mobile_platform_2024/family_together/waiting.dart';
import 'package:mobile_platform_2024/home.dart';
import 'package:mobile_platform_2024/question_history.dart';
import 'package:mobile_platform_2024/today_question.dart';

void main() {
  runApp(MyApp());
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

        '/family_together': (context) => const FamilyTogetherPage(),
        '/family_together/agenda': (context) => const AgendaInputPage(),
        '/family_together/history': (context) => const FamilyHistoryPage(),
        '/family_together/history_detail': (context) =>
        const FamilyHistoryPage(),
        '/family_together/waiting': (context) => const WaitingPage(),
        '/family_together/select_agenda': (context) => const SelectAgendaPage(),
        '/signup' : (context) => const SignUpScreen(),
        '/my_answer' : (context) => const ppEditScreen(),
        '/family_answer' : (context) => const ppListScreen()
        // 여기에 추가
        // Navigator.pushNamed(context, '/family_together/start'),
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
  final List<Widget> _pages = [
    const Home(),
    const TodayQuestion(),
    const QuestionHistory(),
    const FamilyTogetherPage(),
    const LoginScreen()
  ];

  @override
  void initState() => super.initState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("오리함께"),
      // ),
      body: SafeArea(
        child: _pages[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer), label: '오늘문답'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '문답기록'),
          BottomNavigationBarItem(
              icon: Icon(Icons.family_restroom), label: '가족회의'),
          BottomNavigationBarItem(
              icon: Icon(Icons.login), label: '로그인'),
        ],
        currentIndex: _index,

        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        selectedItemColor: colorOrange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}