// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class UplodePageContent extends StatefulWidget {
//   final void Function(String message) showPopup;
//   const UplodePageContent({Key? key, required this.showPopup})
//     : super(key: key);

//   @override
//   State<UplodePageContent> createState() => _UplodePageContentState();
// }

// class _UplodePageContentState extends State<UplodePageContent> {
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final _tagController = TextEditingController();

//   final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   File? _videoFile;
//   File? _coverImage;
//   String? _series;
//   int? _episodeNumber;
//   DateTime _publishDate = DateTime.now();
//   String _visibility = 'Public';
//   String _category = 'Technical';
//   List<String> _tags = [];
//   bool _isUploading = false;
//   double _uploadProgress = 0.0;

//   final List<String> _seriesList = ['Show A', 'Show B', 'Show C'];
//   final List<String> _visibilityOptions = ['Public', 'Private', 'Unlisted'];
//   final List<String> _categoryOptions = [
//     'Technical',
//     'Sport',
//     'Political',
//     'Educational',
//     'Others',
//   ];

//   Future<void> pickVideo() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.video,
//     );
//     if (result != null) {
//       setState(() => _videoFile = File(result.files.single.path!));
//     }
//   }

//   Future<void> pickCoverImage() async {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) setState(() => _coverImage = File(image.path));
//   }

//   Future<void> pickPublishDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _publishDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       TimeOfDay? time = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(_publishDate),
//       );
//       if (time != null) {
//         setState(() {
//           _publishDate = DateTime(
//             picked.year,
//             picked.month,
//             picked.day,
//             time.hour,
//             time.minute,
//           );
//         });
//       }
//     }
//   }

//   void addTagsFromInput() {
//     final text = _tagController.text.trim();
//     if (text.isEmpty) return;
//     final splitTags = text
//         .split(RegExp(r'[ ,]+'))
//         .where((t) => t.isNotEmpty)
//         .toList();
//     setState(() {
//       for (var tag in splitTags) {
//         if (!_tags.contains(tag)) _tags.add(tag);
//       }
//     });
//     _tagController.clear();
//   }

//   void removeTag(String tag) => setState(() => _tags.remove(tag));

//   Future<String?> uploadFileToStorage(File file, String folderName) async {
//     try {
//       String fileName =
//           '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
//       Reference storageRef = _firebaseStorage.ref().child(
//         '$folderName/$fileName',
//       );

//       UploadTask uploadTask = storageRef.putFile(file);

//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         setState(() {
//           _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
//         });
//       });

//       TaskSnapshot taskSnapshot = await uploadTask;
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading file: $e');
//       return null;
//     }
//   }

//   Future<void> saveDraft() async {
//     if (_titleController.text.isEmpty) {
//       widget.showPopup('Please add a title to save draft');
//       return;
//     }

//     try {
//       setState(() => _isUploading = true);

//       String? videoUrl;
//       String? imageUrl;

//       if (_videoFile != null) {
//         videoUrl = await uploadFileToStorage(_videoFile!, 'drafts/videos');
//       }
//       if (_coverImage != null) {
//         imageUrl = await uploadFileToStorage(_coverImage!, 'drafts/thumbnails');
//       }

//       Map<String, dynamic> draftData = {
//         "title": _titleController.text,
//         "description": _descController.text,
//         "videoUrl": videoUrl,
//         "thumbnailUrl": imageUrl,
//         "tags": _tags,
//         "series": _series,
//         "episodeNumber": _episodeNumber,
//         "category": _category,
//         "visibility": _visibility,
//         "publishDate": _publishDate,
//         "status": "draft",
//         "createdAt": FieldValue.serverTimestamp(),
//       };

//       await _firebaseFirestore.collection("drafts").add(draftData);

