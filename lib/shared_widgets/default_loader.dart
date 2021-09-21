import 'package:flutter/material.dart';

class DefaultLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class LightLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 30,
      height: 30,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
