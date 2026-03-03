import 'package:flutter/material.dart';
import 'package:podverse_app/View/home_screen.dart';
import 'package:podverse_app/view/library_page.dart';
import 'package:podverse_app/view/profile_page.dart';
import 'package:podverse_app/view/search_page.dart';
import 'package:podverse_app/View/UplodePage.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentSelectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchPage(),
    LibraryPage(),
    ProfileScreen(),
  ];

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final height = MediaQuery.of(context).size.height;

        void showTopPopup(String message) {
          final overlay = Overlay.of(context);
          if (overlay == null) return;

          final overlayEntry = OverlayEntry(
            builder: (context) => Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.6), // semi-transparent
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );

          overlay.insert(overlayEntry);
          Future.delayed(
            const Duration(seconds: 2),
            () => overlayEntry.remove(),
          );
        }

        return Container(
          height: height * 0.70,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Upload New Episode",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: UplodePageContent(showPopup: showTopPopup),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onItemTapped(int index) {
    if (index == 2) {
      _showUploadSheet();
    } else {
      setState(() {
        currentSelectedIndex = index < 2 ? index : index - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        onTap: onItemTapped,
        currentIndex: currentSelectedIndex >= 2
            ? currentSelectedIndex + 1
            : currentSelectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Upload",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: "Library",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
