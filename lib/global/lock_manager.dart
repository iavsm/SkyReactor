import 'package:copy_trading/global/preferences.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/shared_widgets/lock_manager/lock_screen.dart';
import 'package:copy_trading/shared_widgets/result_sheet.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LockManager {
  final prefs = locator<Preferences>();
  List<BiometricType> availableBiometrics;

  Future lockApp({
    @required BuildContext context,
    Function onUnlocked,
  }) async {
    if (!prefs.initialized) {
      await prefs.init();
    }
    if (prefs.isLocked && prefs.lockCode != null) {
      if (availableBiometrics == null) {
        final localAuth = LocalAuthentication();
        availableBiometrics = await localAuth.getAvailableBiometrics();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLockScreen(
          context: context,
          correctString: prefs.lockCode,
          canCancel: false,
          dismissable: false,
          title: 'Please enter your code to unlock the app',
          biometricButton: availableBiometrics.contains(BiometricType.face)
              ? const Icon(Icons.face)
              : const Icon(Icons.fingerprint),
          biometricAuthenticate: (context) async {
            final localAuth = LocalAuthentication();
            final didAuthenticate = await localAuth.authenticate(
                localizedReason: 'Please authenticate', biometricOnly: true);

            if (didAuthenticate) {
              return true;
            }

            return false;
          },
          canBiometric: prefs.biometricsEnabled && availableBiometrics.isNotEmpty,
          backgroundColorOpacity: 1,
          onUnlocked: () {
            if (onUnlocked != null) {
              onUnlocked();
            }
          },
        );
      });
    } else {
      if (onUnlocked != null) {
        onUnlocked();
      }
    }
  }

  Future<bool> setupNewCode(BuildContext context) async {
    if (prefs.lockCode == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLockScreen(
          context: context,
          correctString: prefs.lockCode,
          canCancel: false,
          confirmMode: true,
          title: 'Please set a 4-digit PIN to unlock safely & instantly',
          backgroundColorOpacity: 1,
          onCompleted: (context, code) async {
            await prefs.setLockCode(code);
            await prefs.toggleAppLock(locked: true);
            if (prefs.biometricsEnabled != true) {
              showBiometricsSheet(
                  context: context,
                  onPop: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Routes.login);
                  });
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.login);
            }
          },
        );
      });
      return true;
    }
    return false;
  }

  Future disableLock() async {
    return prefs.toggleAppLock(locked: false);
  }

  Future disableBiometrics() async {
    return prefs.toggleBiometrics(value: false);
  }
}
