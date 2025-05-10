// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   // List of items with label, asset path, and whether it's SVG or PNG
//   final List<_NavItem> items;

//   const CustomBottomNavigationBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//     required this.items,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: onTap,
//       items: items.asMap().entries.map((entry) {
//         final index = entry.key;
//         final item = entry.value;
//         return BottomNavigationBarItem(
//           label: item.label,
//           icon: SizedBox(
//             height: 35,
//             width: 35,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               height: currentIndex == index
//                   ? (item.isSvg ? 35 : 35)
//                   : (item.isSvg ? 25 : 30),
//               width: currentIndex == index
//                   ? (item.isSvg ? 35 : 35)
//                   : (item.isSvg ? 25 : 30),
//               child: item.isSvg
//                   ? SvgPicture.asset(
//                       item.assetPath,
//                       fit: BoxFit.contain,
//                       colorFilter: ColorFilter.mode(
//                         currentIndex == index
//                             ? Colors.red
//                             : const Color(0xff7D8588),
//                         BlendMode.srcIn,
//                       ),
//                     )
//                   : Image.asset(
//                       item.assetPath,
//                       fit: BoxFit.contain,
//                       color: currentIndex == index
//                           ? Colors.red
//                           : const Color.fromARGB(255, 106, 112, 114),
//                     ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
