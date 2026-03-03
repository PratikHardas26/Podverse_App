import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podverse_app/Model/profile_model.dart';
import 'package:podverse_app/View/about_us.dart';
import 'package:podverse_app/view/App_Bar.dart';
import 'package:podverse_app/Databases/shared_pref.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPref sp = SharedPref();
  List<ProfileModel> items = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  final FirebaseFirestore _firebaseFirestoreObj = FirebaseFirestore.instance;

  File? _selectedImage; // Store selected image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      fetchProfileDatamodel();
    });
  }

  void fetchProfileDatamodel() async {
    log("called in the fetchProfiledataModel");
    await fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    await sp.getSharedPrefData();
    print("✅ SharedPref Email: $email");

    QuerySnapshot profileData = await _firebaseFirestoreObj
        .collection("Profile")
        .get();

    List<ProfileModel> tempItems = [];

    for (var doc in profileData.docs) {
      print("🧾 Firestore Data: ${doc.data()}");

      String name = doc["name"];
      String id = doc["email"];

      if (email == id) {
        print("✅ MATCH FOUND for $email");
        tempItems.add(ProfileModel(id: id, name: name));
      }
    }

    print("✅ tempItems length: ${tempItems.length}");

    setState(() {
      items = tempItems;
      print("✅ items set in state: $items");
    });
  }

  // 👇 Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // 👇 Bottom Sheet for editing profile
  void bottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Edit Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 👇 Profile Image Selector
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const AssetImage("assets/images/avtar.png")
                                as ImageProvider,
                      child: _selectedImage == null
                          ? const Icon(
                              Icons.camera_alt,
                              color: Colors.black54,
                              size: 30,
                            )
                          : null,
                    ),
                  ),
                ),

                // const SizedBox(height: 20),

                // Text(
                //   "Name",
                //   style: GoogleFonts.poppins(
                //     fontSize: 18,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 8),
                // TextField(
                //   controller: nameController,
                //   decoration: const InputDecoration(
                //     hintText: "Enter the Name",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(12)),
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 20),

                // Text(
                //   "Id",
                //   style: GoogleFonts.poppins(
                //     fontSize: 18,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 8),
                // TextField(
                //   controller: idController,
                //   decoration: const InputDecoration(
                //     hintText: "Enter the ID",

                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(12)),
                //     ),
                //   ),

                // ),
                const SizedBox(height: 30),

                // ✅ Save Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Add your Firestore update logic here later
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PodverseAppBar(currentPage: "profile"),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/avtar.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                log("++++++++++++++++++++++++++${items[index].name}");
                log("++++++++++++++++++++++++++${items[index].id}");
                return Column(
                  children: [
                    Text(
                      items[index].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      items[index].id,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: bottomSheet,
                child: Text(
                  "Edit",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Library Buttons
            _libraryButton("Favorites"),
            const SizedBox(height: 10),
            _libraryButton("Downloads"),
            const SizedBox(height: 10),
            _libraryButton("Recently Played"),
            const SizedBox(height: 10),
            _libraryButton("History"),
            const SizedBox(height: 10),
            _libraryButton("Language"),
            const SizedBox(height: 10),
            _libraryButton("About Us"),
          ],
        ),
      ),
    );
  }

  ElevatedButton _libraryButton(String title) {
    return ElevatedButton(
      onPressed: () {
        if (title == "About Us") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AboutUsPage();
              },
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(600, 70),
        backgroundColor: const Color.fromARGB(255, 30, 30, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const Icon(Icons.menu, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
