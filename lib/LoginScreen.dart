import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUpScreen.dart';
import 'main.dart';
import 'color.dart';
import 'shared_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _pw;

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: Container(
            height: 150,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();  // 팝업 닫기
                    if (message == '로그인 성공!') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        return '로그인 성공!';
      } else {
        return '로그인 실패. 다시 시도해주세요.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '사용자를 찾을 수 없습니다.';
      } else if (e.code == 'wrong-password') {
        return '잘못된 비밀번호입니다.';
      }
      return '로그인 실패. 오류: ${e.message}';
    } catch (e) {
      return '로그인 실패. 오류: ${e.toString()}';
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
                    '이메일과 비밀번호를\n입력하세요',
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 55),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("이메일",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
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
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("비밀번호",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFormField(
                          initialValue: _pw,
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
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colorGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: OrangeActionButton(
                  text: "로그인",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String message = await signIn(_email!, _pw!);
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
