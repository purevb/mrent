import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/components/favorite_property.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.properties, this.user});
  final List<PropertyModel> properties;
  final User? user;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<PropertyModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchResults = List.from(widget.properties);
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = List.from(widget.properties);
      });
      return;
    }

    final results = widget.properties.where((property) {
      final nameMatch =
          property.propertyName?.toLowerCase().contains(query.toLowerCase()) ??
              false;
      final placeMatch =
          property.propertyName?.toLowerCase().contains(query.toLowerCase()) ??
              false;
      return nameMatch || placeMatch;
    }).toList();

    setState(() {
      _isSearching = true;
      _isSearching = true;

      _searchResults = results;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
  }

  void _navigateToPropertyDetail(PropertyModel property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PropertyDetailPage(user: widget.user, propertyData: property),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final displayItems = _isSearching ? _searchResults : widget.properties;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Хайлт",
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              width: size.width,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 237, 235, 242),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 8),
                    child: Icon(CupertinoIcons.search, color: Colors.black87),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: _performSearch,
                      decoration: const InputDecoration(
                        hintText: 'Хайх...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Results Count
            Row(
              children: [
                Text(
                  "${_searchResults.length} илэрц",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                if (_isSearching && _searchResults.isEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Илэрц олдсонгүй",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Properties Grid
            Expanded(
              child: displayItems.isEmpty
                  ? Center(
                      child: Text(
                        "Хайлтын үр дүн олдсонгүй",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: displayItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: size.height * 0.3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final property = displayItems[index];
                        return GestureDetector(
                          onTap: () => _navigateToPropertyDetail(property),
                          child: FavoriteProperty(
                            user: widget.user,
                            propertyData: property,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
