import 'dart:math';

import 'package:flutter/material.dart';

class CircleDividerPainter extends CustomPainter {
  final double graphRadius;
  final double radius;
  final int numberOfDivisions;
  final List<Color> segmentColors;
  final List<double> segmentValues;
  final Color circleColor;
  final Color lineColor;

  CircleDividerPainter({
    double? radius,
    required this.graphRadius,
    required this.numberOfDivisions,
    required this.segmentColors,
    required this.segmentValues,
    required this.circleColor,
    required this.lineColor,
  }) : radius = radius ?? graphRadius - 20;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Point(size.width / 2, size.height / 2);
    // angle between separator lines
    final sweepAngle = 2 * pi / numberOfDivisions;
    final boundryRadius = graphRadius;

    // paints
    final backgroundPolygonPaint = Paint()..color = circleColor;
    final polygonBorderPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final separatorLinePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    // paths
    final Path polygonPath = Path()
      ..moveToPoint(getXYcomponents(boundryRadius, 0, offset: center));
    final List<Point<double>> separatorLines = [];
    final List<Path> segmentPaths = [];

    // points calculation
    for (int i = 0; i < numberOfDivisions; i++) {
      final startAngle = i * sweepAngle;
      final endAngle = startAngle + sweepAngle;

      final seperatorPoint =
          getXYcomponents(radius, startAngle, offset: center);
      separatorLines.add(seperatorPoint);

      final polygonNextPoint =
          getXYcomponents(boundryRadius, endAngle, offset: center);
      polygonPath.lineToPoint(polygonNextPoint);

      final desiredLength = radius * segmentValues[i];
      // Create a rectangular path to fill the segment with color
      late final Path segmentPath;
      if (desiredLength == 0) {
        segmentPath = Path()
          ..moveToPoint(center)
          ..close();
      } else {
        // Calculate the end points of the segment
        final segmentPoint1 =
            getXYcomponents(desiredLength, startAngle, offset: center);
        final segmentPoint2 =
            getXYcomponents(desiredLength, endAngle, offset: center);

        const radialPadding = 4;
        final distance = segmentPoint1.distanceTo(segmentPoint2);
        final radialangle = (sweepAngle / distance) * radialPadding;
        final segment1RadialPointStart = getXYcomponents(
          desiredLength - radialPadding,
          startAngle,
          offset: center,
        );
        final segment1RadialPointEnd = getXYcomponents(
          desiredLength,
          startAngle + radialangle,
          offset: center,
        );
        final segment2RadialPointStart = getXYcomponents(
          desiredLength,
          endAngle - radialangle,
          offset: center,
        );
        final segment2RadialPointEnd = getXYcomponents(
          desiredLength - radialPadding,
          endAngle,
          offset: center,
        );

        segmentPath = Path()
          ..moveToPoint(center)
          ..lineToPoint(segment1RadialPointStart)
          ..quadraticBezierPointTo(segmentPoint1, segment1RadialPointEnd)
          ..lineToPoint(segment2RadialPointStart)
          ..quadraticBezierPointTo(segmentPoint2, segment2RadialPointEnd)
          ..close();
      }
      segmentPaths.add(segmentPath);
    }
    polygonPath.close();

    // draw
    canvas.drawPath(polygonPath, backgroundPolygonPaint);
    canvas.drawPath(polygonPath, polygonBorderPaint);
    for (int i = 0; i < segmentPaths.length; i++) {
      canvas.drawPath(segmentPaths[i], Paint()..color = segmentColors[i]);
    }
    for (int i = 0; i < separatorLines.length; i++) {
      canvas.drawLine(
          center.toOffset, separatorLines[i].toOffset, separatorLinePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Point<double> getXYcomponents(
  double radius,
  double radians, {
  Point offset = const Point(0, 0),
}) {
  final x = (radius * cos(radians)) + offset.x;
  final y = (radius * sin(radians)) + offset.y;
  return Point(x, y);
}

extension XPoint on Point<double> {
  Offset get toOffset => Offset(x, y);
}

extension XPath on Path {
  void moveToPoint(Point<double> point) => moveTo(point.x, point.y);
  void lineToPoint(Point<double> point) => lineTo(point.x, point.y);
  void quadraticBezierPointTo(Point<double> point1, Point<double> point2) =>
      quadraticBezierTo(point1.x, point1.y, point2.x, point2.y);
}
