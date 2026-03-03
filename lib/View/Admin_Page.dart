import 'package:flutter/material.dart';
import 'package:podverse_app/View/App_Bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int selectedTab = 0;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PodverseAppBar(currentPage: 'admin'),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildTabs(),
          if (selectedTab != 0) ...[
            const SizedBox(height: 8),
            _buildSearchBar(),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: selectedTab == 0
                  ? _buildDashboard()
                  : selectedTab == 1
                  ? _buildUsersList()
                  : _buildPodcastsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Dashboard', 'Users', 'Podcasts'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        tabs.length,
        (i) => GestureDetector(
          onTap: () => setState(() => selectedTab = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 45,
            width: 110,
            decoration: BoxDecoration(
              gradient: selectedTab == i
                  ? const LinearGradient(
                      colors: [Color(0xFFE50914), Color(0xFFB81D24)],
                    )
                  : null,
              color: selectedTab != i ? Colors.white12 : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                tabs[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: Colors.white70),
          onPressed: () {
            searchController.clear();
            setState(() => searchQuery = '');
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (val) => setState(() => searchQuery = val.toLowerCase()),
    );
  }

  Widget _buildDashboard() {
    return StreamBuilder<List<QuerySnapshot>>(
      stream: Future.wait([
        _firestore.collection('episodes').get(),
        _firestore.collection('Profile').get(),
      ]).asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allPodcasts = snapshot.data![0].docs;
        final allUsers = snapshot.data![1].docs;

        final pendingCount = allPodcasts
            .where((p) => p['status'] == 'pending')
            .length;
        final approvedCount = allPodcasts
            .where((p) => p['status'] == 'approved')
            .length;
        final rejectedCount = allPodcasts
            .where((p) => p['status'] == 'rejected')
            .length;
        final blockedUsers = allUsers
            .where((u) => u['isBlocked'] == true)
            .length;
        final activeUsers = allUsers.length - blockedUsers;

        final stats = [
          {
            "title": "Total Users",
            "count": allUsers.length,
            "color": Colors.blueAccent,
          },
          {
            "title": "Active Users",
            "count": activeUsers,
            "color": Colors.cyanAccent,
          },
          {
            "title": "Blocked Users",
            "count": blockedUsers,
            "color": Colors.deepPurpleAccent,
          },
          {
            "title": "Total Podcasts",
            "count": allPodcasts.length,
            "color": Colors.purpleAccent,
          },
          {
            "title": "Pending Review",
            "count": pendingCount,
            "color": Colors.orangeAccent,
          },
          {
            "title": "Approved",
            "count": approvedCount,
            "color": Colors.greenAccent,
          },
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: stats.length,
          itemBuilder: (context, i) => _statCard(
            stats[i]['title'] as String,
            stats[i]['count'] as int,
            stats[i]['color'] as Color,
          ),
        );
      },
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "$count",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Profile').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No users found',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        var users = snapshot.data!.docs;

        // Apply search filter
        if (searchQuery.isNotEmpty) {
          users = users.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['name']?.toString().toLowerCase().contains(
                      searchQuery,
                    ) ??
                    false) ||
                (data['email']?.toString().toLowerCase().contains(
                      searchQuery,
                    ) ??
                    false) ||
                (data['uid']?.toString().toLowerCase().contains(searchQuery) ??
                    false);
          }).toList();
        }

        if (users.isEmpty) {
          return const Center(
            child: Text(
              'No matching users found',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) {
            final user = users[i];
            final data = user.data() as Map<String, dynamic>;

            return Card(
              color: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent.withOpacity(0.3),
                  child: Text(
                    (data['name'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  data['name'] ?? 'Unknown User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (data['email'] != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.white54,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data['email'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.badge,
                          color: Colors.white54,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'ID: ${(data['uid'] ?? user.id).substring(0, 8)}...',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _userStatusBadge(data['isBlocked'] ?? false),
                        const SizedBox(width: 8),
                        // Text(
                        //   _formatDate(data['createdAt']),
                        //   style: const TextStyle(
                        //     color: Colors.white54,
                        //     fontSize: 12,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        data['isBlocked'] == true
                            ? Icons.check_circle
                            : Icons.block,
                        color: data['isBlocked'] == true
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 28,
                      ),
                      onPressed: () =>
                          _toggleUserBlock(user.id, data['isBlocked'] ?? false),
                      tooltip: data['isBlocked'] == true
                          ? 'Unblock User'
                          : 'Block User',
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.blueAccent,
                        size: 28,
                      ),
                      onPressed: () => _showUserDetails(user.id, data),
                      tooltip: 'View Details',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _userStatusBadge(bool isBlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isBlocked
            ? Colors.redAccent.withOpacity(0.2)
            : Colors.greenAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBlocked ? Colors.redAccent : Colors.greenAccent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBlocked ? Icons.block : Icons.check_circle,
            color: isBlocked ? Colors.redAccent : Colors.greenAccent,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            isBlocked ? 'BLOCKED' : 'ACTIVE',
            style: TextStyle(
              color: isBlocked ? Colors.redAccent : Colors.greenAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleUserBlock(String userId, bool currentStatus) async {
    try {
      await _firestore.collection('Profile').doc(userId).update({
        'isBlocked': !currentStatus,
        'blockedAt': !currentStatus ? FieldValue.serverTimestamp() : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentStatus
                ? 'User unblocked successfully!'
                : 'User blocked successfully!',
          ),
          backgroundColor: currentStatus
              ? Colors.greenAccent
              : Colors.orangeAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user status: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showUserDetails(String userId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'User Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Avatar with Initial
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent.withOpacity(0.3),
                      child: Text(
                        (data['name'] ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // User Info
                    _buildDetailRow('Name', data['name'] ?? 'N/A'),
                    _buildDetailRow('Email', data['email'] ?? 'N/A'),
                    _buildDetailRow('User ID', data['uid'] ?? userId),
                    _buildDetailRow(
                      'Status',
                      data['isBlocked'] == true ? 'Blocked' : 'Active',
                    ),

                    _buildDetailRow('Joined', _formatDate(data['createdAt'])),
                    const SizedBox(height: 16),

                    // Block/Unblock Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _toggleUserBlock(userId, data['isBlocked'] ?? false);
                        },
                        icon: Icon(
                          data['isBlocked'] == true
                              ? Icons.check_circle
                              : Icons.block,
                        ),
                        label: Text(
                          data['isBlocked'] == true
                              ? 'Unblock User'
                              : 'Block User',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: data['isBlocked'] == true
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodcastsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('episodes')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No podcasts found',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        var podcasts = snapshot.data!.docs;

        // Apply search filter
        if (searchQuery.isNotEmpty) {
          podcasts = podcasts.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['title'].toString().toLowerCase().contains(
                  searchQuery,
                ) ||
                data['category'].toString().toLowerCase().contains(searchQuery);
          }).toList();
        }

        if (podcasts.isEmpty) {
          return const Center(
            child: Text(
              'No matching podcasts found',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        return ListView.builder(
          itemCount: podcasts.length,
          itemBuilder: (_, i) {
            final podcast = podcasts[i];
            final data = podcast.data() as Map<String, dynamic>;

            return Card(
              color: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () => _showPodcastPreview(podcast.id, data),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data['thumbnailUrl'] ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.white24,
                            child: const Icon(
                              Icons.image,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? 'Untitled',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Category: ${data['category'] ?? 'N/A'}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _statusBadge(data['status'] ?? 'pending'),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(data['createdAt']),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            if (data['status'] == 'rejected' &&
                                data['rejectionReason'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Reason: ${data['rejectionReason']}',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Actions - ALWAYS show for pending, otherwise show view button
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (data['status'] == 'pending') ...[
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.greenAccent,
                                size: 28,
                              ),
                              onPressed: () => _approvePodcast(podcast.id),
                              tooltip: 'Approve',
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.redAccent,
                                size: 28,
                              ),
                              onPressed: () => _showRejectDialog(podcast.id),
                              tooltip: 'Reject',
                            ),
                          ] else
                            IconButton(
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.white70,
                                size: 28,
                              ),
                              onPressed: () =>
                                  _showPodcastPreview(podcast.id, data),
                              tooltip: 'View Details',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'approved':
        color = Colors.greenAccent;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = Colors.redAccent;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.orangeAccent;
        icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final date = (timestamp as Timestamp).toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  void _showPodcastPreview(String podcastId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => PodcastPreviewDialog(
        podcastId: podcastId,
        data: data,
        onApprove: () {
          Navigator.pop(context);
          _approvePodcast(podcastId);
        },
        onReject: () {
          Navigator.pop(context);
          _showRejectDialog(podcastId);
        },
      ),
    );
  }

  Future<void> _approvePodcast(String podcastId) async {
    try {
      await _firestore.collection('episodes').doc(podcastId).update({
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Podcast approved successfully!'),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving podcast: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showRejectDialog(String podcastId) {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          "Reject Podcast",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter reason for rejection...',
            hintStyle: TextStyle(color: Colors.white38),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a rejection reason'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              try {
                await _firestore.collection('episodes').doc(podcastId).update({
                  'status': 'rejected',
                  'rejectionReason': reasonController.text.trim(),
                  'rejectedAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Podcast rejected'),
                    backgroundColor: Colors.orangeAccent,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error rejecting podcast: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text(
              "Reject",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

// Video Preview Dialog Widget
class PodcastPreviewDialog extends StatefulWidget {
  final String podcastId;
  final Map<String, dynamic> data;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PodcastPreviewDialog({
    Key? key,
    required this.podcastId,
    required this.data,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  State<PodcastPreviewDialog> createState() => _PodcastPreviewDialogState();
}

class _PodcastPreviewDialogState extends State<PodcastPreviewDialog> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.network(widget.data['videoUrl']);
      await _controller!.initialize();
      setState(() => _isInitialized = true);
    } catch (e) {
      setState(() => _hasError = true);
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.data['title'] ?? 'Preview',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Video Player
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _hasError
                              ? const Center(
                                  child: Text(
                                    'Error loading video',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                )
                              : _isInitialized
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      IconButton(
                                        icon: Icon(
                                          _controller!.value.isPlaying
                                              ? Icons.pause_circle
                                              : Icons.play_circle,
                                          size: 64,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _controller!.value.isPlaying
                                                ? _controller!.pause()
                                                : _controller!.play();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Details
                      _buildDetailRow(
                        'Category',
                        widget.data['category'] ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Series',
                        widget.data['series'] ?? 'None',
                      ),
                      _buildDetailRow(
                        'Episode',
                        '${widget.data['episodeNumber'] ?? 'N/A'}',
                      ),
                      _buildDetailRow(
                        'Visibility',
                        widget.data['visibility'] ?? 'Public',
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.data['description'] ?? 'No description',
                        style: const TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 12),
                      if (widget.data['tags'] != null &&
                          (widget.data['tags'] as List).isNotEmpty) ...[
                        const Text(
                          'Tags:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (widget.data['tags'] as List)
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: Colors.blueAccent
                                      .withOpacity(0.3),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons - Show for pending status
            if (widget.data['status'] == 'pending')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onReject,
                        icon: const Icon(Icons.cancel),
                        label: const Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onApprove,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Status: ${widget.data['status'].toString().toUpperCase()}',
                    style: TextStyle(
                      color: widget.data['status'] == 'approved'
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
