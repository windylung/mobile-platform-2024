import 'package:ducktogether/family_together/family_start.dart';
import 'package:ducktogether/logout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ducktogether/LoginScreen.dart';
import 'package:ducktogether/my_answer.dart';
import 'package:ducktogether/family_answer.dart';
import 'package:ducktogether/SignUpScreen.dart';
import 'package:ducktogether/color.dart';
import 'package:ducktogether/family_together/agenda.dart';
import 'package:ducktogether/family_together/family_together.dart';
import 'package:ducktogether/family_together/family_history.dart';
import 'package:ducktogether/family_together/waiting.dart';
import 'package:ducktogether/home.dart';
import 'package:ducktogether/question_history.dart';
import 'package:ducktogether/today_question.dart';
import 'package:ducktogether/family_together/select_agenda.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Mobile Platform 2024',
      initialRoute: '/',
      routes: {
        '/': (context) => AuthStateHandler(),
        '/family_together': (context) => const FamilyTogetherPage(),
        '/family_together/agenda': (context) => const AgendaInputPage(),
        '/family_together/history': (context) => const FamilyHistoryPage(),
        '/family_together/history_detail': (context) => const FamilyHistoryPage(),
        '/family_together/waiting': (context) => const WaitingPage(),
        '/family_together/select_agenda': (context) => const SelectAgendaPage(),
        '/signup': (context) => const SignUpScreen(),
        '/my_answer': (context) => const MyAnswerScreen(),
        '/family_answer': (context) => FamilyAnswerListScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainPage(),
        '/family/start' : (context) => const FamilyStart()
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
    // const Home(),
    TodayQuestionScreen(),
    const QuestionHistory(),
    const FamilyTogetherPage(),
    const LogoutScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _pages[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: '오늘문답'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '문답기록'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: '가족회의'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: '로그아웃'),
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

class AuthStateHandler extends StatefulWidget {
  @override
  _AuthStateHandlerState createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState();
    });
  }

  Future<void> _checkAuthState() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 로딩 스피너
      ),
    );
  }
}
