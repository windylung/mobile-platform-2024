import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/SignUpScreen.dart';

// Login 클래스 정의
class Login {
  final String name;
  final String email;
  final String pw;

  Login({required this.name, required this.email, required this.pw});
}

// LoginScreen 클래스 정의
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

// LoginScreenState 클래스 정의
class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _pw;

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
                      Text("이메일", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      TextFormField(
                        initialValue: _email,
                        decoration: const InputDecoration(
                          labelText: '이메일',
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2.0),
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

                  const SizedBox(height: 8.0),
                  TextFormField(
                    initialValue: _pw,
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2.0),
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
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC076), // 버튼 색상 변경
                    minimumSize: const Size.fromHeight(50), // 버튼 높이 변경
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newProfile = Login(name: '', email: _email!, pw: _pw!);
                      Navigator.pop(context, newProfile);
                    }
                  },
                  child: const Text('로그인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
