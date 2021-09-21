import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CircleInputButtonConfig {
  // final double fontSize;
  /// default `MediaQuery.of(context).size.width * 0.095`
  final TextStyle textStyle;
  final Color backgroundColor;
  final double backgroundOpacity;
  final ShapeBorder shape;

  const CircleInputButtonConfig({
    this.textStyle,
    this.backgroundColor = const Color(0xFF757575),
    this.backgroundOpacity = 0.4,
    this.shape,
  });
}

class CircleInputButton extends StatelessWidget {
  final CircleInputButtonConfig config;

  final String text;
  final String bottomText;
  final Sink<String> enteredSink;

  const CircleInputButton({
    @required this.text,
    @required this.enteredSink,
    this.bottomText,
    this.config = const CircleInputButtonConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = config.textStyle ??
        const TextStyle(
          fontSize: 36,
        );

    return RaisedButton(
      onPressed: () {
        enteredSink.add(text);
      },
      shape: config.shape ??
          const CircleBorder(
            side: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
      color: const Color(0xffE5E5EA),
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: textStyle,
          ),
          AutoSizeText(
            bottomText ?? '',
            textAlign: TextAlign.center,
            maxFontSize: 10,
            minFontSize: 10,
            maxLines: 1,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, height: 1),
          ),
        ],
      ),
    );
  }
}
