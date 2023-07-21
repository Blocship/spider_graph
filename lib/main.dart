import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: CircleDivider(
          radius: 200,
          numberOfDivisions: 14,
          segmentColors: [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.orange,
            Colors.purple,
            Color(0xffAB86AE),
            Color(0xff6A60A8),
            Color(0xffE34B0F),
            Color(0xff2C994A),
            Color(0xff3e5135),
            Color(0xff421321),
            Color(0xfff0e421),
            Color(0xffe3e2f3),
          ],
          segmentValues: [
            1,
            0.7,
            0.3,
            0.4,
            0.9,
            0.2,
            0.6,
            0.7,
            0.5,
            0.8,
            0.3,
            0.9,
            0.7,
            0.6,
          ],
        ),
      ),
    );
  }
}

class CircleDivider extends StatelessWidget {
  final double radius;
  final int numberOfDivisions;
  final List<Color> segmentColors;
  final List<double> segmentValues;
  const CircleDivider({
    super.key,
    required this.radius,
    required this.numberOfDivisions,
    required this.segmentColors,
    required this.segmentValues,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: CircleDividerPainter(
          radius: radius,
          numberOfDivisions: numberOfDivisions,
          segmentColors: segmentColors,
          segmentValues: segmentValues,
          circleColor: Colors.grey,
          lineColor: Colors.red,
        ),
        size: Size(radius * 2, radius * 2),
      ),
    );
  }
}

class CircleDividerPainter extends CustomPainter {
  final double radius;
  final int numberOfDivisions;
  final List<Color> segmentColors; // List of colors for each segment
  final List<double>
      segmentValues; // List of values for each segment, should be in 0-1
  final Paint circlePaint;
  final Paint linePaint;
  CircleDividerPainter({
    required this.radius,
    required this.numberOfDivisions,
    required this.segmentColors,
    required this.segmentValues,
    required Color circleColor,
    required Color lineColor,
  })  : circlePaint = Paint()..color = circleColor,
        linePaint = Paint()
          ..color = lineColor
          ..strokeWidth = 1;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Draw the circle with the given radius
    // canvas.drawCircle(center, radius, circlePaint);
    // Calculate the angle between two adjacent lines
    final angleBetweenLines = 2 * pi / numberOfDivisions;
    // Draw the lines originating from the center
    for (int i = 0; i < numberOfDivisions; i++) {
      final startAngle = i * angleBetweenLines;
      final sweepAngle = angleBetweenLines;
      final endAngle = startAngle + sweepAngle;

      final desiredLength = radius * segmentValues[i];

      // Calculate the end points of the segment
      final (segX1, segY1) = getXYcomponents(
        desiredLength,
        startAngle,
        offset: center,
      );
      final (segX2, segY2) = getXYcomponents(
        desiredLength,
        endAngle,
        offset: center,
      );

      // final px5BeforeSeg1End = getXYcomponents(
      //   desiredLength - 5,
      //   startAngle,
      //   offset: center,
      // );

      // final px5AtSeg2Start = getXYcomponents(radius, radians)

      // Create a rectangular path to fill the segment with color
      final fillPath = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(segX1, segY1)
        // ..quadraticBezierTo(segX1, segY1, segX2, segY2)
        ..lineTo(segX2, segY2)
        // ..relativeQuadraticBezierTo(segX1, segY1, segX2, segY2)
        ..close();
      // Fill the segment with color
      final segmentPaint = Paint()
        ..color = segmentColors[i % segmentColors.length];
      canvas.drawPath(fillPath, segmentPaint);

      // Draw the outer boundry
      final (x1, y1) = getXYcomponents(radius, startAngle, offset: center);
      final (x2, y2) = getXYcomponents(radius, endAngle, offset: center);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);

      // Draw the lines in between segments
      canvas.drawLine(center, Offset(x1, y1), linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

(double x, double y) getXYcomponents(double radius, double radians,
    {Offset offset = Offset.zero}) {
  final x = (radius * cos(radians)) + offset.dx;
  final y = (radius * sin(radians)) + offset.dy;
  return (x, y);
}
