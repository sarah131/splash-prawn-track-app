import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class circularIndicator extends StatelessWidget {
  const circularIndicator({
    super.key,
    required this.tds,
  });

  final tds;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 90,
        width: 90,
        decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xffF7FBFD),
                Color(0xff8cc9f3),
              ],
            ),
            shape: BoxShape.circle),
        child: LiquidCircularProgressIndicator(
          value: tds / 100,
          valueColor: tds >= 40 && tds <= 60
              ? const AlwaysStoppedAnimation(Colors.green)
              : const AlwaysStoppedAnimation(Colors.red),
          borderWidth: 0,
          backgroundColor: const Color.fromARGB(113, 255, 255, 255),
          borderColor: Colors.white,
          direction: Axis.vertical,
        ),
      ),
    );
  }
}
