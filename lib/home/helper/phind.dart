import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class phind extends StatelessWidget {
  const phind({super.key, required this.value});
  final value;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        height: 110,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value >= 5 && value <= 9 ? Colors.green : Colors.red,
        ),
      ),
      Container(
        height: 100,
        width: 40,
        margin: const EdgeInsets.fromLTRB(15, 0, 4, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 14),
        child: Image(
          image: AssetImage("images/ph_meter.png"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SfLinearGauge(
          orientation: LinearGaugeOrientation.vertical,
          minimum: 0.0,
          showLabels: false,
          markerPointers: [
            LinearShapePointer(
              value: value,
              color: value >= 5 && value <= 9 ? Colors.green : Colors.red,
              width: 12,
              height: 15,
              elevation: 0,
              offset: 2,
            ),
          ],
          isAxisInversed: true,
          animateRange: true,
          interval: 5,
          showTicks: false,
          labelOffset: 2,
          maximum: 14,
          labelPosition: LinearLabelPosition.inside,
          maximumLabels: 5,
          minorTicksPerInterval: 0,
          showAxisTrack: false,
        ),
      ),
    ]);
  }
}
