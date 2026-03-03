import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:podverse_app/View/video_player.dart';
import 'package:podverse_app/view/App_Bar.dart';
import 'package:podverse_app/Widget/cutom_widget.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<Widget> lib = [
    CustomWidget().allLibrary(),
    CustomWidget().playlistLibrary(),
    CustomWidget().downloadLibrary(),
  ];

  List<Map<String, dynamic>> allLib = [];
  List<Map<String, dynamic>> playlistLib = [];
  List<Map<String, dynamic>> downloadLib = [];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PodverseAppBar(currentPage: "library"),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Responsive tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _tabButton("All", 0)),
                const SizedBox(width: 10),
                Expanded(child: _tabButton("Playlist", 1)),
                const SizedBox(width: 10),
                Expanded(child: _tabButton("Downloads", 2)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: lib[currentIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    bool isSelected = currentIndex == index;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white24
            : const Color.fromARGB(255, 57, 56, 56),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            currentIndex = index;
          });
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
