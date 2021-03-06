import 'color_model.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class DrawClockFace extends StatelessWidget {
  final double angleRadiansSeconds;
  final double angleRadiansMinutes;
  final double angleRadiansHours;
  DrawClockFace(
    this.angleRadiansSeconds,
    this.angleRadiansMinutes,
    this.angleRadiansHours,
  );

  @override
  Widget build(BuildContext context) {
    Size _sizeOfMedia = MediaQuery.of(context).size;
    Orientation _orientation = MediaQuery.of(context).orientation;
    double _diameterOfCircle = _orientation == Orientation.portrait
        ? _sizeOfMedia.width * 0.8
        : _sizeOfMedia.height * 0.8;
    Size _sizeOfClockFace = Size(_diameterOfCircle, _diameterOfCircle);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //Draw background circle
          CustomPaint(
            painter: DrawCircle(currentColor[1]),
            size: _sizeOfClockFace,
          ),

          // Segments moving clockwise at speed of minute hand
          Transform.rotate(
            angle: angleRadiansMinutes,
            child: clockface(
              true,
              _diameterOfCircle,
              currentColor[4],
            ),
          ),

          //  Segments moving anticlockwise at speed of minute hand
          Transform.rotate(
            angle: -angleRadiansMinutes,
            child: clockface(
              false,
              _diameterOfCircle,
              currentColor[5],
            ),
          ),
          // Segments moving clockwise at speed of second hand
          Transform.rotate(
            angle: angleRadiansSeconds,
            child: clockface(
              true,
              _diameterOfCircle,
              currentColor[2],
            ),
          ),
          //Segments moving anticlockwise at speed of second hand
          Transform.rotate(
            angle: -angleRadiansSeconds,
            child: clockface(
              false,
              _diameterOfCircle,
              currentColor[3],
            ),
          ),
          // Hour hand
          Transform.rotate(
              angle: angleRadiansHours,
              child: CustomPaint(
                painter: DrawHands(true, 6 * currentHandThickness, context),
                size: _sizeOfClockFace,
              )),

          //minute hand
          Transform.rotate(
            angle: angleRadiansMinutes,
            child: CustomPaint(
              painter: DrawHands(false, 4 * currentHandThickness, context),
              size: _sizeOfClockFace,
            ),
          ),

          //Second hand
          Transform.rotate(
            angle: angleRadiansSeconds,
            child: CustomPaint(
              painter: DrawHands(false, 3 * currentHandThickness, context),
              size: _sizeOfClockFace,
            ),
          ),
          CustomPaint(
            painter: DrawCircle(currentColor[6]),
            size: Size(5 * currentHandThickness, 5 * currentHandThickness),
          )
        ],
      ),
    );
  }
}

class DrawCircle extends CustomPainter {
  Color _color;
  DrawCircle(this._color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Widget clockface(bool clockwise, double _sizeOfCircle, Color color) {
  List<Widget> segments = List<Widget>();
  for (int i = 0; i < 8; i++) {
    segments.add(
      Transform.rotate(
        angle: i * pi / 4 + pi / 12 * 10,
        child: CustomPaint(
          painter: clockwise
              ? DrawSegments(true, color)
              : DrawSegments(false, color),
          size: Size(_sizeOfCircle, _sizeOfCircle),
        ),
      ),
    );
  }
  return Stack(
    children: segments,
  );
}

class DrawSegments extends CustomPainter {
  bool clockwise;
  Color color;
  DrawSegments(this.clockwise, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(
      clockwise ? -size.width / 2 : -size.width / 4,
      clockwise ? 0 : -0.866 * size.height / 2,
      size.width,
      size.height,
    );
    canvas.drawArc(rect, 0, pi / 3, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DrawHands extends CustomPainter {
  BuildContext context;
  bool hours;
  double strokewidth;
  DrawHands(this.hours, this.strokewidth, this.context);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = currentColor[6]
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokewidth;
    Path path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(size.width / 2, hours ? size.height / 5 : 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
