import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semsar/Models/add_new_house_model.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/constants/route_names.dart';
import 'package:semsar/pages/add%20house/category_drop_down_menu.dart';
import 'package:semsar/pages/add%20house/city_drop_down_menu.dart';
import 'package:semsar/services/houses/house_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHousePage extends StatefulWidget {
  const AddHousePage({
    super.key,
  });

  @override
  State<AddHousePage> createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  HouseServices services = HouseServices();

  late TextEditingController price;

  late TextEditingController details;

  late TextEditingController phoneNumber;

  late TextEditingController houseName;

  late TextEditingController rent;

  late TextEditingController rooms;

  late TextEditingController lavatory;

  late TextEditingController area;

  late TextEditingController diningRooms;

  late TextEditingController sleepingRooms;

  late bool isForSale = false;

  late bool isForRent = false;

  late List<String> houseMedia;

  late List<File> houseMediaFiles;

  late String category;

  late String city;

  String? error;

  @override
  void initState() {
    price = TextEditingController();

    details = TextEditingController();

    phoneNumber = TextEditingController();

    houseName = TextEditingController();

    rent = TextEditingController();

    rooms = TextEditingController();

    lavatory = TextEditingController();

    area = TextEditingController();

    diningRooms = TextEditingController();

    sleepingRooms = TextEditingController();

    isForSale = false;

    isForRent = false;

    houseMedia = [];

    houseMediaFiles = [];

    category = 'Casual';

    city = 'Beirut';

    super.initState();
  }

  String formatDouble(int value) {
    if (value >= 1000000) {
      String result = (value / 1000000).toStringAsFixed(3);
      if (result.endsWith('.000')) {
        result = result.substring(0, result.length - 4);
      }
      return '\$ ${result}m';
    } else if (value >= 1000) {
      String result = (value / 1000).toStringAsFixed(3);
      if (result.endsWith('.000')) {
        result = result.substring(0, result.length - 4);
      }
      return '\$ ${result.replaceAll('.', ',')}k';
    } else {
      String result = value.toStringAsFixed(2);
      if (result.endsWith('.00')) {
        result = result.substring(0, result.length - 3);
      }
      return '\$ $result';
    }
  }

  Widget _housePropertyContainer(
    String propertyName,
    IconData icon,
    Size size,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: size.width * 0.28,
      height: size.width * 0.28,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(84, 158, 158, 158)),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: 35,
            color: AppColors.lightBrown,
          ),
          Flexible(
            child: Text(
              propertyName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.darkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _houseDropDownMenuItems(
    Widget dropItems,
    IconData icon,
    Size size,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: size.width * 0.43,
      height: size.width * 0.4,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(84, 158, 158, 158)),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: 45,
            color: AppColors.lightBrown,
          ),
          dropItems,
        ],
      ),
    );
  }

  Future<void> editPropertyNumbers(TextEditingController controller) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(7))),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            toolbarHeight: 80,
            title: const Text(
              'Add new house',
            ),
            backgroundColor: AppColors.cinderella,
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
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
              const SizedBox(
                height: 10,
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
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: details,
                keyboardType: TextInputType.text,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelText: 'Details',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Text('For Sale',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.darkBrown,
                          )),
                      Checkbox(
                        value: isForSale,
                        onChanged: (value) {
                          if (value != null && category != 'Hotel') {
                            setState(() {
                              isForSale = value;
                            });
                          }
                          if (category == 'Hotel') {
                            setState(() {
                              isForSale = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('For Rent',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.darkBrown,
                          )),
                      Checkbox(
                        value: isForRent,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              isForRent = value;
                            });
                          }
                        },
                        semanticLabel: 'For Rent',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await editPropertyNumbers(rooms);
                    },
                    child: _housePropertyContainer(
                      '${(rooms.text.isEmpty) ? '0' : rooms.text} Rooms',
                      Icons.door_back_door_outlined,
                      size,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await editPropertyNumbers(lavatory);
                    },
                    child: _housePropertyContainer(
                      '${(lavatory.text.isEmpty) ? '0' : lavatory.text} lavatory',
                      Icons.bathtub_outlined,
                      size,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await editPropertyNumbers(area);
                    },
                    child: _housePropertyContainer(
                      '${(area.text.isEmpty) ? '0' : area.text} m²',
                      Icons.space_dashboard_outlined,
                      size,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await editPropertyNumbers(
                        diningRooms,
                      );
                    },
                    child: _housePropertyContainer(
                      '${(diningRooms.text.isEmpty) ? '0' : diningRooms.text} Dining Rooms',
                      Icons.dining_outlined,
                      size,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await editPropertyNumbers(sleepingRooms);
                    },
                    child: _housePropertyContainer(
                      '${(sleepingRooms.text.isEmpty) ? '0' : sleepingRooms.text} Sleeping Rooms',
                      Icons.bed_outlined,
                      size,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await editPropertyNumbers(
                          (category == 'Hotel') ? rent : price);
                    },
                    child: _housePropertyContainer(
                      '\$${(category == 'Hotel') ? (rent.text.isEmpty ? '0' : rent.text) : (price.text.isEmpty ? '0' : price.text)}${(category == 'Hotel' || (isForRent && !isForSale)) ? '/Month' : ''}',
                      Icons.price_change_outlined,
                      size,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _houseDropDownMenuItems(
                    CategoryDropDownMenu(
                      setCategory: (c) {
                        setState(
                          () {
                            category = c;
                          },
                        );
                        if (category == 'Hotel' && isForSale) {
                          setState(() {
                            isForSale = false;
                          });
                        }
                      },
                    ),
                    Icons.category_outlined,
                    size,
                  ),
                  _houseDropDownMenuItems(
                    CityDropDownMenu(
                      setCity: (c) {
                        setState(() {
                          city = c;
                        });
                      },
                    ),
                    Icons.location_on_outlined,
                    size,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
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
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 242, 242, 242),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(7)),
                            width: 200,
                            child: const Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            addHousePhotoViewerPageRotes,
                            arguments: {
                              'imageFile': houseMediaFiles[index],
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image.file(
                            houseMediaFiles[index],
                            height: 200,
                          ),
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
                      houseMedia != [] &&
                      (isForRent || isForSale) &&
                      rooms.text.isNotEmpty) {
                    //post media
                    final house = AddNewHouseModel(
                      email: email,
                      price: double.parse(price.text),
                      details: details.text,
                      phoneNumber: int.parse(phoneNumber.text),
                      houseName: houseName.text,
                      category: category,
                      city: city,
                      isForRent: isForRent,
                      isForSale: isForRent,
                      rooms: int.parse(rooms.text),
                      lavatory: int.parse(rooms.text),
                      area: int.parse(rooms.text),
                      diningRooms: int.parse(rooms.text),
                      sleepingRooms: int.parse(rooms.text),
                      rent: double.parse(rent.text),
                      media: houseMedia,
                    );
                    services.uploadHouse(house).then((isUploaded) {
                      log(isUploaded.toString());
                      if (!isUploaded) {
                        setState(() {
                          error = "Something went wrong";
                        });
                      } else {
                        error = null;
                        Navigator.pop(context);
                      }
                    });
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
                        Color.fromARGB(255, 120, 72, 64),
                        AppColors.lightBrown,
                        Color.fromARGB(255, 94, 45, 38),
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
                          color: Colors.white),
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
