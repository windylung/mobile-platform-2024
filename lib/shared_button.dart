import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/color.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    Key? key,
    required this.text, // 타입을 String으로 명확히 하여 안정성 향상
    required this.route, // 타입을 String으로 명확히 하여 안정성 향상
  }) : super(key: key);

  final String text;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: colorOrange, // 정의되어 있어야 함
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // 둥근 모서리 반영
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          fixedSize: const Size(331, 54), // 버튼 크기 조정
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(text));
  }
}