//       widget.showPopup('Draft Saved Successfully!');
//       _resetForm();
//     } catch (e) {
//       widget.showPopup('Error saving draft: $e');
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   Future<void> publishEpisode() async {
//     // Validation - check if any required field is missing
//     if (_videoFile == null) {
//       widget.showPopup('Please select a video file!');
//       return;
//     }
//     if (_coverImage == null) {
//       widget.showPopup('Please select a thumbnail image!');
//       return;
//     }
//     if (_titleController.text.isEmpty) {
//       widget.showPopup('Please enter a title!');
//       return;
//     }

//     try {
//       setState(() => _isUploading = true);
//       widget.showPopup('Uploading... Please wait');

//       // Upload video to Firebase Storage
//       String? videoUrl = await uploadFileToStorage(_videoFile!, 'videos');
//       if (videoUrl == null) {
//         widget.showPopup('Failed to upload video');
//         return;
//       }

//       // Upload thumbnail to Firebase Storage
//       String? imageUrl = await uploadFileToStorage(_coverImage!, 'thumbnails');
//       if (imageUrl == null) {
//         widget.showPopup('Failed to upload thumbnail');
//         return;
//       }

//       // Prepare data for Firestore
//       Map<String, dynamic> episodeData = {
//         "title": _titleController.text,
//         "description": _descController.text,
//         "videoUrl": videoUrl,
//         "thumbnailUrl": imageUrl,
//         "tags": _tags,
//         "series": _series,
//         "episodeNumber": _episodeNumber,
//         "category": _category,
//         "visibility": _visibility,
//         "publishDate": _publishDate,
//         "status": "published",
//         "createdAt": FieldValue.serverTimestamp(),
//         "views": 0,
//         "likes": 0,
//       };

//       // Add to Firestore
//       await _firebaseFirestore.collection("episodes").add(episodeData);

//       widget.showPopup('Episode Published Successfully!');
//       _resetForm();
//     } catch (e) {
//       widget.showPopup('Error publishing episode: $e');
//     } finally {
//       setState(() {
//         _isUploading = false;
//         _uploadProgress = 0.0;
//       });
//     }
//   }

//   void _resetForm() {
//     setState(() {
//       _videoFile = null;
//       _coverImage = null;
//       _titleController.clear();
//       _descController.clear();
//       _tagController.clear();
//       _series = null;
//       _episodeNumber = null;
//       _tags.clear();
//       _visibility = 'Public';
//       _category = 'Technical';
//       _publishDate = DateTime.now();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Video File',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: _isUploading ? null : pickVideo,
//                 child: Container(
//                   height: 60,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black54),
//                     borderRadius: BorderRadius.circular(8),
//                     color: _isUploading ? Colors.grey[200] : null,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     _videoFile != null
//                         ? _videoFile!.path.split('/').last
//                         : 'Drag & drop or browse video',
//                     style: const TextStyle(color: Colors.black54),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               const Text(
//                 'Thumbnail Art',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: _isUploading ? null : pickCoverImage,
//                 child: Container(
//                   height: 120,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black54),
//                     borderRadius: BorderRadius.circular(8),
//                     image: _coverImage != null
//                         ? DecorationImage(
//                             image: FileImage(_coverImage!),
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                   ),
//                   child: _coverImage == null
//                       ? const Center(
//                           child: Text(
//                             'Upload thumbnail image\nJPG/PNG, 3000x3000 recommended',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.black54),
//                           ),
//                         )
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               const Text(
//                 'Title',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _titleController,
//                 enabled: !_isUploading,
//                 decoration: InputDecoration(
//                   hintText: 'Enter episode title',
//                   hintStyle: const TextStyle(color: Colors.black54),
//                   filled: true,
//                   fillColor: const Color(0xFFF4F4F4),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
//               const SizedBox(height: 16),

//               const Text(
//                 'Description',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _descController,
//                 enabled: !_isUploading,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   hintText: 'Write a short description...',
//                   hintStyle: const TextStyle(color: Colors.black54),
//                   filled: true,
//                   fillColor: const Color(0xFFF4F4F4),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
//               const SizedBox(height: 16),

//               const Text(
//                 'Tags',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _tagController,
//                 enabled: !_isUploading,
//                 decoration: InputDecoration(
//                   hintText: 'Enter tags separated by commas or spaces',
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.add),
//                     onPressed: _isUploading ? null : addTagsFromInput,
//                   ),
//                   filled: true,
//                   fillColor: const Color(0xFFF4F4F4),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//                 onSubmitted: (_) => addTagsFromInput(),
//               ),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 8,
//                 children: _tags
//                     .map(
//                       (tag) => Chip(
//                         label: Text(tag),
//                         backgroundColor: Colors.blueAccent.shade100,
//                         labelStyle: const TextStyle(color: Colors.black),
//                         onDeleted: _isUploading ? null : () => removeTag(tag),
//                       ),
//                     )
//                     .toList(),
//               ),
//               const SizedBox(height: 16),

