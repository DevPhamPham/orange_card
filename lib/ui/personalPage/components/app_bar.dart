import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/ui/auth/constants.dart';


class PersionalPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PersionalPageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Persional'),
      backgroundColor: kPrimaryColor,
      titleTextStyle: AppTheme.title_appbar,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
