

import 'package:flutter/material.dart';
import 'package:spider_graph/painter.dart';

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
          graphRadius: radius,
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
