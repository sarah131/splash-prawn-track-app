import 'package:flutter/material.dart';

class cloudWidget extends StatelessWidget {
  const cloudWidget(
      {super.key, required this.temperature, required this.tempString});

  final temperature;
  final String tempString;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    return isPortrait
        ? Column(
            children: [
              SizedBox(
                height: height * 0.08,
                child: const Image(
                  image: AssetImage("images/Cloud.png"),
                  alignment: Alignment.topCenter,
                ),
              ),
              Text(
                "$temperature°C",
                style: const TextStyle(
                  fontFamily: "SF-Pro",
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: width * 0.3,
                height: height * 0.04,
                child: Center(
                  child: Text(
                    tempString,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Row(
            children: [
              SizedBox(
                height: height * 0.13,
                child: const Image(
                  image: AssetImage("images/Cloud.png"),
                  alignment: Alignment.topCenter,
                ),
              ),
              Text(
                "$temperature°C",
                style: const TextStyle(
                  fontFamily: "SF-Pro",
                  fontSize: 18,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 6),
                width: width * 0.2,
                height: height * 0.08,
                child: Center(
                  child: Text(
                    tempString,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: width * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
