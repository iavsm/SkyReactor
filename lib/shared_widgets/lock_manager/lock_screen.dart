import 'dart:async';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'circle_input_button.dart';
import 'dot_secret_ui.dart';

Future showConfirmPasscode({
  @required BuildContext context,
  String title = 'Please enter passcode.',
  String confirmTitle = 'Please enter confirm passcode.',
  String cancelText = 'Cancel',
  String deleteText = 'Delete',
  int digits = 4,
  DotSecretConfig dotSecretConfig = const DotSecretConfig(),
  void Function(BuildContext, String) onCompleted,
  Color backgroundColor = Colors.white,
  double backgroundColorOpacity = 0.5,
  CircleInputButtonConfig circleInputButtonConfig = const CircleInputButtonConfig(),
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secodaryAnimation,
      ) {
        return LockScreen(
          title: title,
          confirmTitle: confirmTitle,
          confirmMode: true,
          digits: digits,
          dotSecretConfig: dotSecretConfig,
          onCompleted: onCompleted,
          cancelText: cancelText,
          deleteText: deleteText,
          backgroundColor: backgroundColor,
          backgroundColorOpacity: backgroundColorOpacity,
          circleInputButtonConfig: circleInputButtonConfig,
        );
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 2.4),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, 2.4),
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      },
    ),
  );
}

Future showLockScreen({
  @required BuildContext context,
  String correctString,
  String title = 'Please enter passcode.',
  String cancelText = 'Cancel',
  String deleteText = 'Delete',
  int digits = 4,
  DotSecretConfig dotSecretConfig = const DotSecretConfig(),
  bool confirmMode = false,
  bool canCancel = true,
  bool dismissable = true,
  void Function(BuildContext, String) onCompleted,
  Widget biometricButton = const Icon(Icons.fingerprint),
  bool canBiometric = false,
  bool showBiometricFirst = false,
  Future<bool> Function(BuildContext) biometricAuthenticate,
  Color backgroundColor = Colors.white,
  double backgroundColorOpacity = 0.5,
  CircleInputButtonConfig circleInputButtonConfig = const CircleInputButtonConfig(),
  void Function() onUnlocked,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secodaryAnimation,
      ) {
        final _showBiometricFirstController = StreamController<void>();

        animation.addStatusListener((status) {
          // Calling the biometric on completion of the animation.
          if (status == AnimationStatus.completed) {
            _showBiometricFirstController.add(null);
          }
        });

        return LockScreen(
          correctString: correctString,
          title: title,
          digits: digits,
          dotSecretConfig: dotSecretConfig,
          onCompleted: onCompleted,
          confirmMode: confirmMode,
          canCancel: canCancel,
          cancelText: cancelText,
          deleteText: deleteText,
          dismissable: dismissable,
          biometricButton: biometricButton,
          canBiometric: canBiometric,
          showBiometricFirst: showBiometricFirst,
          showBiometricFirstController: _showBiometricFirstController,
          biometricAuthenticate: biometricAuthenticate,
          backgroundColor: backgroundColor,
          backgroundColorOpacity: backgroundColorOpacity,
          circleInputButtonConfig: circleInputButtonConfig,
          onUnlocked: onUnlocked,
        );
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 2.4),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, 2.4),
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      },
    ),
  );
}

class LockScreen extends StatefulWidget {
  final String correctString;
  final String title;
  final String confirmTitle;
  final bool confirmMode;
  final bool dismissable;
  final Widget rightSideButton;
  final int digits;
  final DotSecretConfig dotSecretConfig;
  final CircleInputButtonConfig circleInputButtonConfig;
  final bool canCancel;
  final String cancelText;
  final String deleteText;
  final Widget biometricButton;
  final void Function(BuildContext, String) onCompleted;
  final bool canBiometric;
  final bool showBiometricFirst;
  final Future<bool> Function(BuildContext) biometricAuthenticate;
  final StreamController<void> showBiometricFirstController;
  final Color backgroundColor;
  final double backgroundColorOpacity;
  final void Function() onUnlocked;