//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: _series,
//                       items: _seriesList
//                           .map(
//                             (s) => DropdownMenuItem(
//                               value: s,
//                               child: Text(
//                                 s,
//                                 style: const TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: _isUploading
//                           ? null
//                           : (value) => setState(() => _series = value),
//                       dropdownColor: Colors.white,
//                       decoration: InputDecoration(
//                         labelText: 'Series',
//                         labelStyle: const TextStyle(color: Colors.black54),
//                         filled: true,
//                         fillColor: const Color(0xFFF4F4F4),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextField(
//                       enabled: !_isUploading,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Episode Number',
//                         labelStyle: const TextStyle(color: Colors.black54),
//                         filled: true,
//                         fillColor: const Color(0xFFF4F4F4),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       style: const TextStyle(color: Colors.black),
//                       onChanged: (value) =>
//                           _episodeNumber = int.tryParse(value),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               const Text(
//                 'Category',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: _category,
//                 items: _categoryOptions
//                     .map(
//                       (cat) => DropdownMenuItem(
//                         value: cat,
//                         child: Text(
//                           cat,
//                           style: const TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: _isUploading
//                     ? null
//                     : (value) => setState(() => _category = value!),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0xFFF4F4F4),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Row(
//                 children: [
//                   const Text(
//                     'Publish Date: ',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: _isUploading ? null : pickPublishDate,
//                     child: Text(
//                       DateFormat('MMM dd, yyyy – hh:mm a').format(_publishDate),
//                       style: const TextStyle(color: Colors.blueAccent),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               Row(
//                 children: [
//                   const Text(
//                     'Visibility: ',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     value: _visibility,
//                     dropdownColor: Colors.white,
//                     items: _visibilityOptions
//                         .map(
//                           (v) => DropdownMenuItem(
//                             value: v,
//                             child: Text(
//                               v,
//                               style: const TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: _isUploading
//                         ? null
//                         : (value) => setState(() => _visibility = value!),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 24),

//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isUploading ? null : saveDraft,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[300],
//                         foregroundColor: Colors.black,
//                       ),
//                       child: const Text('Save Draft'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isUploading ? null : publishEpisode,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                       ),
//                       child: const Text('Publish Episode'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         if (_isUploading)
//           Container(
//             color: Colors.black54,
//             child: Center(
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const CircularProgressIndicator(),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       LinearProgressIndicator(value: _uploadProgress),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descController.dispose();
//     _tagController.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UplodePageContent extends StatefulWidget {
  final void Function(String message) showPopup;
  const UplodePageContent({Key? key, required this.showPopup})
    : super(key: key);

  @override
  State<UplodePageContent> createState() => _UplodePageContentState();
}

