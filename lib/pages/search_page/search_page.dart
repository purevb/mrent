import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/favorite_page/components/favorite_property.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.properties});
  final List<PropertyModel> properties;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool onSearch = false;
  List<PropertyModel> _founders = [];

  void _runFilter(String enteredKeyword) {
    List<PropertyModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.properties;
    } else {
      results = widget.properties
          .where((property) =>
              property.placeName != null &&
              property.placeName!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      onSearch = !onSearch;
      _founders = results;
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _founders = [];
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && onSearch) {
      setState(() {
        onSearch = false;
        _founders = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final properties = widget.properties;

    final displayItems =
        (onSearch && _founders.isNotEmpty) ? _founders : properties;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Хайлт",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SizedBox(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 237, 235, 242),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        onChanged: (value) => _runFilter(value),
                        decoration: const InputDecoration(
                          hintText: 'Хайх...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        autofocus: true,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${widget.properties.length} илэрц",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PropertyDetailPage(
                                propertyData: displayItems[index],
                              );
                            },
                          ),
                        );
                      },
                      child: FavoriteProperty(
                        propertyData: displayItems[index],
                      ),
                    );
                  },
                  itemCount: displayItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: height * 0.3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
