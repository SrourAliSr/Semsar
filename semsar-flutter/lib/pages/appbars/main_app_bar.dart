import 'package:flutter/material.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/constants/user_settings.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: false,
      toolbarHeight: 65,
      surfaceTintColor: AppColors.cinderella,
      backgroundColor: AppColors.cinderella,
      title: Text(
        'Welcom ${UserSettings.user!.userName}',
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: AppColors.darkBrown,
        ),
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
