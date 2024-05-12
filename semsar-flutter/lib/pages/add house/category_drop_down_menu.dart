// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:semsar/constants/app_colors.dart';

enum Categories {
  Casual,
  Villa,
  Hotel,
  Bongalo,
}

class CategoryDropDownMenu extends StatefulWidget {
  final void Function(String category) setCategory;

  const CategoryDropDownMenu({super.key, required this.setCategory});

  @override
  State<CategoryDropDownMenu> createState() => _CategoryDropDownMenuState();
}

class _CategoryDropDownMenuState extends State<CategoryDropDownMenu> {
  Categories? category;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Categories>(
      icon: const Icon(Icons.arrow_drop_down),
      hint: const Text(
        'Category',
        style: TextStyle(
          fontSize: 23,
          color: AppColors.lightBrown,
        ),
      ),
      onChanged: (result) {
        setState(() {
          category = result;
          widget.setCategory(category.toString().split('.').last);
        });
      },
      value: category,
      underline: Container(
        height: 0,
      ),
      items: Categories.values.map((category) {
        return DropdownMenuItem<Categories>(
          value: category,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category.toString().split('.').last,
              style: const TextStyle(
                fontSize: 23,
                color: Color.fromARGB(255, 42, 42, 42),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
