import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:roquiz/model/style/palettes.dart';

class StarButton extends StatefulWidget {
  final double size;
  final bool animate;
  final Function()? onTap;
  final Function()? onMaxSize;

  const StarButton({
    super.key,
    required this.size,
    this.animate = true,
    this.onTap,
    this.onMaxSize,
  }) : assert(
         !(!animate && onMaxSize != null),
         "Cannot set onMaxSize() if animate is false",
       ),
       assert(
         !(animate && onTap != null),
         "Cannot set onTap() if animate is true",
       );

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
      duration: Duration(milliseconds: widget.animate ? 600 : 0),
      value: widget.size,
    );

    _growAnimation = Tween<double>(begin: widget.size, end: _maxSize).animate(
      CurvedAnimation(parent: _pressGrowController, curve: Curves.ease),
    );

    _pressGrowController.reset();

    _pressGrowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pressGrowController.reverse();
        if (widget.onMaxSize != null) {
          widget.onMaxSize!();
        }
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
    final starButtonTheme = Theme.of(context).extension<StarButtonPalette>()!;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.animate)
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
                onTap: widget.onTap,
                onTapDown: widget.animate
                    ? (_) {
                        _pressGrowController.forward();
                        _pulseController.stop();
                        setState(() {
                          _hasBeenPressed = true;
                        });
                      }
                    : null,
                onTapUp: widget.animate
                    ? (_) {
                        _pressGrowController.reverse();
                      }
                    : null,
                onTapCancel: widget.animate
                    ? () {
                        _pressGrowController.reverse();
                      }
                    : null,
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
