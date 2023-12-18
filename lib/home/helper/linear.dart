import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class linearIndicator extends StatelessWidget {
  const linearIndicator({
    super.key,
    required this.temp,
  });

  final double temp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0x2BA5BDFF), width: 4),
        color: const Color.fromARGB(43, 249, 251, 255),
      ),
      child: RotatedBox(
        quarterTurns: -1,
        child: LinearPercentIndicator(
          barRadius: const Radius.circular(30),
          percent: temp,
          lineHeight: 16,
          backgroundColor: const Color.fromARGB(255, 215, 237, 255),
          progressColor: temp >= .4 && temp <= .6 ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
