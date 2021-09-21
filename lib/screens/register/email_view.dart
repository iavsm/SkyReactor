import 'package:copy_trading/screens/register/register_view_model.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final registerViewModel = watch(registerProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Text(
                "Welcome to LeoPrime’s Copy Trading app!",
                textAlign: TextAlign.center,
                style: textTheme.headline4.copyWith(height: 1.6),
              ),
              Sizer.vertical24(),
              Text(
                'Kindly enter your Email address to register with us.',
                textAlign: TextAlign.center,
                style: textTheme.bodyText2.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
        const Spacer(),
        CustomTextFormField(
          label: 'Email',
          controller: registerViewModel.emailController,
          keyType: TextInputType.emailAddress,
          error: registerViewModel.emailError,
          autoFocus: true,
          onFieldSubmitted: (_) => registerViewModel.goNextStep(),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
