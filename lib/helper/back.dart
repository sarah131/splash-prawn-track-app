import 'package:flutter/material.dart';

class back extends StatelessWidget {
  const back({
    super.key,
    required this.text,
    required double width,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: SizedBox(
        child: Row(
          children: [
            Image.asset(
              'asset/icon/left.png',
              width: 30,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
