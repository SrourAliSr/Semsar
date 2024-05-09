import 'package:flutter/material.dart';
import 'package:semsar/Models/get_house.dart';
import 'package:semsar/Models/search_values_model.dart';
import 'package:semsar/pages/real%20estate/real_estate_page.dart';
import 'package:semsar/services/houses/house_services.dart';
import 'package:semsar/widgets/custom_container.dart';
import 'package:semsar/widgets/house_cards.dart';

class HouseList extends StatelessWidget {
  final SearchFilter filters;
  final String searchCity;
  const HouseList({
    super.key,
    required this.filters,
    required this.searchCity,
  });

  @override
  Widget build(BuildContext context) {
    HouseServices services = HouseServices();
    final Size size = MediaQuery.of(context).size;

    Future<List<GetHouse>?> getHouses() async {
      List<GetHouse> houses = [];

      houses = await services.getAllHouses(searchCity, filters);
      return houses;
    }

    return FutureBuilder(
      future: getHouses(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.connectionState == ConnectionState.done) {
          final List<GetHouse> houses = snapshot.data!;

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RealEstatePage(
                            realEstate: houses[index],
                            image: image,
                          ),
                        ),
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
        } else if (snapshot.data?.isEmpty ?? false) {
          return const Center(
            child: Text("There are no houses!"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
