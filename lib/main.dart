import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mrent/firebase_options.dart';
import 'package:mrent/pages/beginning_page.dart';

<<<<<<< HEAD
void main() {
  debugPrintKeyboardEvents = false;
=======
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

>>>>>>> 8944d9477f47229a987f8b53172e76a352e8f721
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Beginning(),
    );
  }
}
