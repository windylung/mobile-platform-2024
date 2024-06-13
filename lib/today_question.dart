import 'package:ducktogether/model/question.dart';
import 'package:ducktogether/my_answer.dart';
import 'package:ducktogether/shared_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodayQuestionScreen extends StatefulWidget {
  @override
  _TodayQuestionScreenState createState() => _TodayQuestionScreenState();
}

class _TodayQuestionScreenState extends State<TodayQuestionScreen> {
  String? _question;
  int _questionsAnswered = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user.uid).get();
      String familyId = userSnapshot['familyId'];

      DocumentSnapshot familySnapshot = await _firestore.collection('families').doc(familyId).get();
      _questionsAnswered = familySnapshot['questionsAnswered'];

      DocumentSnapshot questionSnapshot = await _firestore.collection('questions').doc('question$_questionsAnswered').get();
      setState(() {
        _question = questionSnapshot['text'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Center(
              child: Text(
                _question ?? '질문을 불러오는 중입니다...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OrangeActionButton(text: "답변하기", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyAnswerScreen(question: Question(content: _question!), questionId: _questionsAnswered,),
                  ),
                );
              })
            ),
          ],
        ),
      ),
    );
  }
}
