import 'package:flutter/material.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      title: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //final email = snapshot.data!.getString('email');
              return const Text(
                'Welcom Ali Srour',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkBrown,
                ),
              );
            }
            return const Text(
              'Welcom back',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            );
          }),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
