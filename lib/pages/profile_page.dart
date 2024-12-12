import 'package:flutter/material.dart';
import 'package:mrent/model/user.dart';
import 'package:mrent/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String id;
  const ProfilePage({required this.id, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ValueNotifier<UserModel?> userNotifier = ValueNotifier(null);

  Future<void> getUserData(String id) async {
    try {
      var fetchedProperties = await UserRemoteService().getUser(id);
      userNotifier.value = fetchedProperties;

      if (fetchedProperties != null) {
        print('User fetched successfully: ${userNotifier.toString()}');
      } else {
        print('No properties found.');
      }
    } catch (e) {
      print('Error loading properties: $e');
      userNotifier.value = null;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ValueListenableBuilder<UserModel?>(
                valueListenable: userNotifier,
                builder: (context, userData, child) {
                  if (userData == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcRKsa5AE_yo9xCSR9pqKZz4g90rdwYnwxW9imCgS2lUEqhDJTboM7VwP-SwlepVmJoulkzl0SIjjzl6TnU'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userData.user?.name ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(userData.user?.email ?? ""),
                      ],
                    );
                  }
                },
              ),
            ),
            const Divider(),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Personal details'),
                  onTap: () {
                    // Navigate to personal details screen
                    Navigator.pushNamed(context, '/personal_details');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Navigate to settings screen
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment details'),
                  onTap: () {
                    // Navigate to payment details screen
                    Navigator.pushNamed(context, '/payment_details');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('FAQ'),
                  onTap: () {
                    // Navigate to FAQ screen
                    Navigator.pushNamed(context, '/faq');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.switch_account),
                  title: const Text('Switch to hosting'),
                  onTap: () {
                    // Handle switch to hosting action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Таалагдсан',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профайл',
          ),
        ],
      ),
    );
  }
}
