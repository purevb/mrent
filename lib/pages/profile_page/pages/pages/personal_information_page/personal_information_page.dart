import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';

@RoutePage()
class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({
    required this.mongoUser,
    super.key,
  });
  final MongoUserModel mongoUser;

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  Api api = Api();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  DataController dataController = DataController();
  @override
  void initState() {
    super.initState();
    dataController.getUserData(widget.mongoUser.firebaseId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Мэдээллүүдээ шинэчлэх"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.mongoUser.profileImage ??
                      "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildTextField(
              true,
              nameController,
              widget.mongoUser.name ?? "",
              Icons.person,
            ),
            _buildTextField(
              true,
              phoneNumberController,
              widget.mongoUser.phone ?? "",
              Icons.phone,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.symmetric(
                          horizontal: 70,
                        ),
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Container(
                              height: 300,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 70,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                spacing: 10,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Lottie.asset(
                                    'assets/animation/cancel.json',
                                    fit: BoxFit.contain,
                                  ),
                                  Text(
                                    "Та одоохондоо мэйлээ солих боломжгүй байна.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    color: Colors.grey,
                                    Icons.cancel,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: _buildTextField(
                false,
                emailController,
                widget.mongoUser.email ?? "",
                Icons.email,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                await api
                    .updateMongoUsersDetail(
                  widget.mongoUser.id ?? "",
                  userName: nameController.text,
                  phoneNumber: phoneNumberController.text,
                )
                    .then((_) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                });
              },
              child: Text(
                "Хадгалах",
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(bool enable, TextEditingController controller,
      String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        enabled: enable,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
