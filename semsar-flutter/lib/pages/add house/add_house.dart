import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semsar/Models/add_new_house_model.dart';
import 'package:semsar/pages/add%20house/category_drop_down_menu.dart';
import 'package:semsar/pages/add%20house/city_drop_down_menu.dart';
import 'package:semsar/services/houses/house_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHousePage extends StatefulWidget {
  const AddHousePage({super.key});

  @override
  State<AddHousePage> createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  HouseServices services = HouseServices();

  TextEditingController price = TextEditingController();

  TextEditingController details = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();

  TextEditingController houseName = TextEditingController();

  List<String> houseMedia = [];

  List<File> houseMediaFiles = [];

  String category = 'Casual';

  String city = 'Beirut';

  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: AppBar(
            title: const Text(
              'Add new house',
            ),
            backgroundColor: Colors.amber,
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: 'Price',
                      ),
                    ),
                    TextField(
                      controller: details,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: 'Details',
                      ),
                    ),
                    TextField(
                      controller: phoneNumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: 'Phone Number',
                      ),
                    ),
                    TextField(
                      controller: houseName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: 'The name of the building',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CategoryDropDownMenu(
                setCategory: (c) {
                  setState(
                    () {
                      category = c;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CityDropDownMenu(
                setCity: (c) {
                  setState(() {
                    city = c;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: houseMedia.length + 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (index == houseMedia.length) {
                        return GestureDetector(
                          onTap: () async {
                            final imageMedia = await ImagePicker().pickMedia(
                              imageQuality: 70,
                            );
                            if (imageMedia != null) {
                              final imageFile = File(imageMedia.path);
                              final croppedImage =
                                  await ImageCropper().cropImage(
                                sourcePath: imageFile.path,
                                aspectRatio: const CropAspectRatio(
                                  ratioX: 16,
                                  ratioY: 9,
                                ),
                                compressQuality: 50,
                              );

                              if (croppedImage != null) {
                                final imageBytes =
                                    await croppedImage.readAsBytes();
                                houseMedia.add(
                                  base64Encode(imageBytes),
                                );
                                setState(() {
                                  houseMediaFiles.add(
                                    File(
                                      croppedImage.path,
                                    ),
                                  );
                                });
                              }
                            }
                          },
                          child: Container(
                            color: Colors.grey,
                            width: 200,
                            child: const Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.file(
                          houseMediaFiles[index],
                          height: 200,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              (error != null) ? Text(error!) : Container(),
              (error != null)
                  ? const SizedBox(
                      height: 20,
                    )
                  : Container(),
              GestureDetector(
                onTap: () async {
                  final pref = await SharedPreferences.getInstance();

                  final email = pref.getString('email');

                  if (email != null &&
                      price.text.isNotEmpty &&
                      phoneNumber.text.isNotEmpty &&
                      houseName.text.isNotEmpty &&
                      houseMedia != []) {
                    //post media
                    final house = AddNewHouseModel(
                      email: email,
                      price: double.parse(price.text),
                      details: details.text,
                      phoneNumber: int.parse(phoneNumber.text),
                      houseName: houseName.text,
                      category: category,
                      city: city,
                      media: houseMedia,
                    );
                    final bool isUploaded = await services.uploadHouse(house);
                    log(isUploaded.toString());
                    if (!isUploaded) {
                      setState(() {
                        error = "Something went wrong";
                      });
                    } else {
                      error = null;
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 250, 213, 104),
                        Color.fromARGB(255, 247, 207, 87),
                        Color.fromARGB(255, 250, 203, 60),
                        Color.fromARGB(255, 253, 201, 46),
                        Colors.amber,
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Color.fromARGB(153, 158, 158, 158))
                    ],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
