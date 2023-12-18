import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import 'painters.dart';

class flask extends StatelessWidget {
  flask({super.key, required this.value});
  final value;
  Size kSize = const Size(60, 60);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CustomPaint(
              size: kSize / 6,
              painter: FlaskPainter(
                  themeProvider.isDark ? Colors.black : Colors.white),
            ),
            Container(
              height: 57,
              width: 57,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
              ),
              child: LiquidCircularProgressIndicator(
                value: value / 20,
                valueColor: value > 6 && value < 10
                    ? const AlwaysStoppedAnimation(Colors.green)
                    : const AlwaysStoppedAnimation(Colors.red),
                borderWidth: 0,
                backgroundColor:
                    !themeProvider.isDark ? Colors.black : Colors.white,
                borderColor:
                    !themeProvider.isDark ? Colors.black : Colors.white,
                direction: Axis.vertical,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
