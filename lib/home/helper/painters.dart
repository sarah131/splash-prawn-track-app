import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;

class ReflectionPainter extends CustomPainter {
  final Color data;
  final Color fill;

  ReflectionPainter(this.data, this.fill);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(-size.width / 2 + 25, -size.height / 2 + 25,
        size.width - 50, size.height - 50);

    var paint = Paint()
      ..colorFilter =
          ColorFilter.mode(data.withOpacity(0.1), BlendMode.softLight)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = data.withOpacity(0.1)
      ..strokeWidth = 15;

    final reflection = Path();
    reflection.addArc(rect, vector.radians(-10.0), vector.radians(35));
    reflection.addArc(rect, vector.radians(40.0), vector.radians(15));
    reflection.addArc(rect, vector.radians(70.0), vector.radians(5));

    canvas.drawPath(reflection, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FlaskPainter extends CustomPainter {
  final Color data;

  FlaskPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(-size.width / 22, -size.height / 15, 58, 58);

    var paint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = data
      ..strokeWidth = 1;

    final flask = Path();
    flask.moveTo(math.sin(vector.radians(15.0)) * 140,
        -math.cos(vector.radians(15.0)) * 32.5);
    flask.arcTo(rect, vector.radians(-70.0), vector.radians(320), false);
    flask.relativeLineTo(0, -32);
    flask.close();

    final topRect =
        Rect.fromCenter(center: const Offset(27.7, -34), width: 30, height: 5);
    final topRRect = RRect.fromRectAndRadius(topRect, const Radius.circular(10));
    flask.addRRect(topRRect);
    canvas.drawPath(flask, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
