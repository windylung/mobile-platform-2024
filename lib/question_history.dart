import 'package:ducktogether/family_answer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ducktogether/color.dart';

const COLOR_BLUE = Color(0xFF1E88E5); // 원하는 블루 색상으로 설정

class QuestionHistory extends StatefulWidget {
  const QuestionHistory({super.key});

  @override
  _QuestionHistoryState createState() => _QuestionHistoryState();
}

class _QuestionHistoryState extends State<QuestionHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _allQuestions = [];
  List<Map<String, dynamic>> _filteredQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user.uid).get();
    String familyId = userSnapshot['familyId'];

    DocumentSnapshot familySnapshot = await _firestore.collection('families').doc(familyId).get();
    _currentQuestionIndex = familySnapshot['currentQuestionIndex'];

    List<Map<String, dynamic>> questions = [];
    for (int i = 0; i <= _currentQuestionIndex; i++) {
      DocumentSnapshot questionSnapshot = await _firestore
          .collection('questions')
          .doc("question${i}")
          .get();

      if (questionSnapshot.exists) {
        questions.add(questionSnapshot.data() as Map<String, dynamic>);
      }
    }

    setState(() {
      _allQuestions = questions;
      _filteredQuestions = questions;
      _isLoading = false;
    });
  }

  void _filterQuestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredQuestions = _allQuestions;
      });
    } else {
      setState(() {
        _filteredQuestions = _allQuestions
            .where((question) => question['text'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: COLOR_BLUE,
    );

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  _filterQuestions(value);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "검색어를 입력하세요",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredQuestions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // print('Tapped question: ${_filteredQuestions[index]['id']}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => FamilyAnswerListScreen(question:_filteredQuestions[index]['text'], questionId: _filteredQuestions[index]['id'])));},
                        // 필요에 따라 다른 동작을
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: colorLightBlue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _filteredQuestions[index]['text'],
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF616161)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
