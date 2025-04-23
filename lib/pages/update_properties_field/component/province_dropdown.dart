import 'package:flutter/material.dart';
import 'package:mrent/controller/data_controller.dart';

class ProvinceDropdown extends StatelessWidget {
  final DataController dataController;
  final GlobalKey<FormState> formKey;
  final String? selectedProvince;
  final Function(String?) onProvinceChanged;

  const ProvinceDropdown({
    Key? key,
    required this.dataController,
    required this.formKey,
    required this.selectedProvince,
    required this.onProvinceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dataController.proviceNotifier,
        builder: (context, provinceData, child) {
          return Form(
            key: formKey,
            child: DropdownButtonFormField<String>(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff8BC83F)),
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff8BC83F)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xff8BC83F), width: 1.5),
                ),
                hintText: "Хот эсвэл аймаг сонгоно уу",
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              value: selectedProvince,
              isExpanded: false,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[600]),
              borderRadius: BorderRadius.circular(12),
              elevation: 19,
              dropdownColor: Colors.white,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              items: provinceData?.map<DropdownMenuItem<String>>((province) {
                return DropdownMenuItem<String>(
                  value: province.id,
                  child: Text(
                    province.provinceName ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                );
              }).toList(),
              onChanged: onProvinceChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Хот эсвэл аймаг сонгоно уу';
                }
                return null;
              },
            ),
          );
        });
  }
}