  const LockScreen({
    this.correctString,
    this.dismissable = true,
    this.title = 'Please enter passcode.',
    this.confirmTitle = 'Re-enter your PIN',
    this.confirmMode = false,
    this.digits = 4,
    this.dotSecretConfig = const DotSecretConfig(),
    this.circleInputButtonConfig = const CircleInputButtonConfig(),
    this.rightSideButton,
    this.canCancel = true,
    this.cancelText,
    this.deleteText,
    this.biometricButton = const Icon(Icons.fingerprint),
    this.onCompleted,
    this.canBiometric = false,
    this.showBiometricFirst = false,
    this.biometricAuthenticate,
    this.showBiometricFirstController,
    this.backgroundColor = Colors.white,
    this.backgroundColorOpacity = 0.5,
    this.onUnlocked,
  });

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  // receive from circle input button
  final StreamController<String> enteredStream = StreamController<String>();
  final StreamController<void> removedStreamController = StreamController<void>();
  final StreamController<int> enteredLengthStream = StreamController<int>.broadcast();
  final StreamController<bool> validateStreamController = StreamController<bool>();

  // control for Android back button
  bool _needClose = false;

  // confirm flag
  bool _isConfirmation = false;

  // confirm verify passcode
  String _verifyConfirmPasscode = '';

