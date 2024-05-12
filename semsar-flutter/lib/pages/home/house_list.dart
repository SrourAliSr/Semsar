import 'package:flutter/material.dart';
import 'package:semsar/Models/get_house.dart';
import 'package:semsar/Models/search_values_model.dart';
import 'package:semsar/constants/route_names.dart';
import 'package:semsar/services/houses/house_services.dart';
import 'package:semsar/widgets/custom_container.dart';
import 'package:semsar/widgets/house_cards.dart';
import 'package:shimmer/shimmer.dart';

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

    return FutureBuilder(
      future: services.getAllHouses(searchCity, filters),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.connectionState == ConnectionState.done &&
            snapshot.data!.isNotEmpty) {
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
        } else if ((snapshot.data == null ||
                (snapshot.data != null && snapshot.data!.isEmpty)) &&
            searchCity != '') {
          return const SizedBox(
            height: 300,
            child: Center(
              child: Text(
                "There is nothing at this location!",
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
            ),
          );
        }
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Shimmer.fromColors(
            baseColor:
                const Color.fromARGB(255, 197, 197, 197).withOpacity(0.8),
            highlightColor:
                const Color.fromARGB(255, 190, 190, 190).withOpacity(0.2),
            child: ListView(
              children: [
                ...List.generate(
                  5,
                  (index) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(7)),
                          child: const _ContentPlaceholder(),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContentPlaceholder extends StatelessWidget {
  const _ContentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 350,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 225,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ...List.generate(3, (index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(144, 253, 234, 221),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: 40,
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  Container(
                    width: 125,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 20),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
