import 'dart:ui';
import 'package:flutter/material.dart';

class BoxAnimation extends StatefulWidget {
  const BoxAnimation({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<StatefulWidget> createState() {
    return BoxAnimationState();
  }
}

class BoxAnimationState extends State<BoxAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  late Path _path2;
  late double scrollOffset;

  @override
  void initState() {
    scrollOffset = 0;
    widget.scrollController.addListener(() {
      scrollOffset = widget.scrollController.offset;
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5000),
    );
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double maxScrollExtent = widget.scrollController.position.maxScrollExtent;

    _path = drawPath(size);
    _path2 = drawPath2(size);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child: CustomPaint(
                  painter: PathPainter(_path),
                ),
              ),
              Positioned(
                top: calculate(scrollOffset / maxScrollExtent, _path).dy,
                left: calculate(scrollOffset / maxScrollExtent, _path).dx,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: scrollOffset / maxScrollExtent * 20 + 5,
                  height: scrollOffset / maxScrollExtent * 20 + 5,
                ),
              ),
              Positioned(
                top: 0,
                child: CustomPaint(
                  painter: PathPainter(_path2),
                ),
              ),
              Positioned(
                top: calculate(scrollOffset / maxScrollExtent, _path2).dy,
                left: calculate(scrollOffset / maxScrollExtent, _path2).dx,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: scrollOffset / maxScrollExtent * 20 + 5,
                  height: scrollOffset / maxScrollExtent * 20 + 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawPath(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(0, size.height - 100);
    return path;
  }

  Path drawPath2(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2 + 50, size.height / 2);
    path.lineTo(0, size.height - 50);
    return path;
  }

  Offset calculate(value, Path path) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }
}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
