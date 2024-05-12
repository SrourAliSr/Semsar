import 'package:flutter/material.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/constants/route_names.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.orange,
        child: const Icon(
          Icons.add,
          size: 45,
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            addHousePageRotes,
          );
        },
      ),
    );
  }
}
