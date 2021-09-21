import 'package:copy_trading/api/core/api_links.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/screens/login/login_view_model.dart';
import 'package:copy_trading/shared_widgets/call_to_action_button.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:copy_trading/shared_widgets/error_dialog.dart';
import 'package:copy_trading/shared_widgets/light_app_bar.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final loginViewModel = watch(loginProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: const LightAppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Sizer.vertical32(),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Column(
                      children: [
                        AspectRatio(aspectRatio: 2.5, child: Image.asset('assets/images/logo.png')),
                        const Sizer(),
                        GestureDetector(
                          onLongPress: () {
                            final ApiLinks apiLinks = locator<ApiLinks>();
                            apiLinks.isStaging = !apiLinks.isStaging;
                            showDialog(
                              context: context,
                              builder: (_) => SimpleDialog(
                                children: [
                                  Text(
                                    'You have switched to ${apiLinks.isStaging ? 'Staging API' : 'Production API'}',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                          child: AspectRatio(
                              aspectRatio: 1.2,
                              child: SvgPicture.asset('assets/images/login_icon.svg')),
                        ),
                      ],
                    ),
                  ),
                  const Sizer(),
                  CustomTextFormField(
                    label: 'Email ID',
                    controller: loginViewModel.emailController,
                    node: loginViewModel.emailNode,
                    keyType: TextInputType.emailAddress,
                    error: loginViewModel.emailError,
                    onFieldSubmitted: (_) {
                      loginViewModel.passwordNode.requestFocus();
                    },
                  ),
                  Sizer.vertical32(),
                  CustomTextFormField(
                    label: 'Password',
                    controller: loginViewModel.passwordController,
                    node: loginViewModel.passwordNode,
                    keyType: TextInputType.visiblePassword,
                    error: loginViewModel.passwordError,
                    suffixIcon: GestureDetector(
                      onTap: () => loginViewModel.toggleShowPassword(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Icon(
                          Icons.remove_red_eye_sharp,
                          size: 18,
                          color: loginViewModel.passwordShowing ? kColorAccent : kColorGrey,
                        ),
                      ),
                    ),
                    obscure: !loginViewModel.passwordShowing,
                    onFieldSubmitted: (_) {
                      loginViewModel.login(context);
                    },
                  ),
                  Sizer.half(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.forgotPassword),
                      child: Text(
                        'Forgot Password',
                        style: textTheme.bodyText2.copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                  Sizer.vertical32(),
                  CallToActionButton(
                      title: 'Sign In',
                      loading: loginViewModel.loading,
                      onPressed: () {
                        loginViewModel.login(context);
                      }),
                  const Sizer(),
                  Text(
                    'Don’t have an account yet? Create your own profile & kick-start your journey',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText2.copyWith(fontSize: 12),
                  ),
                  Sizer.qtr(),
                  GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.register),
                      child: Text(
                        'Register',
                        style:
                            textTheme.headline6.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                      )),
                  Sizer.vertical48(),
                ],
              ),
            ),
          ),
          if (loginViewModel.errorMessage != null) ...[
            ErrorDialog(
              onDismiss: () {
                loginViewModel.setErrorMessage(null);
              },
              error: loginViewModel.errorMessage,
            ),
          ]
        ],
      ),
    );
  }
}
