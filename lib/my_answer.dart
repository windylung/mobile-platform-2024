import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ducktogether/shared_button.dart';
import 'model/answer.dart';
import 'model/question.dart';

class MyAnswerScreen extends StatefulWidget {
  final Question? question;
  final int? questionId;
  final Answer? answer;

  const MyAnswerScreen({super.key, this.question, this.answer, this.questionId});

  @override
  MyAnswerScreenState createState() => MyAnswerScreenState();
}

class MyAnswerScreenState extends State<MyAnswerScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _answer;
  String? _question;
  int? _questionId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    _questionId = widget.questionId;
    super.initState();
    if (widget.answer != null) {
      _answer = widget.answer!.content;
      _isLoading = false;
    } else if (widget.questionId != null) {
      _loadAnswer();
    }
    if (widget.question != null) {
      _question = widget.question!.content;
    }
  }

  Future<void> _loadAnswer() async {
    User? user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user.uid).get();
    String familyId = userSnapshot['familyId'];

    DocumentSnapshot answerSnapshot = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('answers')
        .doc(widget.questionId.toString())
        .collection('users')
        .doc(user.uid)
        .get();

    if (answerSnapshot.exists) {
      setState(() {
        _answer = answerSnapshot['answer'] ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAnswer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user.uid).get();
        String familyId = userSnapshot['familyId'];

        // 사용자의 답변 저장
        await _firestore
            .collection('families')
            .doc(familyId)
            .collection('answers')
            .doc(_questionId.toString())
            .collection('users')
            .doc(user.uid)
            .set({
          'answer': _answer,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // 모든 가족 구성원의 답변이 제출되었는지 확인
        QuerySnapshot answerSnapshot = await _firestore
            .collection('families')
            .doc(familyId)
            .collection('answers')
            .doc(_questionId.toString())
            .collection('users')
            .get();
        QuerySnapshot familyMembersSnapshot = await _firestore
            .collection('families')
            .doc(familyId)
            .collection('members')
            .get();

        if (answerSnapshot.size == familyMembersSnapshot.size) {
          // 모든 구성원이 답변을 제출한 경우 questionsAnswered 증가 및 답변 초기화
          await _firestore.collection('families').doc(familyId).update({
            'questionsAnswered': FieldValue.increment(1),
          });
          // 답변 초기화
          for (DocumentSnapshot doc in answerSnapshot.docs) {
            await doc.reference.delete();
          }
        }

        // Navigator.pushNamed(context, '/family_answer');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 80),
              Text(
                _question ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    initialValue: _answer,
                    decoration: const InputDecoration(
                      labelText: "오늘의 답변",
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF616161),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF616161),
                    ),
                    maxLines: null,
                    onSaved: (value) => _answer = value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "내용을 입력하세요";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OrangeActionButton(
                  text: widget.answer == null ? "새 답변 작성" : "답변 수정",
                  onPressed: _saveAnswer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
