import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:podverse_app/Widget/cutom_widget.dart';

Map<String, dynamic> podcastData = {};

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({super.key, required Map<String, dynamic> videoUrl}) {
    podcastData = videoUrl;
  }

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isLiked = false;

  @override
  @override
  void initState() {
    super.initState();

    final videoUrl = podcastData['videoUrl'] ?? '';

    // 👇 Check whether video is from Firebase (http) or local asset
    if (videoUrl.toString().startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    } else {
      _controller = VideoPlayerController.asset(videoUrl);
    }

    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Player",
          style: GoogleFonts.poppins(fontSize: 25, color: Colors.red),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Video Player Section ---
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: _controller.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause_circle : Icons.play_circle,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ),

            const SizedBox(height: 10),
            Text(
              podcastData['title'],
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              podcastData['description'],
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 15),
            // Row(
            //   children: [
            //     ClipRRect(
            //       borderRadius: BorderRadius.circular(40),
            //       child: Image.network(
            //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzR0bIMZ71HVeR5zF4PihQaDvTQQk6bsVERw&s",
            //         height: 30,
            //         width: 30,
            //       ),
            //     ),
            //     const SizedBox(width: 15),
            //     Text(
            //       "AI Weekly Channel",
            //       style: GoogleFonts.poppins(
            //         fontSize: 15,
            //         fontWeight: FontWeight.w400,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 15),

            // 🎯 Action Buttons Row
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked; // toggle like state
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 37, 33, 44),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: _isLiked
                              ? Colors.red
                              : Colors.white, // ❤️ turns red
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Like",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _buildActionButton(Icons.share_outlined, "Share"),
                const SizedBox(width: 10),
                _buildActionButton(Icons.add_circle_outline, "Playlist"),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              "Similar Videos",
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 4,
            //     itemBuilder: (context, index) {
            //       return CustomWidget().similarVideoCard();
            //     },
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/p3.jpg",
                        fit: BoxFit.cover,
                        height: 200,
                        width: 370,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/st2.jpg",
                        fit: BoxFit.cover,
                        height: 200,
                        width: 370,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/p4.jpg",
                        fit: BoxFit.cover,
                        height: 200,
                        width: 370,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/p5.jpeg",
                        fit: BoxFit.cover,
                        height: 200,
                        width: 370,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      height: 50,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 37, 33, 44),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
