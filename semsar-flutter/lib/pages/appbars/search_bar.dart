// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:semsar/Models/search_values_model.dart';
import 'package:semsar/constants/app_colors.dart';

enum Categories {
  All,
  Casual,
  Villa,
  Hotel,
  Bongalo,
}

class SearchHomeBar extends StatefulWidget {
  final SearchFilter filter;
  final void Function(String searchedCity) searchedCity;
  final void Function(
    SearchFilter filteredValues,
  ) filtered;
  const SearchHomeBar({
    super.key,
    required this.searchedCity,
    required this.filtered,
    required this.filter,
  });

  @override
  State<SearchHomeBar> createState() => _SearchHomeBarState();
}

class _SearchHomeBarState extends State<SearchHomeBar> {
  late TextEditingController searchedText;
  bool isTyped = false;

  Categories getCategoryFromString(String categoryString) {
    for (var c in Categories.values) {
      if (c.toString().split('.').last.toLowerCase() ==
          categoryString.toLowerCase()) {
        return c;
      }
    }
    return Categories.All;
  }

  Future<SearchFilter?> filterSearch(BuildContext context) async {
    Completer<SearchFilter?> completer = Completer();

    return await showModalBottomSheet<SearchFilter>(
      context: context,
      builder: (BuildContext context) {
        return _FilterBottomSheet(
          initCategory: getCategoryFromString(widget.filter.category!),
          initStars: widget.filter.stars ?? 0,
          initMin: widget.filter.min,
          initMax: widget.filter.max,
          setValues: (c, star, min, max) {
            SearchFilter s = SearchFilter(
              category: c.toString().split('.').last,
              stars: star,
              min: min,
              max: max,
            );
            completer.complete(s);
          },
        );
      },
    ).then((value) {
      return completer.future;
    });
  }

  @override
  void initState() {
    searchedText = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    isTyped = false;
    searchedText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cinderella,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 60,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    onChanged: (value) {
                      widget.searchedCity(value);
                      if (searchedText.text.isNotEmpty && isTyped == false) {
                        setState(() {
                          isTyped = true;
                        });
                      }
                      if (searchedText.text.isEmpty && isTyped == true) {
                        setState(() {
                          isTyped = false;
                        });
                      }
                    },
                    controller: searchedText,
                    decoration: InputDecoration(
                      hintText: 'Search for city',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                (isTyped)
                    ? IconButton(
                        onPressed: () {
                          searchedText.clear();
                          widget.searchedCity('');
                          setState(() {
                            isTyped = false;
                          });
                        },
                        icon: const Icon(
                          Icons.cancel_sharp,
                          size: 30,
                          color: AppColors.darkBrown,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Container(
            height: 57,
            width: 55,
            decoration: BoxDecoration(
              color: AppColors.lightBrown,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () async {
                final filteredFields = await filterSearch(context);

                if (filteredFields != null) {
                  widget.filtered(filteredFields);
                }
              },
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: AppColors.cinderella,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final Categories initCategory;
  final int initStars;
  final double? initMin;
  final double? initMax;
  final void Function(Categories c, int s, double min, double max) setValues;

  const _FilterBottomSheet({
    required this.initCategory,
    required this.initStars,
    required this.setValues,
    required this.initMin,
    required this.initMax,
  });
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late Categories selectedCategory;
  late int selectedStars;
  late TextEditingController min;
  late TextEditingController max;

  @override
  void initState() {
    selectedCategory = widget.initCategory;
    selectedStars = widget.initStars;
    min = TextEditingController(
        text: (widget.initMin == 0.0) ? '' : widget.initMin?.toString() ?? '');
    max = TextEditingController(
        text: (widget.initMax == 0.0) ? '' : widget.initMax?.toString() ?? '');
    super.initState();
  }

  @override
  void dispose() {
    widget.setValues(
      selectedCategory,
      selectedStars,
      (min.text.isNotEmpty) ? double.parse(min.text) : 0,
      (max.text.isNotEmpty) ? double.parse(max.text) : 0,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Price: ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: min,
                      decoration: InputDecoration(
                        label: const Text('Min'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 122, 122, 122),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: max,
                      decoration: InputDecoration(
                        label: const Text('max'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 122, 122, 122),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Category: ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: Categories.values
                    .map(
                      (category) => GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              selectedCategory = category;
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(0.5)),
                            color: (selectedCategory == category)
                                ? AppColors.orange
                                : const Color.fromARGB(255, 240, 240, 240),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Text(
                              category.toString().split('.').last,
                              style: const TextStyle(fontSize: 21),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Stars: ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...List.generate(
                    7,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              selectedStars = index;
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(0.5)),
                            color: (selectedStars == index)
                                ? AppColors.orange
                                : const Color.fromARGB(255, 240, 240, 240),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Text(
                              (index > 0) ? '${index - 1} Stars' : 'All',
                              style: const TextStyle(fontSize: 21),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
