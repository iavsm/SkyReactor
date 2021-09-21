import 'package:copy_trading/shared_widgets/phone_input_widget/src/utils/selector_config.dart';
import 'package:copy_trading/shared_widgets/phone_input_widget/src/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_view_model.dart';

class PhoneView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final registerViewModel = watch(registerProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Please enter your contact number",
            textAlign: TextAlign.center,
            style: textTheme.headline4.copyWith(height: 1.6),
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Number',
              style: textTheme.subtitle1.copyWith(fontSize: 13),
            ),
            CustomPhoneNumberInput(
              onInputChanged: (input) {
                registerViewModel.setPhoneNumber(input);
              },
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              spaceBetweenSelectorAndTextField: 0,
              initialValue: registerViewModel.phoneNumber,
              textFieldController: registerViewModel.phoneController,
              scrollPadding: EdgeInsets.zero,
              selectorTextStyle: textTheme.headline4.copyWith(fontSize: 14),
              textStyle: textTheme.headline4.copyWith(fontSize: 14),
              onSubmit: () => registerViewModel.goNextStep(),
              autoFocus: true,
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                setSelectorButtonAsPrefixIcon: true,
              ),
            )
          ],
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}
