import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsar/constants/route_names.dart';
import 'package:semsar/pages/Settings/settings_page.dart';
import 'package:semsar/pages/add%20house/add_house.dart';
import 'package:semsar/pages/add%20house/add_house_photo_viewer.dart';
import 'package:semsar/pages/edit%20house/edit_house.dart';
import 'package:semsar/pages/global/photo_viewer.dart';
import 'package:semsar/pages/home/home_page.dart';
import 'package:semsar/pages/myPosts/my_posts.dart';
import 'package:semsar/pages/real%20estate/real_estate_page.dart';
import 'package:semsar/pages/saved/saved_houses.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:semsar/services/Authentication/bloc/auth_bloc.dart';

class AppRoutes {
  final AuthBloc _authBloc = AuthBloc(Authentication());

  static final AppRoutes _singleton = AppRoutes._internal();

  factory AppRoutes() {
    return _singleton;
  }

  AppRoutes._internal();

  Route? onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case realStatePageRotes:
        final args = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: RealEstatePage(
              realEstate: args['realEstate'],
              image: args['image'],
            ),
          ),
        );
      case editHousePageRotes:
        final args = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: EditHouse(
              oldData: args['oldData'],
              houseMedia: args['houseMedia'],
            ),
          ),
        );
      case photoViewerPageRotes:
        final args = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: PhotoViewerPage(
              images: args['images'],
            ),
          ),
        );
      case addHousePhotoViewerPageRotes:
        final args = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: AddHousePhotoViewer(
              imageFile: args['imageFile'],
              imageBytes: args['imageBytes'],
              iSOwner: args['iSOwner'],
              deleteImage: args['deleteImage'],
            ),
          ),
        );
      case settingsPageRotes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const SettingsPage(),
          ),
        );
      case savedPageRotes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const SavedHousesPage(),
          ),
        );
      case myPostsPageRotes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const MyPostsPage(),
          ),
        );
      case homePageRotes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const HomePage(),
          ),
        );
      case addHousePageRotes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const AddHousePage(),
          ),
        );

      default:
        return null;
    }
  }
}
