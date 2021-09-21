import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/providers/profile_provider.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profileViewModel = watch(profileProvider);
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/profile_icon.svg',
        ),
        Sizer.halfHorizontal(),
        AutoSizeText(
          profileViewModel.profile?.basicProfile?.name ?? '',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}
