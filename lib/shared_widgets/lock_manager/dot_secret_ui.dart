import 'dart:async';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class DotSecretConfig {
  final double dotSize;
  final EdgeInsetsGeometry padding;
  final Color enabledColor;
  final Color disabledColor;
  final Color dotBorderColor;

  const DotSecretConfig({
    this.dotSize = 25,
    this.dotBorderColor = Colors.black54,
    this.padding = const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
    this.enabledColor = Colors.black54,
    this.disabledColor = Colors.transparent,
  });
}

class DotSecretUI extends StatefulWidget {
  final DotSecretConfig config;
  final Stream<int> enteredLengthStream;
  final Stream<bool> validateStream;
  final int dots;

  const DotSecretUI({
    @required this.enteredLengthStream,
    @required this.dots,
    @required this.validateStream,
    this.config = const DotSecretConfig(),
  });

  @override
  _DotSecretUIState createState() => _DotSecretUIState();
}

class _DotSecretUIState extends State<DotSecretUI> with SingleTickerProviderStateMixin {
  Animation<Offset> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // validated stream
    widget.validateStream.listen((valid) {
      if (!valid) {
        // shake animation when invalid
        _animationController.forward();
      }
    });

    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 80));

    _animation = _animationController
        .drive(CurveTween(curve: Curves.elasticIn))
        .drive(Tween<Offset>(begin: Offset.zero, end: const Offset(0.025, 0)))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: widget.config.padding,
        child: StreamBuilder<int>(
          stream: widget.enteredLengthStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  widget.dots,
                  // index less than the input digit is true
                  (index) => _buildCircle(index < snapshot.data),
                ),
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  widget.dots,
                  // index less than the input digit is true
                  (index) => _buildCircle(false),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCircle(bool enabled) {
    return Container(
      width: 33,
      height: widget.config.dotSize * 1.5,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kColorGrey),
        ),
      ),
      child: enabled
          ? const Center(
              child: Text(
              '*',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600),
            ))
          : null,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
