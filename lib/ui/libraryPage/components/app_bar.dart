import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/ui/auth/constants.dart';


class LibraryPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LibraryPageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Library'),
      backgroundColor: Colors.white,
      centerTitle: true,
      
      titleTextStyle: AppTheme.title_appbar,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
