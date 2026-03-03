import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podverse_app/View/bottom_naviagtion_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> items = [];

  Future<void> fetchNotificationData() async {
    QuerySnapshot qp = await firebaseFirestore.collection("episodes").get();

    for (int i = 0; i < qp.docs.length; i++) {
      Map<String, dynamic> obj = {
        "title": qp.docs[i]["title"],
        "description": qp.docs[i]["description"],
        "category": qp.docs[i]["category"],
        "image": qp.docs[i]["thumbnailUrl"],
        //"time": qp.docs[i]["createdAt"],
      };
      items.add(obj);
      log("$obj");
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigation()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            "Notifications",
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                padding: EdgeInsets.all(width * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[900],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification image
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(16),
                    //   child: Image.asset(
                    //     item["image"],
                    //     height: width * 0.14,
                    //     width: width * 0.14,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    // SizedBox(width: width * 0.03),

                    // Notification text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"],
                            style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: height * 0.008),
                          Text(
                            item["description"],
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: height * 0.008),
                          Text(
                            item["category"],
                            style: TextStyle(
                              fontSize: width * 0.033,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
