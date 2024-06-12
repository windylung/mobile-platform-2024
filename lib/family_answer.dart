import 'package:ducktogether/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_answer.dart';
import 'model/answer.dart';

class FamilyAnswerListScreen extends StatefulWidget {
  final int? questionId;
  final String? question;
  const FamilyAnswerListScreen({super.key, this.questionId, this.question});

  @override
  FamilyAnswerListScreenState createState() => FamilyAnswerListScreenState();
}

class FamilyAnswerListScreenState extends State<FamilyAnswerListScreen> {
  List<Answer> answers = []; // 답변 저장하는 리스트
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    User? user = _auth.currentUser;
    if (user == null || widget.questionId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user.uid).get();
    String familyId = userSnapshot['familyId'];

    QuerySnapshot answerSnapshot = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('answers')
        .doc(widget.questionId.toString())
        .collection('users')
        .get();

    List<Answer> loadedAnswers = [];
    for (var doc in answerSnapshot.docs) {
      loadedAnswers.add(Answer(
        content: doc['answer'],
      ));
    }

    setState(() {
      answers = loadedAnswers;
      _isLoading = false;
    });
  }

  void addAnswer(Answer answer) {
    setState(() {
      answers.add(answer);
    });
  }

  void deleteAnswer(int index) {
    setState(() {
      answers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: colorOrange,),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 60),
            Center(
              child: Text(
                widget.question ?? '',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(

                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    return Container(

                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F4F6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: colorOrange,
                            radius: 20,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              answers[index].content,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
