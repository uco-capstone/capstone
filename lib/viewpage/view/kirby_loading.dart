import 'package:flutter/material.dart';
import 'dart:math' as math;

class KirbyLoading extends StatefulWidget {
  const KirbyLoading({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KirbyLoadingState();
  }
}

class _KirbyLoadingState extends State<KirbyLoading> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),     //duration of rotation
    vsync: this,
  )..repeat(reverse: false);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) { 
            return Transform.rotate(
              angle: _controller.value * math.pi * 2,       //rotates a full circle
              child: child,
            );
          },
          child: SizedBox(
            height: 200,
            child: Image.asset('images/kirby-loading.png')
          ),
        ),
      );
  }
}