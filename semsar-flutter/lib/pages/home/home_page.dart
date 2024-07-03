import 'dart:async';
import 'package:flutter/material.dart';
import 'package:semsar/Models/search_values_model.dart';
import 'package:semsar/chat/chatpage.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/pages/appbars/main_app_bar.dart';
import 'package:semsar/pages/appbars/search_bar.dart';
import 'package:semsar/pages/home/home_drawer.dart';
import 'package:semsar/pages/home/house_list.dart';
import 'package:semsar/widgets/buttom_nav_bar.dart';
import 'package:semsar/widgets/floating_add_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController controller;

  @override
  void initState() {
    controller = PageController();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: PageView(
          controller: controller,
          children: const [
            _HomePage(key: PageStorageKey('homepage')),
            ChatsPage(
              key: PageStorageKey('chatspage'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingAddButton(),
      bottomNavigationBar: ButtomNavBar(
        changePage: (isNext) {
          if (!isNext) {
            controller.nextPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          } else if (isNext) {
            controller.previousPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          }
        },
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({super.key});

  @override
  State<_HomePage> createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  SearchFilter filterValues = SearchFilter(
    category: 'All',
    stars: null,
    min: null,
    max: null,
  );
  String city = '';

  Timer? searchTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      backgroundColor: const Color.fromARGB(255, 255, 252, 251),
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          const MainAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SearchHomeBar(
                  searchedCity: (searchedCity) {
                    searchTimer?.cancel();

                    searchTimer = Timer(const Duration(milliseconds: 500), () {
                      setState(
                        () {
                          city = searchedCity;
                        },
                      );
                    });
                  },
                  filtered: (filtered) {
                    if (filterValues.category != filtered.category ||
                        (filterValues.min ?? 0.0) != filtered.min ||
                        (filterValues.max ?? 0.0) != filtered.max ||
                        (filterValues.stars ?? 0) != filtered.stars) {
                      setState(() {
                        filterValues = filtered;
                      });
                    }
                  },
                  filter: filterValues,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 18,
                    left: 15,
                    bottom: 10,
                  ),
                  child: Text(
                    'Recent posts:',
                    style: TextStyle(color: AppColors.darkBrown, fontSize: 30),
                  ),
                ),
                HouseList(
                  filters: filterValues,
                  searchCity: city,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
