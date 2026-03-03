import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:podverse_app/View/video_player.dart';
import 'package:podverse_app/view/App_Bar.dart';
import 'package:podverse_app/view/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> comedythumbnails = [
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/comedyimg1.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/c2.jpeg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/c3.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/c4.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/c5i.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  List<Map<String, dynamic>> eduThumnails = [
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/e1.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/e2.jpeg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/e3.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/e4.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/e5.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  List<Map<String, dynamic>> politicalThumbnails = [
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/n1.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/n2.jpeg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/n3.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/n4.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/n5.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  List<Map<String, dynamic>> crimeThumbnails = [
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t1.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/t2.jpeg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t3.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t4.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t5.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  List<Map<String, dynamic>> healthThumbnails = [
    {
      // "assets/images/hf1.jpg",
      // "assets/images/hf2.jpg",
      // "assets/images/hf3.jpeg",
      // "assets/images/hf4.jpeg",
      // "assets/images/hf5.jpeg",
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "Health",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hf1.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/hf2.jpg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hf3.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hf4.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hf5.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  List<Map<String, dynamic>> historyThumbnails = [
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hh1.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/hh2.jpeg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hh3.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hh4.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/hh5.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  List<Map<String, dynamic>> musicThumbnails = [
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t1.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/t2.jpeg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t3.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t4.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/t5.jpeg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  final List<Map<String, dynamic>> imgList = [
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/thumb1.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 3, 9, 15, 0),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 3, 9, 0, 0),
      "description":
          "A deep dive into one of the most mysterious unsolved cases.",
      "episodeNumber": 22,
      "likes": 42,
      "publishDate": DateTime(2025, 11, 3, 8, 30, 0),
      "series": "Dark Truths",
      "status": "approved",
      "tags": ["Crime", "Mystery"],
      "thumbnailUrl": "assets/images/thumb2.jpg",
      "title": "The Vanishing Witness",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 120,
      "visibility": "Public",
    },
    {
      "approvedAt": DateTime(2025, 11, 2, 16, 10, 14),
      "category": "True Crime",
      "createdAt": DateTime(2025, 11, 2, 16, 5, 10),
      "description": "Stand-up special with hilarious everyday observations.",
      "episodeNumber": 112,
      "likes": 24,
      "publishDate": DateTime(2025, 11, 2, 16, 0, 0),
      "series": "Laugh Factory",
      "status": "approved",
      "tags": ["Comedy", "Standup"],
      "thumbnailUrl": "assets/images/thumb3.jpg",
      "title": "Laugh Riot",
      "videoUrl": "assets/videos/v1.mp4",
      "views": 10,
      "visibility": "Public",
    },
  ];

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List epData = [];

  Future<void> fetchData() async {
    QuerySnapshot data = await _firebaseFirestore.collection("episodes").get();

    for (int i = 0; i < data.docs.length; i++) {
      Map<String, dynamic> obj = {
        "title": data.docs[i]["title"],
        "description": data.docs[i]["description"],
        "category": data.docs[i]["category"],
        "thumbnailUrl": data.docs[i]["thumbnailUrl"],
        "videoUrl": data.docs[i]["videoUrl"],
      };
      log("Fetched: ${data.docs[i]["title"]}");
      epData.add(obj);

      if (obj["category"] == "Comedy") {
        comedythumbnails.add(obj);
      } else if (obj["category"] == "Educational") {
        eduThumnails.add(obj);
      } else if (obj["category"] == "Political") {
        politicalThumbnails.add(obj);
      }
    }

    log("${comedythumbnails}");
    log("${eduThumnails}");
    log("${politicalThumbnails}");

    // for (int i = 0; i < comedythumbnails.length; i++) {
    //   log(comedythumbnails[i][]);
    // }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Widget buildCategory(String title, List<Map<String, dynamic>> thumbnails) {
    log("${thumbnails.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: thumbnails.length,
            itemBuilder: (context, index) {
              final currentItem = thumbnails[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayerScreen(videoUrl: currentItem),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image:
                          thumbnails[index]["thumbnailUrl"]
                              .toString()
                              .startsWith("http")
                          ? NetworkImage(thumbnails[index]["thumbnailUrl"])
                          : AssetImage(thumbnails[index]["thumbnailUrl"])
                                as ImageProvider,

                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PodverseAppBar(currentPage: "home"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎞 Carousel
            Container(
              height: 215,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.black),

              child: GestureDetector(
                onTap: () {},
                child: const CarouselExample(),
              ),
            ),
            const SizedBox(height: 20),

            // 🎭 Comedy
            buildCategory("Comedy", comedythumbnails),
            const SizedBox(height: 20),

            // 🎓 Educational
            buildCategory("Educational", eduThumnails),
            const SizedBox(height: 20),

            //📰 Political
            buildCategory("News & Politics", politicalThumbnails),
            const SizedBox(height: 20),

            // 🔪 True Crime
            buildCategory("True Crime", crimeThumbnails),
            SizedBox(height: 20),

            // [
            // "assets/images/t1.jpg",
            // "assets/images/t2.jpeg",
            // "assets/images/t3.jpg",
            // "assets/images/t4.jpeg",
            // "assets/images/t5.jpeg",
            buildCategory("Health & Fitness", healthThumbnails),
            const SizedBox(height: 20),

            buildCategory("History", historyThumbnails),
            const SizedBox(height: 20),

            buildCategory("Music", musicThumbnails),
          ],
        ),
        //const SizedBox(height: 20),

        // 💪 Health & Fitness
        //buildCategory("Health & Fitness", [
        // "assets/images/hf1.jpg",
        // "assets/images/hf2.jpg",
        // "assets/images/hf3.jpeg",
        // "assets/images/hf4.jpeg",
        // "assets/images/hf5.jpeg",
        //]),
        // const SizedBox(height: 20),

        // 🏛 History
        // buildCategory("History", [
        // "assets/images/hh1.jpg",
        // "assets/images/hh2.jpeg",
        // "assets/images/hh3.jpg",
        // "assets/images/hh4.jpg",
        // "assets/images/hh5.jpg",
        //]),
        //const SizedBox(height: 20),

        // 🎵 Music
        // buildCategory("Music", [
        // "assets/images/mm1.jpg",
        // "assets/images/mm2.jpeg",
        // "assets/images/mm3.jpg",
        // "assets/images/mm4.jpg",
        // "assets/images/mm5.jpeg",
        //]),
        //const SizedBox(height: 20),

        // 📖 Storytelling
        // buildCategory("Storytelling & Fiction", [
        // "assets/images/st1.jpg",
        // "assets/images/st2.jpg",
        // "assets/images/st3.jpeg",
        // "assets/images/st4.jpg",
        // "assets/images/st5.jpeg",
        //]),
        //const SizedBox(height: 20),

        // 🚀 Motivation
        // buildCategory("Personal Development & Motivation", [
        // "assets/images/p1.jpg",
        // "assets/images/p2.jpg",
        // "assets/images/p3.jpg",
        // "assets/images/p4.jpg",
        // "assets/images/p5.jpeg",
        //]),
        //],
        //),
      ),
    );
  }
}
