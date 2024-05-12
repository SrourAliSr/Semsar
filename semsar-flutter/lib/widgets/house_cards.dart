import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:semsar/Models/get_house.dart';
import 'package:semsar/constants/app_colors.dart';

class HouseCards extends StatelessWidget {
  final GetHouse house;
  final void Function(Widget) setImage;
  const HouseCards({
    super.key,
    required this.house,
    required this.setImage,
  });

  Future<Widget> _loadImages(String imageData) async {
    final Uint8List imageBytes = await Isolate.run(
      () => base64.decode(
        imageData,
      ),
    );
    Widget i = Image.memory(
      imageBytes,
      width: double.infinity,
      fit: BoxFit.cover,
    );
    Widget heroImage = Hero(
      tag: house.houseDetails.housesId.toString(),
      child: Image.memory(
        imageBytes,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
    setImage(i);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: heroImage,
    );
  }

  Widget _properties(String property) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(144, 253, 234, 221),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cinderella,
            Color.fromARGB(255, 255, 229, 212),
            Color.fromARGB(255, 252, 217, 195),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          property,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.darkBrown,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
            future: _loadImages(
              house.houseMedia.media,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data!;
              }
              return const SizedBox(
                width: double.infinity,
                height: 80,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              _properties(house.houseDetails.city),
              const SizedBox(
                width: 10,
              ),
              _properties(house.houseDetails.category),
              const SizedBox(
                width: 10,
              ),
              if (house.houseDetails.category == 'Hotel')
                _properties('${house.houseDetails.rating.round()} stars'),
              if (house.houseDetails.category == 'Hotel')
                const SizedBox(
                  width: 10,
                ),
              if (house.houseDetails.isForRent) _properties('For Rent'),
              if (house.houseDetails.isForRent)
                const SizedBox(
                  width: 10,
                ),
              if (house.houseDetails.isForSale) _properties('For Sale')
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '\$ ${house.houseDetails.price.round()}',
            style: const TextStyle(
              fontSize: 23,
              color: AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }
}
