import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsar/constants/route_names.dart';
import 'package:semsar/services/Authentication/bloc/auth_bloc.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';
import 'package:semsar/services/houses/house_services.dart';
import 'package:semsar/widgets/custom_container.dart';
import 'package:semsar/widgets/house_cards.dart';

class SavedHousesPage extends StatelessWidget {
  const SavedHousesPage({super.key});

  @override
  Widget build(BuildContext context) {
    HouseServices services = HouseServices();

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventNavigateToHomePage());
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Saved pages',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        child: FutureBuilder(
          future: services.getSavedHouses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final houses = snapshot.data ?? [];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: houses.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 410,
                    mainAxisExtent: 340,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Widget image = Container();

                    return CustomContainer(
                      width: (size.width / 2),
                      backgroundColor: const Color.fromARGB(255, 255, 247, 243),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            realStatePageRotes,
                            arguments: {
                              'realEstate': houses[index],
                              'image': image,
                            },
                          );
                        },
                        child: HouseCards(
                          house: houses[index],
                          setImage: (i) {
                            image = i;
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
