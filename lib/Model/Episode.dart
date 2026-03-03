import 'package:cloud_firestore/cloud_firestore.dart';

class Episode {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final List<String> tags;
  final String? series;
  final int? episodeNumber;
  final String category;
  final String visibility;
  final DateTime publishDate;
  final String status;
  final DateTime? createdAt;
  final int views;
  final int likes;

  Episode({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.tags,
    this.series,
    this.episodeNumber,
    required this.category,
    required this.visibility,
    required this.publishDate,
    required this.status,
    this.createdAt,
    this.views = 0,
    this.likes = 0,
  });

  factory Episode.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Episode(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      series: data['series'],
      episodeNumber: data['episodeNumber'],
      category: data['category'] ?? 'Others',
      visibility: data['visibility'] ?? 'Public',
      publishDate: (data['publishDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'published',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      views: data['views'] ?? 0,
      likes: data['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'tags': tags,
      'series': series,
      'episodeNumber': episodeNumber,
      'category': category,
      'visibility': visibility,
      'publishDate': Timestamp.fromDate(publishDate),
      'status': status,
      'views': views,
      'likes': likes,
    };
  }
}

class FirebaseEpisodeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all published episodes
  Future<List<Episode>> getAllEpisodes() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('episodes')
          .where('status', isEqualTo: 'approved')
          .where('visibility', isEqualTo: 'Public')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Episode.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching episodes: $e');
      return [];
    }
  }

  // Fetch episodes with real-time updates (Stream)
  Stream<List<Episode>> getEpisodesStream() {
    return _firestore
        .collection('episodes')
        .where('status', isEqualTo: 'approved')
        .where('visibility', isEqualTo: 'Public')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Episode.fromFirestore(doc)).toList(),
        );
  }

  // Fetch episode by ID
  Future<Episode?> getEpisodeById(String episodeId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('episodes')
          .doc(episodeId)
          .get();

      if (doc.exists) {
        return Episode.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching episode: $e');
      return null;
    }
  }

  // Fetch episodes by category
  Future<List<Episode>> getEpisodesByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('episodes')
          .where('status', isEqualTo: 'published')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Episode.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching episodes by category: $e');
      return [];
    }
  }

  // Fetch episodes by series
  Future<List<Episode>> getEpisodesBySeries(String series) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('episodes')
          .where('status', isEqualTo: 'published')
          .where('series', isEqualTo: series)
          .orderBy('episodeNumber', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => Episode.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching episodes by series: $e');
      return [];
    }
  }

  // Search episodes by title or tags
  Future<List<Episode>> searchEpisodes(String searchTerm) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('episodes')
          .where('status', isEqualTo: 'published')
          .get();

      List<Episode> allEpisodes = querySnapshot.docs
          .map((doc) => Episode.fromFirestore(doc))
          .toList();

      // Filter by title or tags containing search term
      return allEpisodes.where((episode) {
        return episode.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
            episode.tags.any(
              (tag) => tag.toLowerCase().contains(searchTerm.toLowerCase()),
            );
      }).toList();
    } catch (e) {
      print('Error searching episodes: $e');
      return [];
    }
  }

  // Fetch latest N episodes
  Future<List<Episode>> getLatestEpisodes(int limit) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('episodes')
          .where('status', isEqualTo: 'published')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Episode.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching latest episodes: $e');
      return [];
    }
  }

  // Fetch drafts
  Future<List<Episode>> getDrafts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('drafts')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Episode.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching drafts: $e');
      return [];
    }
  }

  // Increment views
  Future<void> incrementViews(String episodeId) async {
    try {
      await _firestore.collection('episodes').doc(episodeId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing views: $e');
    }
  }

  // Increment likes
  Future<void> incrementLikes(String episodeId) async {
    try {
      await _firestore.collection('episodes').doc(episodeId).update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing likes: $e');
    }
  }

  // Delete episode
  Future<bool> deleteEpisode(String episodeId) async {
    try {
      await _firestore.collection('episodes').doc(episodeId).delete();
      return true;
    } catch (e) {
      print('Error deleting episode: $e');
      return false;
    }
  }

  // Update episode
  Future<bool> updateEpisode(
    String episodeId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _firestore.collection('episodes').doc(episodeId).update(updates);
      return true;
    } catch (e) {
      print('Error updating episode: $e');
      return false;
    }
  }
}
