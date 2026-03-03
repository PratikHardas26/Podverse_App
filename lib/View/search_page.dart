import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podverse_app/View/video_player.dart';
import 'package:podverse_app/view/App_Bar.dart';
import 'package:podverse_app/Widget/cutom_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int currentIndex = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PodverseAppBar(currentPage: "search"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchField(),
                    const SizedBox(height: 20),
                    _categoryList(),
                    const SizedBox(height: 20),
                    _categoryContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔍 Search Field
  Widget _searchField() {
    return TextField(
      controller: _controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Search podcasts, creators, topics",
        hintStyle: GoogleFonts.poppins(color: Colors.white),
        prefixIcon: const Icon(Icons.search),
        prefixIconColor: Colors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  // 🎧 Category Buttons
  Widget _categoryList() {
    final titles = ["Top Results", "Comedy", "Horror", "Educational", "Sports"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: titles.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = currentIndex == index;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {
                setState(() => currentIndex = index);
              },
              child: Text(
                titles[index],
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🧠 Sample Data (All as Map)
  final List<Map<String, dynamic>> topresultImages = [
    {
      "category": "Political",
      "description": "An in-depth look into current global political events.",
      "thumbnailUrl": "assets/images/image1.webp",
      "title": "World Affairs Weekly",
      "videoUrl": "assets/videos/v1.mp4",
    },
    {
      "category": "Political",
      "description": "Analysis of world diplomacy and leadership.",
      "thumbnailUrl": "assets/images/image2.webp",
      "title": "Leaders & Legacy",
      "videoUrl": "assets/videos/v1.mp4",
    },
    {
      "category": "Political",
      "description": "Discussions on government systems and power.",
      "thumbnailUrl": "assets/images/image3.webp",
      "title": "The Power Table",
      "videoUrl": "assets/videos/v1.mp4",
    },
    {
      "category": "Political",
      "description": "Discussions on government systems and power.",
      "thumbnailUrl": "assets/images/image4.webp",
      "title": "The Power Table",
      "videoUrl": "assets/videos/v1.mp4",
    },
    {
      "category": "Political",
      "description": "Discussions on government systems and power.",
      "thumbnailUrl": "assets/images/image5.webp",
      "title": "The Power Table",
      "videoUrl": "assets/videos/v1.mp4",
    },
    {
      "category": "Political",
      "description": "Discussions on government systems and power.",
      "thumbnailUrl": "assets/images/s6.jpg",
      "title": "The Power Table",
      "videoUrl": "assets/videos/v1.mp4",
    },
  ];

  final List<Map<String, dynamic>> comedyImages = [
    {
      "category": "Comedy",
      "description": "Funniest moments from the stand-up stage!",
      "thumbnailUrl": "assets/images/1.jpg",
      "title": "Laugh Factory",
      "videoUrl": "assets/videos/v2.mp4",
    },
    {
      "category": "Comedy",
      "description": "Jokes that make your day better.",
      "thumbnailUrl": "assets/images/c2.jpg",
      "title": "Daily Chuckles",
      "videoUrl": "assets/videos/v2.mp4",
    },
    {
      "category": "Comedy",
      "description": "Jokes that make your day better.",
      "thumbnailUrl": "assets/images/c3.jpg",
      "title": "Daily Chuckles",
      "videoUrl": "assets/videos/v2.mp4",
    },
    {
      "category": "Comedy",
      "description": "Jokes that make your day better.",
      "thumbnailUrl": "assets/images/c4.jpg",
      "title": "Daily Chuckles",
      "videoUrl": "assets/videos/v2.mp4",
    },
    {
      "category": "Comedy",
      "description": "Jokes that make your day better.",
      "thumbnailUrl": "assets/images/c5.jpg",
      "title": "Daily Chuckles",
      "videoUrl": "assets/videos/v2.mp4",
    },
    {
      "category": "Comedy",
      "description": "Jokes that make your day better.",
      "thumbnailUrl": "assets/images/c6.jpg",
      "title": "Daily Chuckles",
      "videoUrl": "assets/videos/v2.mp4",
    },
  ];

  final List<Map<String, dynamic>> horrorImages = [
    {
      "category": "Horror",
      "description": "Creepy stories that chill your bones.",
      "thumbnailUrl": "assets/images/h1.jpg",
      "title": "Nightmare Tales",
      "videoUrl": "assets/videos/v3.mp4",
    },
    {
      "category": "Horror",
      "description": "True horror incidents from the past.",
      "thumbnailUrl": "assets/images/h2.jpg",
      "title": "The Dark Files",
      "videoUrl": "assets/videos/v3.mp4",
    },
    {
      "category": "Horror",
      "description": "Creepy stories that chill your bones.",
      "thumbnailUrl": "assets/images/h3.jpg",
      "title": "Nightmare Tales",
      "videoUrl": "assets/videos/v3.mp4",
    },
    {
      "category": "Horror",
      "description": "Creepy stories that chill your bones.",
      "thumbnailUrl": "assets/images/h4.jpg",
      "title": "Nightmare Tales",
      "videoUrl": "assets/videos/v3.mp4",
    },
    {
      "category": "Horror",
      "description": "Creepy stories that chill your bones.",
      "thumbnailUrl": "assets/images/h5.jpg",
      "title": "Nightmare Tales",
      "videoUrl": "assets/videos/v3.mp4",
    },
    {
      "category": "Horror",
      "description": "Creepy stories that chill your bones.",
      "thumbnailUrl": "assets/images/h6.jpg",
      "title": "Nightmare Tales",
      "videoUrl": "assets/videos/v3.mp4",
    },
  ];

  final List<Map<String, dynamic>> educationImages = [
    {
      "category": "Educational",
      "description": "Learn something new every day!",
      "thumbnailUrl": "assets/images/e1.jpg",
      "title": "Smart Minds",
      "videoUrl": "assets/videos/v4.mp4",
    },
    {
      "category": "Educational",
      "description": "Simple science explained easily.",
      "thumbnailUrl": "assets/images/e2.jpg",
      "title": "Science Simplified",
      "videoUrl": "assets/videos/v4.mp4",
    },
    {
      "category": "Educational",
      "description": "Simple science explained easily.",
      "thumbnailUrl": "assets/images/e3.jpg",
      "title": "Science Simplified",
      "videoUrl": "assets/videos/v4.mp4",
    },
    {
      "category": "Educational",
      "description": "Simple science explained easily.",
      "thumbnailUrl": "assets/images/e4.jpg",
      "title": "Science Simplified",
      "videoUrl": "assets/videos/v4.mp4",
    },
    {
      "category": "Educational",
      "description": "Simple science explained easily.",
      "thumbnailUrl": "assets/images/e5.jpg",
      "title": "Science Simplified",
      "videoUrl": "assets/videos/v4.mp4",
    },
    {
      "category": "Educational",
      "description": "Simple science explained easily.",
      "thumbnailUrl": "assets/images/e6.jpg",
      "title": "Science Simplified",
      "videoUrl": "assets/videos/v4.mp4",
    },
  ];

  final List<Map<String, dynamic>> sportImages = [
    {
      "category": "Sports",
      "description": "Match highlights and sports insights.",
      "thumbnailUrl": "assets/images/s1.jpg",
      "title": "Game On!",
      "videoUrl": "assets/videos/v5.mp4",
    },
    {
      "category": "Sports",
      "description": "Legends of the game share their stories.",
      "thumbnailUrl": "assets/images/s2.jpg",
      "title": "The Champion’s Corner",
      "videoUrl": "assets/videos/v5.mp4",
    },
    {
      "category": "Sports",
      "description": "Legends of the game share their stories.",
      "thumbnailUrl": "assets/images/s3.jpg",
      "title": "The Champion’s Corner",
      "videoUrl": "assets/videos/v5.mp4",
    },
    {
      "category": "Sports",
      "description": "Legends of the game share their stories.",
      "thumbnailUrl": "assets/images/s4.jpg",
      "title": "The Champion’s Corner",
      "videoUrl": "assets/videos/v5.mp4",
    },
    {
      "category": "Sports",
      "description": "Legends of the game share their stories.",
      "thumbnailUrl": "assets/images/s5.jpg",
      "title": "The Champion’s Corner",
      "videoUrl": "assets/videos/v5.mp4",
    },
    {
      "category": "Sports",
      "description": "Legends of the game share their stories.",
      "thumbnailUrl": "assets/images/s6.jpg",
      "title": "The Champion’s Corner",
      "videoUrl": "assets/videos/v5.mp4",
    },
  ];

  // 🧩 Category Grid Builder
  Widget _buildGrid(List<Map<String, dynamic>> data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final currentItem = data[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(videoUrl: currentItem),
              ),
            );
          },
          child: CustomWidget().comedyCat(currentItem["thumbnailUrl"]),
        );
      },
    );
  }

  // 🧭 Choose Category
  Widget _categoryContent() {
    switch (currentIndex) {
      case 0:
        return _buildGrid(topresultImages);
      case 1:
        return _buildGrid(comedyImages);
      case 2:
        return _buildGrid(horrorImages);
      case 3:
        return _buildGrid(educationImages);
      case 4:
        return _buildGrid(sportImages);
      default:
        return const SizedBox.shrink();
    }
  }
}
