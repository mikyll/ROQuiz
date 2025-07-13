import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:roquiz/model/style/palettes.dart';

class StarButton extends StatefulWidget {
  final double size;
  final Function() onMaxSize;

  const StarButton({super.key, required this.size, required this.onMaxSize});

  @override
  State<StatefulWidget> createState() => StarButtonState();
}

class StarButtonState extends State<StarButton> with TickerProviderStateMixin {
  final double splashScaleMin = 0.6;
  final double splashScaleMax = 1.2;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseScaleAnimation;
  late final Animation<double> _pulseFadeAnimation;

  late final AnimationController _pressGrowController;
  late final Animation<double> _growAnimation;

  double _maxSize = 0.0;
  bool _hasBeenPressed = false;

  double _getMaxSize() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    double physicalHeight = view.physicalSize.height;

    double devicePixelRatio = view.devicePixelRatio;
    double screenWidth = physicalWidth / devicePixelRatio;
    double screenHeight = physicalHeight / devicePixelRatio;

    return (screenWidth < screenHeight ? screenWidth : screenHeight) * 0.8;
  }

  @override
  void initState() {
    super.initState();

    _maxSize = _getMaxSize();

    // Setup pulse/splash animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();

    _pulseScaleAnimation = Tween<double>(
      begin: splashScaleMin,
      end: splashScaleMax,
    ).animate(_pulseController);

    _pulseFadeAnimation = Tween<double>(
      begin: 1,
      end: 0.0,
    ).animate(_pulseController);

    // Setup grow on press animation
    _pressGrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: widget.size,
    );

    _growAnimation = Tween<double>(begin: widget.size, end: _maxSize).animate(
      CurvedAnimation(parent: _pressGrowController, curve: Curves.ease),
    );

    _pressGrowController.reset();

    _pressGrowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onMaxSize();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressGrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StarButtonTheme starButtonTheme = Theme.of(
      context,
    ).extension<StarButtonTheme>()!;

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: _hasBeenPressed ? 0.0 : 1.0,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return FadeTransition(
                opacity: _pulseFadeAnimation,
                child: ScaleTransition(
                  scale: _pulseScaleAnimation,
                  child: Container(
                    width: widget.size * 1.5,
                    height: widget.size * 1.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo.shade300,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _growAnimation,
          builder: (context, _) {
            return Container(
              width: _growAnimation.value,
              height: _growAnimation.value,
              decoration: BoxDecoration(
                color: starButtonTheme.backgroundColor,
                borderRadius: BorderRadius.circular(1000),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(1000),
                onTapDown: (_) {
                  _pressGrowController.forward();
                  _pulseController.stop();
                  setState(() {
                    _hasBeenPressed = true;
                  });
                },
                onTapUp: (_) {
                  _pressGrowController.reverse();
                },
                onTapCancel: () {
                  _pressGrowController.reverse();
                },
                child: Icon(
                  Icons.star,
                  color: starButtonTheme.starColor,
                  size: _growAnimation.value * 0.9,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
