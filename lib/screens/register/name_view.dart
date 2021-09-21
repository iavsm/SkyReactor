import 'package:copy_trading/screens/register/register_view_model.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NameView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final registerViewModel = watch(registerProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Please provide your identity",
            textAlign: TextAlign.center,
            style: textTheme.headline4.copyWith(height: 1.6),
          ),
        ),
        const Spacer(),
        CustomTextFormField(
          label: 'First Name',
          controller: registerViewModel.firstNameController,
          node: registerViewModel.firstNameNode,
          error: registerViewModel.firstNameError,
          autoFocus: true,
          onFieldSubmitted: (_) {
            registerViewModel.lastNameNode.requestFocus();
          },
        ),
        const Sizer(),
        CustomTextFormField(
          label: 'Last Name',
          controller: registerViewModel.lastNameController,
          node: registerViewModel.lastNameNode,
          error: registerViewModel.lastNameError,
          onFieldSubmitted: (_) => registerViewModel.goNextStep(),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
