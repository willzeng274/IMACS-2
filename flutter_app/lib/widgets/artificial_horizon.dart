import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imacs/modules/get_drone_information.dart';
// import 'package:imacs/widgets/data_field_widget.dart';

Stream<double> angleStream(Duration interval) async* {
  double angle = pi / 2;
  bool decreasing = true;

  while (true) {
    yield angle;
    await Future.delayed(interval);

    if (angle <= -pi / 2) {
      decreasing = false;
    } else if (angle >= pi / 2) {
      decreasing = true;
    }

    if (decreasing) {
      angle -= pi / 100;
    } else {
      angle += pi / 100;
    }
  }
}

class HorizonGame extends StatefulWidget {
  final GetDroneInformation getDroneInformation;
  const HorizonGame({Key? key, required this.getDroneInformation})
      : super(key: key);

  @override
  _ArtificialHorizonState createState() => _ArtificialHorizonState();
}

class _ArtificialHorizonState extends State<HorizonGame> {
  @override
  Widget build(BuildContext context) {
    final stream = angleStream(const Duration(milliseconds: 50));

    return Stack(alignment: Alignment.center, children: [
      StreamBuilder<double>(
        stream: stream,
        initialData: pi, // Set initial value to π
        builder: (context, snapshot) {
          // final angle = snapshot.data ??
          //     pi; // Get the angle from the stream or default to π
          const angle = 0.0;

          return Transform.translate(
              offset: Offset.zero,
              child: Transform.rotate(
                angle: angle,
                child: Transform.scale(
                  scale: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Container(color: Colors.blue)),
                      Container(height: 1, color: Colors.white),
                      Expanded(child: Container(color: Colors.green)),
                    ],
                  ),
                ),
              ));
        },
      ),
      Positioned(
        top: 100, // Adjust as needed for positioning
        child: CustomPaint(
          size: const Size(200, 200), // Specify the size of the canvas
          painter: ArcIndicator(),
        ),
      ),
    ]);
  }
}

class ArcIndicator extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint compassPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    const double radius = 80.0;
    Rect rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);

    // Draw the arc from -π/2 to π/2
    canvas.drawArc(rect, pi, pi, false, compassPaint);

    // Draw heading markers (like 0, 30, 60 degrees)
    for (int i = -60; i <= 60; i += 30) {
      double angle = i * pi / 180;
      double dx = radius * cos(angle);
      double dy = radius * sin(angle);

      canvas.drawLine(
          Offset(centerX + dx, centerY + dy),
          Offset(centerX + dx * 0.9, centerY + dy * 0.9), 
          compassPaint);

      // Draw text for headings (like NW, N, etc.)
      String heading = (i == 0)
          ? "N"
          : (i < 0)
              ? (360 + i).toString()
              : i.toString();

      TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: heading,
            style: const TextStyle(color: Colors.white, fontSize: 12)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(centerX + dx - 8, centerY + dy - 12));
    }
  }

  @override
  bool shouldRepaint(ArcIndicator oldDelegate) => false;
}