class _UplodePageContentState extends State<UplodePageContent> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _tagController = TextEditingController();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  File? _videoFile;
  File? _coverImage;
  String? _series;
  int? _episodeNumber;
  DateTime _publishDate = DateTime.now();
  String _visibility = 'Public';
  String _category = 'Technical';
  List<String> _tags = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  final List<String> _seriesList = ['Show A', 'Show B', 'Show C'];
  final List<String> _visibilityOptions = ['Public', 'Private', 'Unlisted'];
  final List<String> _categoryOptions = [
    'Technical',
    'Sport',
    'Political',
    'Educational',
    'Others',
  ];

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      setState(() => _videoFile = File(result.files.single.path!));
    }
  }

  Future<void> pickCoverImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _coverImage = File(image.path));
  }

  Future<void> pickPublishDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _publishDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_publishDate),
      );
      if (time != null) {
        setState(() {
          _publishDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void addTagsFromInput() {
    final text = _tagController.text.trim();
    if (text.isEmpty) return;
    final splitTags = text
        .split(RegExp(r'[ ,]+'))
        .where((t) => t.isNotEmpty)
        .toList();
    setState(() {
      for (var tag in splitTags) {
        if (!_tags.contains(tag)) _tags.add(tag);
      }
    });
    _tagController.clear();
  }

  void removeTag(String tag) => setState(() => _tags.remove(tag));

  Future<String?> uploadFileToStorage(File file, String folderName) async {
    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      Reference storageRef = _firebaseStorage.ref().child(
        '$folderName/$fileName',
      );

      // Set metadata to help with uploads
      final metadata = SettableMetadata(
        contentType: folderName.contains('video') ? 'video/mp4' : 'image/jpeg',
        customMetadata: {'uploaded': DateTime.now().toString()},
      );

      UploadTask uploadTask = storageRef.putFile(file, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (mounted) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        }
      });

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      if (taskSnapshot.state == TaskState.success) {
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        print('Upload failed with state: ${taskSnapshot.state}');
        return null;
      }
    } catch (e) {
      print('Error uploading file: $e');
      widget.showPopup('Upload error: ${e.toString()}');
      return null;
    }
  }

  Future<void> saveDraft() async {
    if (_titleController.text.isEmpty) {
      widget.showPopup('Please add a title to save draft');
      return;
    }

    try {
      setState(() => _isUploading = true);

      String? videoUrl;
      String? imageUrl;

      if (_videoFile != null) {
        videoUrl = await uploadFileToStorage(_videoFile!, 'drafts/videos');
      }
      if (_coverImage != null) {
        imageUrl = await uploadFileToStorage(_coverImage!, 'drafts/thumbnails');
      }

      Map<String, dynamic> draftData = {
        "title": _titleController.text,
        "description": _descController.text,
        "videoUrl": videoUrl,
        "thumbnailUrl": imageUrl,
        "tags": _tags,
        "series": _series,
        "episodeNumber": _episodeNumber,
        "category": _category,
        "visibility": _visibility,
        "publishDate": _publishDate,
        "status": "draft",
        "createdAt": FieldValue.serverTimestamp(),
      };

      await _firebaseFirestore.collection("drafts").add(draftData);

      widget.showPopup('Draft Saved Successfully!');
      _resetForm();
    } catch (e) {
      widget.showPopup('Error saving draft: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> publishEpisode() async {
    // Validation - check if any required field is missing
    if (_videoFile == null) {
      widget.showPopup('Please select a video file!');
      return;
    }
    if (_coverImage == null) {
      widget.showPopup('Please select a thumbnail image!');
      return;
    }
    if (_titleController.text.isEmpty) {
      widget.showPopup('Please enter a title!');
      return;
    }

    try {
      setState(() => _isUploading = true);
      widget.showPopup('Uploading... Please wait');

      // Upload video to Firebase Storage
      String? videoUrl = await uploadFileToStorage(_videoFile!, 'videos');
      if (videoUrl == null) {
        widget.showPopup('Failed to upload video');
        return;
      }

      // Upload thumbnail to Firebase Storage
      String? imageUrl = await uploadFileToStorage(_coverImage!, 'thumbnails');
      if (imageUrl == null) {
        widget.showPopup('Failed to upload thumbnail');
        return;
      }

      // Prepare data for Firestore
      Map<String, dynamic> episodeData = {
        "title": _titleController.text,
        "description": _descController.text,
        "videoUrl": videoUrl,
        "thumbnailUrl": imageUrl,
        "tags": _tags,
        "series": _series,
        "episodeNumber": _episodeNumber,
        "category": _category,
        "visibility": _visibility,
        "publishDate": _publishDate,
        "status": "pending", // Changed from "published" to "pending"
        "createdAt": FieldValue.serverTimestamp(),
        "views": 0,
        "likes": 0,
      };

      // Add to Firestore
      await _firebaseFirestore.collection("episodes").add(episodeData);

      widget.showPopup('Episode Published Successfully!');
      _resetForm();
    } catch (e) {
      widget.showPopup('Error publishing episode: $e');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _videoFile = null;
      _coverImage = null;
      _titleController.clear();
      _descController.clear();
      _tagController.clear();
      _series = null;
      _episodeNumber = null;
      _tags.clear();
      _visibility = 'Public';
      _category = 'Technical';
      _publishDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Video File',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _isUploading ? null : pickVideo,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                    color: _isUploading ? Colors.grey[200] : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _videoFile != null
                        ? _videoFile!.path.split('/').last
                        : 'Drag & drop or browse video',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Thumbnail Art',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _isUploading ? null : pickCoverImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                    image: _coverImage != null
                        ? DecorationImage(
                            image: FileImage(_coverImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _coverImage == null
                      ? const Center(
                          child: Text(
                            'Upload thumbnail image\nJPG/PNG, 3000x3000 recommended',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Title',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                enabled: !_isUploading,
                decoration: InputDecoration(
                  hintText: 'Enter episode title',
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),

              const Text(
                'Description',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                enabled: !_isUploading,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write a short description...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),

              const Text(
                'Tags',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _tagController,
                enabled: !_isUploading,
                decoration: InputDecoration(
                  hintText: 'Enter tags separated by commas or spaces',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _isUploading ? null : addTagsFromInput,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onSubmitted: (_) => addTagsFromInput(),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.blueAccent.shade100,
                        labelStyle: const TextStyle(color: Colors.black),
                        onDeleted: _isUploading ? null : () => removeTag(tag),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _series,
                      items: _seriesList
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                s,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: _isUploading
                          ? null
                          : (value) => setState(() => _series = value),
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Series',
                        labelStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      enabled: !_isUploading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Episode Number',
                        labelStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) =>
                          _episodeNumber = int.tryParse(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'Category',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                items: _categoryOptions
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(
                          cat,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _isUploading
                    ? null
                    : (value) => setState(() => _category = value!),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    'Publish Date: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _isUploading ? null : pickPublishDate,
                    child: Text(
                      DateFormat('MMM dd, yyyy – hh:mm a').format(_publishDate),
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    'Visibility: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _visibility,
                    dropdownColor: Colors.white,
                    items: _visibilityOptions
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text(
                              v,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _isUploading
                        ? null
                        : (value) => setState(() => _visibility = value!),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : saveDraft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : publishEpisode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text('Publish Episode'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_isUploading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: _uploadProgress),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}
