import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mrent/pages/components/tips_for_you.dart';
import 'package:mrent/pages/components/touchable_scale.dart';
import 'package:get/get.dart';
import 'package:mrent/pages/detail_of_object_page.dart';
import 'package:mrent/pages/search_page.dart';
import 'package:mrent/services/property_service.dart';
import '../model/properties.dart';
import 'components/horizantal_card.dart';
import 'components/text_field.dart';
import 'components/vertical_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.id});
  final String? id;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var rentToggle = true;
  ValueNotifier<List<PropertyData>?> propertiesNotifier = ValueNotifier(null);
  List<PropertyData>? properties;
  Future<void> getPropertiesData() async {
    try {
      var fetchedProperties = await PropertyService().getSurvey();
      propertiesNotifier.value = fetchedProperties;

      if (fetchedProperties != null && fetchedProperties.isNotEmpty) {
        print('Properties fetched successfully: ${fetchedProperties.length}');
      } else {
        print('No properties found.');
      }
    } catch (e) {
      print('Error loading properties: $e');
      propertiesNotifier.value = null;
    }
  }

  Future<void> _refreshProperties() async {
    await getPropertiesData();
  }

  @override
  void initState() {
    super.initState();
    getPropertiesData();
  }

  final List<Map<String, dynamic>> bali = [
    {
      "path":
          "https://media.cntraveler.com/photos/63f4f4fc0630e21ed8088321/1:1/w_1280%2Ch_1280%2Cc_limit/GettyImages-1145042281.jpeg",
      "location": "Bali, Indonesia",
      "rentCount": "29",
      "hasTitle": false
    },
    {
      "path":
          "https://i0.wp.com/handluggageonly.co.uk/wp-content/uploads/2018/10/Hand-Luggage-Only-12.jpg?resize=1000%2C1500&ssl=1",
      "location": "Kyoto, Japan",
      "rentCount": "15",
      "hasTitle": true
    },
    {
      "path":
          "https://media.istockphoto.com/id/1388339818/photo/a-classic-red-telephone-booth-in-front-of-the-big-ben-clocktower-in-london.jpg?s=612x612&w=0&k=20&c=gT4YX-hWMVXHqZj0GSIegrWMaMRpIAldnmd36t6uP8g=",
      "location": "Santorini, Greece",
      "rentCount": "42",
      "hasTitle": false
    },
    {
      "path":
          "https://plus.unsplash.com/premium_photo-1673511731942-8841dc483cb2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YmVhdXRpZnVsJTIwbmF0dXJlfGVufDB8fDB8fHww",
      "location": "Paris, France",
      "rentCount": "34",
      "hasTitle": true
    },
    {
      "path":
          "https://images.unsplash.com/photo-1611332124437-b6278baffb52?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGJlYXV0aWZ1bCUyMG5hdHVyZXxlbnwwfHwwfHx8MA%3D%3D",
      "location": "Maui, Hawaii",
      "rentCount": "50",
      "hasTitle": false
    }
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: RefreshIndicator(
        onRefresh: () => _refreshProperties(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 5),
                    child: const Text(
                      "Таны байршил",
                      style: TextStyle(fontSize: 15, color: Color(0xff7D7F88)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Image.asset(
                            "assets/images/location.png",
                            width: 20,
                          ),
                        ),
                        const Text(
                          "Улаанбаатар , Монгол",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                  searchBar(width),
                  Container(
                    margin: const EdgeInsets.only(
                        right: 15, left: 15, top: 20, bottom: 20),
                    child: const Text(
                      "Tанд юу хэрэгтэй вэ?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  ),
                  toggler(width),
                  Container(
                    margin: const EdgeInsets.only(right: 15, left: 15, top: 20),
                    child: const Text(
                      "Тантай ойр",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 10),
                    child: const Text(
                      "Завхан дахь 243 үл хөдлөх хөрөнгө ",
                      style: TextStyle(color: Color(0xff7D7F88), fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: height * 0.2,
                    child: ValueListenableBuilder<List<PropertyData>?>(
                      valueListenable: propertiesNotifier,
                      builder: (context, propertyData, child) {
                        if (propertyData == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (propertyData.isEmpty) {
                          return const Center(
                              child: Text('No properties available.'));
                        }
                        return first(propertyData);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Завхан дахь өндөр\nүнэлгээтэй",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Бүгд",
                            style: TextStyle(color: Color(0xff6246EA)),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: height * 0.2,
                    child: ValueListenableBuilder<List<PropertyData>?>(
                      valueListenable: propertiesNotifier,
                      builder: (context, propertyData, child) {
                        if (propertyData == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (propertyData.isEmpty) {
                          return const Center(
                              child: Text('No properties available.'));
                        }

                        return second(propertyData);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Дараагийн аялалаа\nхайж байна уу",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Бүгд",
                            style: TextStyle(color: Color(0xff6246EA)),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    padding: const EdgeInsets.only(right: 10),
                    height: height * 0.25,
                    child: third(height, width),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    child: const Text(
                      "Танд зориулсан tips",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 20, right: 15),
                    padding: const EdgeInsets.only(right: 10),
                    child: fourth(),
                  ),
                  TouchableScale(
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 15, top: 20, right: 15),
                      padding:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(54),
                          border: Border.all(
                            width: 2,
                            color: const Color(0xff6246EA),
                          )),
                      child: const Center(
                        child: Text(
                          "Илүү олон нийтлэл унших ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xff6246EA)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin:
                          const EdgeInsets.only(left: 15, top: 20, right: 15),
                      height: height * 0.23,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff917AFD),
                                    Color(0xff6246EA),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Та өөрийн байрыг түрээслүүлэхийг хүсч байна уу?",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  TouchableScale(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(49),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: const Text(
                                      "Tүрээслэгч болох",
                                      style: TextStyle(
                                        color: Color(0xff6246EA),
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.35,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              child: Image.asset(
                                  fit: BoxFit.fitWidth,
                                  "assets/images/puprple_house.png"),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget first(List<PropertyData> propertyData) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailOfObjectPage(
                          propertyData: propertyData[index],
                        )));
          },
          child: NearToYouComponenState(
            propertyData: propertyData[index],
            id: propertyData[index].id,
            path: propertyData[index].images,
            text: propertyData[index].description!,
            location: propertyData[index].location,
            rent: propertyData[index].nightlyPrice,
            roomCount: propertyData[index].numBeds!.toString(),
            square: propertyData[index].squares.toString(),
            rating: propertyData[index].squares.toString(),
            ratingCount: propertyData[index].numBeds.toString(),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 20);
      },
      itemCount: propertyData.length,
    );
  }

  Widget second(List<PropertyData> propertyData) {
    return ListView.separated(
      reverse: true,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailOfObjectPage(
                          propertyData: propertyData[index],
                        )));
          },
          child: NearToYouComponenState(
            propertyData: propertyData[index],
            path: propertyData[index].images,
            text: propertyData[index].description!,
            location: propertyData[index].location,
            rent: propertyData[index].nightlyPrice,
            roomCount: propertyData[index].numBeds!.toString(),
            square: propertyData[index].squares.toString(),
            rating: propertyData[index].squares.toString(),
            ratingCount: propertyData[index].numBeds.toString(),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 20,
        );
      },
      itemCount: propertyData.length, // Use propertyData.length here
    );
  }

  ListView third(double height, double width) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
          child: VerticalCardComponent(
            hasTitle: false,
            width: width * 0.45,
            height: height * 0.3,
            path: bali[index]["path"],
            location: bali[index]["location"],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 15,
        );
      },
      itemCount: bali.length,
    );
  }

  ListView fourth() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return const TouchableScale(
          child: TipsForYou(
            path:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQ3Qfvw2xdCHXrUjsp9A94J0rWcH3VVaIj7gDHb3HT81ZjP1HR",
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 15,
        );
      },
      itemCount: 2,
    );
  }

  Container toggler(double width) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(8),
      width: width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.055),
        borderRadius: BorderRadius.circular(72),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  rentToggle = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72),
                  gradient: rentToggle
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                              Color(0xff917AFD),
                              Color(0xff6246EA),
                            ])
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.transparent, Colors.transparent],
                        ),
                ),
                child: Center(
                  child: Text(
                    "Түрээслэх",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: rentToggle
                          ? Colors.white
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  rentToggle = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72),
                  gradient: rentToggle
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.transparent, Colors.transparent],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff917AFD),
                            Color(0xff6246EA),
                          ],
                        ),
                ),
                child: Center(
                  child: Text(
                    "Түрээслүүлэх",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: !rentToggle
                          ? Colors.white
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TouchableScale searchBar(double width) {
    return TouchableScale(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RentalSearchPage()));
      },
      child: Container(
        height: 50,
        width: width,
        margin: const EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(72),
            color: Colors.black.withOpacity(0.03),
            border: Border.all(width: 1, color: Colors.black.withOpacity(0.1))),
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                width: 30,
                height: 30,
                child: Image.asset(
                    fit: BoxFit.fill, "assets/images/search-normal.png")),
            const Text("Хайлт"),
            const Spacer(),
            Container(
                margin: const EdgeInsets.only(right: 15),
                width: 30,
                height: 30,
                child: Image.asset(
                    fit: BoxFit.fill, "assets/images/setting-5.png")),
          ],
        ),
        // text: "Хайлт",
        // prefixIcon: "assets/images/search-normal.png",
        // suffixIcon: "assets/images/setting-5.png",
      ),
    );
  }
}
