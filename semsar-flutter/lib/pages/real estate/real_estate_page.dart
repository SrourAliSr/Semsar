import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:semsar/Models/get_house.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/constants/route_names.dart';
import 'package:semsar/constants/user_settings.dart';
import 'package:semsar/services/houses/house_services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RealEstatePage extends StatefulWidget {
  final GetHouse realEstate;
  final Widget image;
  const RealEstatePage({
    super.key,
    required this.realEstate,
    required this.image,
  });

  @override
  State<RealEstatePage> createState() => _RealEstatePageState();
}

class _RealEstatePageState extends State<RealEstatePage> {
  final PageController controller = PageController();

  HouseServices services = HouseServices();

  List<String> houseMedia = [];

  bool isPostSaved = false;

  @override
  void initState() {
    services
        .checkIfSaved(widget.realEstate.houseDetails.housesId)
        .then((value) {
      if (value) {
        setState(
          () {
            isPostSaved = value;
          },
        );
      }
    });

    super.initState();
  }

  Widget _propertyConainer(String property) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
      ),
      child: Text(
        property,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: AppColors.darkBrown,
        ),
      ),
    );
  }

  Widget _housePropertyContainer(
      String propertyName, IconData icon, Size size) {
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

  Future<List<dynamic>> getMedia(int houseId, int excludedId, Size size) async {
    final List<dynamic> images = await services.getHouseMedia(
        widget.realEstate.houseDetails.housesId,
        widget.realEstate.houseMedia.id);

    houseMedia = [widget.realEstate.houseMedia.media, ...images];

    List<dynamic> imageWidgets = [];

    for (var element in images) {
      await Isolate.run(
        () {
          return base64.decode(
            element,
          );
        },
      ).then(
        (imageBytes) {
          imageWidgets.add(
            Image.memory(
              imageBytes,
              width: size.width,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
    final thumbNailImage = widget.image;
    return [thumbNailImage, ...imageWidgets];
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.cinderella,
      appBar: AppBar(
        toolbarHeight: 80,
        surfaceTintColor: AppColors.cinderella,
        backgroundColor: AppColors.cinderella,
        title: Center(
          child: Text(
            widget.realEstate.houseDetails.housesName,
          ),
        ),
        actions: [
          if (UserSettings.user!.userId ==
              widget.realEstate.houseDetails.userId)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  editHousePageRotes,
                  arguments: {
                    'oldData': widget.realEstate,
                    'houseMedia': List<String>.from(houseMedia),
                  },
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.darkBrown,
                size: 38,
              ),
            )
          else
            IconButton(
              onPressed: () async {
                final reposnse = await services
                    .savePost(widget.realEstate.houseDetails.housesId);
                setState(() {
                  isPostSaved = reposnse;
                });
              },
              icon: Icon(
                (isPostSaved) ? Icons.star : Icons.star_outline,
                color: AppColors.darkBrown,
                size: 38,
              ),
            ),
          if (widget.realEstate.houseDetails.userId !=
              UserSettings.user!.userId)
            IconButton(
              onPressed: () {
                final ids = [
                  UserSettings.user!.userId,
                  widget.realEstate.houseDetails.userId
                ];
                ids.sort();

                Navigator.of(context).pushNamed(
                  chatRoomRotes,
                  arguments: {
                    "chatRoom": ids.join("_"),
                    "receiverName": "anynmouse",
                    "receiverId": widget.realEstate.houseDetails.userId,
                    "isNewChat": true,
                  },
                );
              },
              icon: const Icon(
                Icons.chat_outlined,
                color: AppColors.darkBrown,
                size: 35,
              ),
            ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FutureBuilder(
              future: getMedia(widget.realEstate.houseMedia.houseId,
                  widget.realEstate.houseMedia.id, size),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    photoViewerPageRotes,
                                    arguments: {
                                      'images': snapshot.data!,
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: (index == 0)
                                      ? Hero(
                                          tag: widget
                                              .realEstate.houseMedia.houseId
                                              .toString(),
                                          child: snapshot.data?[index])
                                      : snapshot.data?[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: snapshot.data?.length ?? 0,
                        effect: const WormEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          dotColor: Colors.white,
                          activeDotColor: AppColors.orange,
                          type: WormType.thinUnderground,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        width: size.width,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Hero(
                          tag: widget.realEstate.houseDetails.housesId
                              .toString(),
                          child: widget.image,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.realEstate.houseDetails.housesName,
                  style: const TextStyle(
                    fontSize: 25,
                    color: AppColors.lightBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color.fromARGB(180, 105, 59, 52),
                    ),
                    Text(
                      widget.realEstate.houseDetails.city,
                      style: const TextStyle(
                        fontSize: 23,
                        color: Color.fromARGB(180, 105, 59, 52),
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
                    if (widget.realEstate.houseDetails.isForSale)
                      _propertyConainer(
                        'For Sale',
                      ),
                    if (widget.realEstate.houseDetails.isForRent)
                      _propertyConainer(
                        'For Rent',
                      ),
                    _propertyConainer(
                      widget.realEstate.houseDetails.category,
                    ),
                    if (widget.realEstate.houseDetails.category == 'Hotel')
                      _propertyConainer(
                        'Rating ${widget.realEstate.houseDetails.rating.round()}',
                      )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _housePropertyContainer(
                      '${widget.realEstate.houseDetails.rooms} Rooms',
                      Icons.door_back_door_outlined,
                      size,
                    ),
                    _housePropertyContainer(
                      '${widget.realEstate.houseDetails.lavatory} Lavatory',
                      Icons.bathtub_outlined,
                      size,
                    ),
                    _housePropertyContainer(
                      '${widget.realEstate.houseDetails.area} m²',
                      Icons.space_dashboard_outlined,
                      size,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _housePropertyContainer(
                      '${widget.realEstate.houseDetails.diningRooms} Dining Rooms',
                      Icons.dining_outlined,
                      size,
                    ),
                    _housePropertyContainer(
                      '${widget.realEstate.houseDetails.sleepingRooms} Sleeping Rooms',
                      Icons.bed_outlined,
                      size,
                    ),
                    _housePropertyContainer(
                      formatDouble(
                            (widget.realEstate.houseDetails.category == 'Hotel')
                                ? widget.realEstate.houseDetails.rent.round()
                                : widget.realEstate.houseDetails.price.round(),
                          ) +
                          ((widget.realEstate.houseDetails.category ==
                                      'Hotel' ||
                                  widget.realEstate.houseDetails.isForRent)
                              ? '/Month'
                              : ''),
                      Icons.price_change_outlined,
                      size,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width / 2,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Descripion:',
                  style: TextStyle(
                    fontSize: 25,
                    color: AppColors.lightBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  (widget.realEstate.houseDetails.detials != '')
                      ? widget.realEstate.houseDetails.detials
                      : 'No description',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 130, 74, 65),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
