import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/constants/route_names.dart';
import 'package:semsar/constants/user_settings.dart';
import 'package:semsar/services/Authentication/bloc/auth_bloc.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            color: AppColors.orange,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 55, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.cinderella,
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.lightBrown,
                          size: 35,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserSettings.user!.userName,
                            style: const TextStyle(
                              fontSize: 26,
                              color: AppColors.cinderella,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            UserSettings.user!.phoneNumber,
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.cinderella,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Icon(
                        Icons.sunny,
                        size: 45,
                        color: AppColors.cinderella,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<AuthBloc>().add(const AuthEventNavigateToSettings());
            },
            child: const _DrawerItems(
              icon: Icons.settings_outlined,
              text: 'Settings',
            ),
          ),
          GestureDetector(
            onTap: () {
              context
                  .read<AuthBloc>()
                  .add(const AuthEventNavigateToSavedPosts());
            },
            child: const _DrawerItems(
              icon: Icons.star,
              text: 'Saved posts',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                myPostsPageRotes,
              );
            },
            child: const _DrawerItems(
              icon: Icons.portrait_sharp,
              text: 'My posts',
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItems extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DrawerItems({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: Color.fromARGB(89, 207, 207, 207),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.lightBrown,
            size: 35,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 25,
            ),
          )
        ],
      ),
    );
  }
}
