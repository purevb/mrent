import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = List.generate(
    10,
    (index) => {
      "name": "Notification ${index + 1}",
      "text":
          "This is notification text for item ${index + 1}. It contains details about the notification.",
      "time": "${10 + index} minutes ago",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKEoP7UHtSJtO9hmBTerp2Nu8AUe3oY_0WMg&s",
    },
  );

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
            },
            icon: const Icon(
              CupertinoIcons.delete_simple,
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: notifications.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Dismissible(
                      key: Key(notifications[index]["name"] + index.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xff234F68),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        _deleteNotification(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Notification устав.'),
                            action: SnackBarAction(
                              label: 'Сэргээх',
                              onPressed: () {
                                setState(() {
                                  notifications.insert(index, {
                                    "name": "Сэргээх",
                                    "text": "Notification сэргэв. ",
                                    "time": "Яг одоо",
                                    "imageUrl":
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKEoP7UHtSJtO9hmBTerp2Nu8AUe3oY_0WMg&s",
                                  });
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.only(
                            left: 15, bottom: 15, top: 15, right: 20),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: notifications[index]["imageUrl"],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notifications[index]["name"],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    notifications[index]["text"],
                                    maxLines: 4,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    notifications[index]["time"],
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textDefaultColor.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
