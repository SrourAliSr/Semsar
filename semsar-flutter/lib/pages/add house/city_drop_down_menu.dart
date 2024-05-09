// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Cities {
  Beirut,
  Tripoli,
  Sidon,
  Tyre,
  Nabatieh,
  Jounieh,
  Zahle,
  Baalbek,
  Byblos,
  Batroun,
  Jbeil,
  Bcharre,
  Aley,
  Chouf,
  Zgharta,
  Anjar,
  BintJbeil,
  Douma,
  Hermel,
  Jezzine,
  Kfarsaroun,
  Machghara,
  Marjayoun,
  Rashaya,
  Sawfar,
  Baakleen,
  Bhamdoun
}

class CityDropDownMenu extends StatefulWidget {
  final void Function(String city) setCity;

  const CityDropDownMenu({super.key, required this.setCity});

  @override
  State<CityDropDownMenu> createState() => _CityDropDownMenuState();
}

class _CityDropDownMenuState extends State<CityDropDownMenu> {
  Cities? city = Cities.Beirut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Choose city:',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            child: DropdownButton<Cities>(
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (result) {
                setState(() {
                  city = result;
                  widget.setCity(city.toString().split('.').last);
                });
              },
              value: city,
              underline: Container(
                height: 0,
              ),
              items: Cities.values.map((city) {
                return DropdownMenuItem<Cities>(
                  value: city,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      city.toString().split('.').last,
                      style: const TextStyle(
                        fontSize: 23,
                        color: Color.fromARGB(255, 42, 42, 42),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
