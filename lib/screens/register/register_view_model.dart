import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/global/lock_manager.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/country.dart';
import 'package:copy_trading/models/register_input.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:copy_trading/shared_widgets/phone_input_widget/intl_phone_number_input.dart';
import 'package:copy_trading/shared_widgets/result_sheet.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RegisterSteps { email, mobile, name, country, emailOtp, phoneOtp }

final registerProvider = ChangeNotifierProvider.autoDispose((ref) => RegisterViewModel());

class RegisterViewModel extends DefaultChangeNotifier {
  final api = locator<ApiExporter>();
  final lockManager = locator<LockManager>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController emailOTPController = TextEditingController();
  final TextEditingController phoneOTPController = TextEditingController();

  final FocusNode firstNameNode = FocusNode();
  final FocusNode lastNameNode = FocusNode();

  String emailError, firstNameError, lastNameError, countryError, stateError;

  final List<RegistrationCountry> countries = [];
  final Map<RegistrationCountry, List<RegistrationState>> states = {};
  RegistrationCountry selectedCountry;
  RegistrationState selectedState;
  bool statesLoading = false;

  PhoneNumber phoneNumber;

  int currentStepIndex = 0;

  final int otpLength = 6;

  static const List<RegisterSteps> steps = [
    RegisterSteps.email,
    RegisterSteps.mobile,
    RegisterSteps.name,
    RegisterSteps.country,
    RegisterSteps.emailOtp,
    RegisterSteps.phoneOtp,
  ];

  RegisterViewModel() {
    getCountries();
    if (kDebugMode) {
      firstNameController.text = 'test';
      lastNameController.text = 'test';
    }
  }

  Future register(BuildContext context) async {
    final input = RegisterInput(
      email: emailController.text,
      countryCode: phoneNumber.dialCode.substring(1),
      phone: phoneNumber.phoneNumber.substring(1),
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      emailOtp: emailOTPController.text,
      phoneOtp: phoneOTPController.text,
      countryId: selectedCountry.id,
      stateId: selectedState.id,
    );

    try {
      toggleLoadingOn(true);
      await api.register(input);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future requestOtp({bool resend = false}) async {
    if (emailController.text.isNotEmpty && phoneNumber != null) {
      try {
        toggleLoadingOn(true);
        await api.requestOtp(email: emailController.text, phone: phoneNumber);
        currentStepIndex = steps.indexOf(RegisterSteps.emailOtp);
        if (resend) {
          errorMessage = 'A new code has been sent to you';
        }
      } catch (e) {
        if (e is String) {
          currentStepIndex = 0;
          errorMessage = e;
        } else {
          currentStepIndex = steps.indexOf(RegisterSteps.emailOtp);
        }
      } finally {
        toggleLoadingOn(false);
      }
    }
  }

  bool validateStep() {
    clearErrors();
    switch (steps[currentStepIndex]) {
      case RegisterSteps.email:
        if (!emailController.text.isValidEmail()) {
          emailError = 'Please insert valid email';
        }
        return emailError == null;
        break;
      case RegisterSteps.mobile:
        return true;
        break;
      case RegisterSteps.name:
        if (firstNameController.text.isEmpty) {
          firstNameError = 'Please insert first name';
        }
        if (lastNameController.text.isEmpty) {
          lastNameError = 'Please insert last name';
        }
        return firstNameError == null && lastNameError == null;
        break;
      case RegisterSteps.country:
        if (selectedCountry == null) {
          countryError = 'Please select your country';
        }
        if (selectedState == null) {
          stateError = 'Please select your state';
        }
        return countryError == null && stateError == null;
        break;
      case RegisterSteps.emailOtp:
        return emailOTPController.text.length == otpLength;
        break;
      case RegisterSteps.phoneOtp:
        return phoneOTPController.text.length == otpLength;
        break;
      default:
        return false;
        break;
    }
  }

  void clearErrors() {
    emailError = null;
    countryError = null;
    stateError = null;
    firstNameError = null;
    lastNameError = null;
  }

  Future<bool> goNextStep({BuildContext context}) async {
    if (validateStep()) {
      if (currentStepIndex < (steps.length - 1)) {
        if (currentStepIndex == steps.indexOf(RegisterSteps.country)) {
          requestOtp();
        } else {
          currentStepIndex++;
          notifyListeners();
        }
      } else if (currentStepIndex == steps.length - 1) {
        await register(context);
        return errorMessage == null;
      }
    } else {
      notifyListeners();
    }
    return false;
  }

  void goPreviousStep() {
    if (currentStepIndex > 0) {
      currentStepIndex--;
      notifyListeners();
    }
  }

  // ignore: use_setters_to_change_properties
  void setPhoneNumber(PhoneNumber number) {
    phoneNumber = number;
  }

  Future getCountries() async {
    final List<RegistrationCountry> countries = await api.getCountries();
    this.countries.clear();
    this.countries.addAll(countries);
  }

  Future getStates() async {
    if (selectedCountry != null) {
      if (states[selectedCountry] == null) {
        states[selectedCountry] = [];
      }
      if (states[selectedCountry].isEmpty) {
        statesLoading = true;
        notifyListeners();
        states[selectedCountry] = await api.getStates(selectedCountry.id);
        statesLoading = false;
        notifyListeners();
      } else {
        notifyListeners();
      }
    }
  }

  void setCountry(RegistrationCountry country) {
    countryError = null;
    countryController.text = country.name;
    selectedCountry = country;
    stateController.text = '';
    stateError = null;
    selectedState = null;
    getStates();
  }

  void setSelectedState(RegistrationState state) {
    stateError = null;
    stateController.text = state.name;
    selectedState = state;
    notifyListeners();
  }

  void displaySuccessSheet(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    showSuccessSheet(
        context: context,
        details: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textTheme.bodyText2,
            children: [
              const TextSpan(text: 'Your account has been\n'),
              TextSpan(
                  text: 'Successfully', style: textTheme.bodyText2.copyWith(color: kColorAccent)),
              const TextSpan(text: ' created.'),
            ],
          ),
        ),
        onConfirm: () async {
          final bool willShowLock = await presentAppLockEntry(context);
          if (!willShowLock) {
            Navigator.pop(context);
          }
        });
  }

  Future<bool> presentAppLockEntry(BuildContext context) async {
    final bool willShow = await lockManager.setupNewCode(context);
    return willShow;
  }
}
