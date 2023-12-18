import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../charts/chart.dart';
import '../../theme/theme.dart';

class card2 extends StatelessWidget {
  const card2({
    super.key,
    required this.val,
    required this.header,
    required this.sider,
    required this.centerWidget,
    required this.footer,
    required this.systemname,
    required this.pondname,
  });
  final val;
  final String header;
  final String sider;
  final Widget centerWidget;
  final String footer;
  final systemname;
  final pondname;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    double boxHeight = height * (isPortrait ? 0.225 : 0.425);
    double boxWidth = width * (isPortrait ? 0.4 : 0.2);
    double childHeight = height * (isPortrait ? 0.14 : 0.26);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => chart(
                sider: sider,
                last: val,
                wanted: header,
                systemname: systemname,
                pondname: pondname,
              ))),
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
            color: !themeProvider.isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Text(
            header == 'TDS' ? 'SALINITY' : header.toUpperCase(),
            style: TextStyle(
              fontSize: isPortrait ? 15 : 14,
              fontFamily: "SF-Pro",
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          SizedBox(height: childHeight, child: centerWidget),
          const SizedBox(
            height: 6,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$val $sider',
                  style: TextStyle(
                    fontFamily: "SF-Pro",
                    fontWeight: FontWeight.w600,
                    fontSize: isPortrait ? 16 : 14,
                  ),
                ),
                Text(
                  footer,
                  style: TextStyle(
                    fontFamily: "SF-Pro",
                    fontSize: isPortrait ? 16 : 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
