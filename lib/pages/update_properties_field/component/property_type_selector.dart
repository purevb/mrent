import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/model/property_type.dart';
import 'package:mrent/utils/constants.dart';

class PropertyTypeSelector extends StatelessWidget {
  final DataController dataController;
  final String? selectedPropertyCategory;
  final Function(String, String) onPropertyTypeSelected;

  const PropertyTypeSelector({
    Key? key,
    required this.dataController,
    required this.selectedPropertyCategory,
    required this.onPropertyTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Төрөл өөрчлөх"),
        ValueListenableBuilder(
            valueListenable: dataController.propertyTypeNotifier,
            builder: (context, propertyType, child) {
              if (propertyType == null) {
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      color: mRed,
                      padding: const EdgeInsets.all(20),
                    ),
                  ),
                );
              } else {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i < propertyType.length; i++)
                      _typeXi(propertyType[i]),
                  ],
                );
              }
            }),
      ],
    );
  }

  Widget _typeXi(PropertyType? text) {
    return GestureDetector(
      onTap: () {
        if (text != null) {
          onPropertyTypeSelected(text.typeName ?? "", text.id ?? "");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: selectedPropertyCategory == text?.typeName
              ? const Color(0xff8BC83F)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text?.typeName ?? "",
          style: GoogleFonts.inter(
            color: const Color(0xff252B5C),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
