import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final Function onDismiss;
  final String error;

  const ErrorDialog({Key key, @required this.onDismiss, @required this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDismiss(),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: SimpleDialog(
          title: Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          titlePadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