  List<String> enteredValues = <String>[];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (widget.showBiometricFirst) {
      if (widget.biometricAuthenticate != null) {
        // Set the listener if there is a stream option.
        if (widget.showBiometricFirstController != null) {
          widget.showBiometricFirstController.stream.listen((_) {
            widget.biometricAuthenticate(context).then((unlocked) {
              if (unlocked) {
                Navigator.of(context).pop();

                if (widget.onUnlocked != null) {
                  widget.onUnlocked();
                }
              }
            });
          });
        } else {
          // It is executed by a certain time.
          Future.delayed(
            const Duration(milliseconds: 350),
            () {
              widget.biometricAuthenticate(context).then((unlocked) {
                if (unlocked) {
                  Navigator.pop(context);

                  if (widget.onUnlocked != null) {
                    widget.onUnlocked();
                  }
                }
              });
            },
          );
        }
      }
    }
  }

  void _removedStreamListener() {
    if (removedStreamController.hasListener) {
      return;
    }

    removedStreamController.stream.listen((_) {
      if (enteredValues.isNotEmpty) {
        enteredValues.removeLast();
      }

      enteredLengthStream.add(enteredValues.length);
    });
  }

  void _enteredStreamListener() {
    if (enteredStream.hasListener) {
      return;
    }

    enteredStream.stream.listen((value) {
      // add list entered value
      enteredValues.add(value);
      enteredLengthStream.add(enteredValues.length);

      // the same number of digits was entered.
      if (enteredValues.length == widget.digits) {
        final buffer = StringBuffer();
        enteredValues.forEach((value) {
          buffer.write(value);
        });
        _verifyCorrectString(buffer.toString());
      }
    });
  }

  void _verifyCorrectString(String enteredValue) {
    Future.delayed(const Duration(milliseconds: 150), () {
      var _verifyPasscode = widget.correctString;

      if (widget.confirmMode) {
        if (_isConfirmation == false) {
          _verifyConfirmPasscode = enteredValue;
          enteredValues.clear();
          enteredLengthStream.add(enteredValues.length);
          _isConfirmation = true;
          setState(() {});
          return;
        }
        _verifyPasscode = _verifyConfirmPasscode;
      }

      if (enteredValue == _verifyPasscode) {
        // send valid status to DotSecretUI
        validateStreamController.add(true);
        enteredValues.clear();
        enteredLengthStream.add(enteredValues.length);

        if (widget.onCompleted != null) {
          // call user function
          widget.onCompleted(context, enteredValue);
        } else {
          _needClose = true;
          Navigator.pop(context);
        }

        if (widget.onUnlocked != null) {
          widget.onUnlocked();
        }
      } else {
        // send invalid status to DotSecretUI
        validateStreamController.add(false);
        enteredValues.clear();
        enteredLengthStream.add(enteredValues.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _enteredStreamListener();
    _removedStreamListener();
    final _rowMarginSize = MediaQuery.of(context).size.width * 0.025;
    final _columnMarginSize = MediaQuery.of(context).size.width * 0.065;

    return WillPopScope(
      onWillPop: () async {
        if (_needClose || widget.canCancel) {
          return true;
        }

        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: widget.backgroundColor.withOpacity(widget.backgroundColorOpacity),
          body: SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTitle(),
                  DotSecretUI(
                    validateStream: validateStreamController.stream,
                    dots: widget.digits,
                    config: widget.dotSecretConfig,
                    enteredLengthStream: enteredLengthStream.stream,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _columnMarginSize,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: _rowMarginSize),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildNumberTextButton(context, '1', null),
                              _buildNumberTextButton(context, '2', 'A B C'),
                              _buildNumberTextButton(context, '3', 'D E F'),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: _rowMarginSize),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildNumberTextButton(context, '4', 'G H I'),
                              _buildNumberTextButton(context, '5', 'J K L'),
                              _buildNumberTextButton(context, '6', 'M N O'),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: _rowMarginSize),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildNumberTextButton(context, '7', 'P Q R S'),
                              _buildNumberTextButton(context, '8', 'T U V'),
                              _buildNumberTextButton(context, '9', 'W X Y Z'),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: _rowMarginSize),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildBothSidesButton(context, _biometricButton()),
                              _buildNumberTextButton(context, '0', null),
                              _buildBothSidesButton(context, _rightSideButton()),
                            ],
                          ),
                        ),
                        if (widget.dismissable) ...[
                          Sizer.vertical24(),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Do it later',
                                style: TextStyle(fontSize: 15),
                              )),
                        ],
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTextButton(
    BuildContext context,
    String number,
    String bottomText,
  ) {
    final buttonSize = MediaQuery.of(context).size.width * 0.215;
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: CircleInputButton(
        enteredSink: enteredStream.sink,
        text: number,
        bottomText: bottomText,
        config: widget.circleInputButtonConfig,
      ),
    );
  }

  Widget _buildBothSidesButton(BuildContext context, Widget button) {
    final buttonSize = MediaQuery.of(context).size.width * 0.215;
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: button,
    );
  }

  Widget _buildTitle() {
    return Flexible(
      flex: 3,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5),
        child: AutoSizeText(
          _isConfirmation ? widget.confirmTitle : widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _biometricButton() {
    if (!widget.canBiometric || widget.dismissable) return Container();

    return FlatButton(
      padding: const EdgeInsets.all(0.0),
      onPressed: () {
        // Maintain compatibility
        if (widget.biometricAuthenticate == null) {
          throw Exception('specify biometricFunction or biometricAuthenticate.');
        } else {
          if (widget.biometricAuthenticate != null) {
            widget.biometricAuthenticate(context).then((unlocked) {
              if (unlocked) {
                Navigator.pop(context);

                if (widget.onUnlocked != null) {
                  widget.onUnlocked();
                }
              }
            });
          }
        }
      },
      shape: const CircleBorder(
        side: BorderSide(
          color: Colors.transparent,
        ),
      ),
      color: Colors.transparent,
      child: widget.biometricButton,
    );
  }

  Widget _rightSideButton() {
    if (widget.rightSideButton != null) return widget.rightSideButton;

    return StreamBuilder<int>(
        stream: enteredLengthStream.stream,
        builder: (context, snapshot) {
          String buttonText;
          if (snapshot.hasData && snapshot.data > 0) {
            buttonText = widget.deleteText;
          } else if (widget.canCancel) {
            buttonText = widget.cancelText;
          } else {
            return Container();
          }

          return FlatButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (snapshot.hasData && snapshot.data > 0) {
                removedStreamController.sink.add(null);
              } else {
                if (widget.canCancel) {
                  _needClose = true;
                  Navigator.of(context).maybePop();
                }
              }
            },
            shape: const CircleBorder(
              side: BorderSide(
                color: Colors.transparent,
              ),
            ),
            color: Colors.transparent,
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 16,
              ),
              softWrap: false,
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  @override
  void dispose() {
    enteredStream.close();
    enteredLengthStream.close();
    validateStreamController.close();
    removedStreamController.close();
    if (widget.showBiometricFirstController != null) {
      widget.showBiometricFirstController.close();
    }

    // restore orientation.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }
}
