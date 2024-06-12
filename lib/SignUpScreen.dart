import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'color.dart';
import 'shared_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _pw;
  String? _pwCheck;
  String? _inviteCode;

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();  // 팝업 닫기
                if (message == '회원가입되었습니다!') {
                  Navigator.of(context).pop();  // 메인 화면으로 이동
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> signUp(String name, String email, String password, String? inviteCode) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // DisplayName 업데이트
        await user.updateDisplayName(name);

        String familyId;
        final firestore = FirebaseFirestore.instance;

        if (inviteCode != null && inviteCode.isNotEmpty) {
          // 가족 초대 코드가 있는 경우
          DocumentSnapshot familySnapshot = await firestore.collection('families').doc(inviteCode).get();
          if (familySnapshot.exists) {
            familyId = inviteCode;
          } else {
            return '유효하지 않은 가족 초대 코드입니다.';
          }
        } else {
          // 가족 초대 코드가 없는 경우 새로운 가족 생성
          DocumentReference familyRef = firestore.collection('families').doc();
          familyId = familyRef.id;
          await familyRef.set({
            "name": "$name's Family",
            "questionsAnswered": 0,
            "currentQuestionIndex": 1,
            "members": {
              user.uid: true,
            }
          });
        }

        // 사용자 정보 저장
        await firestore.collection('users').doc(user.uid).set({
          "name": name,
          "email": email,
          "joinDate": DateTime.now().toIso8601String(),
          "familyId": familyId,
        });

        return '회원가입되었습니다!';
      } else {
        return '회원가입 실패. 다시 시도해주세요.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return '비밀번호가 너무 약합니다.';
      } else if (e.code == 'email-already-in-use') {
        return '해당 이메일은 이미 사용 중입니다.';
      }
      return '회원가입 실패. 오류: ${e.message}';
    } catch (e) {
      return '회원가입 실패. 오류: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '회원정보를\n입력하세요',
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "이름",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '이름',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          _name = value;
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '이름을 입력하세요';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "이메일",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _email,
                        decoration: const InputDecoration(
                          hintText: '이메일',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          _email = value;
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '이메일을 입력하세요';
                          } else if (!value.contains('@')) {
                            return '잘못된 이메일 형태입니다';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "비밀번호",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '비밀번호',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          _pw = value;
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '비밀번호를 입력하세요';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "비밀번호 확인",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '비밀번호 확인',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          _pwCheck = value;
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '비밀번호를 입력하세요';
                          } else if (value != _pw) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "가족 초대 코드 (선택)",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '가족 초대 코드',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGrey),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          _inviteCode = value;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: OrangeActionButton(
                  text: "회원가입",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String message = await signUp(_name!, _email!, _pw!, _inviteCode);
                      _showDialog(message);
                    }
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
