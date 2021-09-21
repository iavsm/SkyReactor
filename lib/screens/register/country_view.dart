import 'package:copy_trading/screens/register/register_view_model.dart';
import 'package:copy_trading/shared_widgets/selection_field.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final registerViewModel = watch(registerProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Please select your country and state of residence",
            textAlign: TextAlign.center,
            style: textTheme.headline4.copyWith(height: 1.6),
          ),
        ),
        const Spacer(),
        SelectionField(
          choices: registerViewModel.countries.map((country) => country.name).toList(),
          title: 'Country',
          controller: registerViewModel.countryController,
          error: registerViewModel.countryError,
          selectedIndex: (index) {
            registerViewModel.setCountry(registerViewModel.countries[index]);
          },
        ),
        const Sizer(),
        SelectionField(
          choices: registerViewModel
                  .states[registerViewModel.selectedCountry ?? registerViewModel.countries.first]
                  ?.map((e) => e.name)
                  ?.toList() ??
              [],
          title: 'State',
          loading: registerViewModel.statesLoading,
          controller: registerViewModel.stateController,
          error: registerViewModel.stateError,
          selectedIndex: (index) {
            registerViewModel.setSelectedState(
                registerViewModel.states[registerViewModel.selectedCountry][index]);
          },
        ),
        const Spacer(flex: 3),
        Flexible(
          child: Text(
            'I hereby declare that I have carefully read & accept the entire Privacy Policy, Risk Disclosure, AML Policy, Security, Legal Document, Terms & Conditions of LeoPrime Copy-trading services, and thereby agree to open my account.',
            textAlign: TextAlign.center,
            style: textTheme.subtitle1.copyWith(fontSize: 11, height: 1.4),
          ),
        ),
      ],
    );
  }
}
