import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/custom/bottomNavigationBar.dart';
import 'package:frontend/service_locator.dart';
import 'package:frontend/user_state.dart';
import 'package:provider/provider.dart';
import 'custom/blog_snippet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final appState = getIt<AppState>();
  int index = 0;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? blogImage;
  String? userId;

  Color color(int idx) {
    return (index == idx) ? Color.fromRGBO(255, 209, 26, 1) : Colors.grey;
  }

  Future<void> uploadBlogImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      print('image: ${image?.path}');
      if (image != null) {
        final String fileName = path.basename(image.path);
        print('fileName: $fileName');
        final String relativePath = path.join(
          Directory.current.path,
          // '..',
          'assets',
          'images',
          fileName,
        );
        final File savedImage = await File(image.path).copy(relativePath);
        setState(() {
          blogImage = relativePath;
          userId =
              Provider.of<UserState>(context, listen: false).user?.id ??
              'default';
        });
        // // Send update to local server
        // final response = await http.post(
        //   Uri.parse('http://localhost:3000/user/update-image'),
        //   headers: {'Content-Type': 'application/json'},
        //   body: json.encode({
        //     'email': userState.user!.email,
        //     'imageURL': userState.user?.imageURL,
        //   }),
        // );
        // final responseData = json.decode(response.body);
        // print(responseData);
        // if (response.statusCode == 200) {
        //   _reloadWidget();
        // } else {
        //   throw Exception('Error occured');
        // }
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Show error to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes bottom sheet full screen
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height:
                MediaQuery.of(context).size.height *
                0.85, // 85% of screen height
            decoration: BoxDecoration(
              color: Color.fromRGBO(18, 18, 18, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Create New Post',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(255, 209, 26, 1),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 200, // Fixed height
                          // or use constraints for min/max height
                          constraints: BoxConstraints(
                            minHeight: 200,
                            maxHeight: 300,
                          ),
                          child: TextField(
                            controller: contentController,
                            style: TextStyle(color: Colors.white),
                            maxLines: null, // Allows unlimited lines
                            expands:
                                true, // Makes the TextField expand to fill its parent
                            textAlignVertical:
                                TextAlignVertical.top, // Aligns text to top
                            decoration: InputDecoration(
                              hintText: 'Write your post...',
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.all(
                                16,
                              ), // Add padding inside the field
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 209, 26, 1),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            blogImage != null
                                ? Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                    blogImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                uploadBlogImage();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Upload Image',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.file_upload, color: Colors.grey),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty &&
                                contentController.text.isNotEmpty) {
                              // Add your post creation logic here
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(255, 209, 26, 1),
                          ),
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
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

  @override
  void dispose() {
    // Add any controllers you need to dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            constraints: BoxConstraints(minHeight: 600),
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 80),
            color: Color.fromRGBO(12, 12, 12, 1),
          ),
        ),

        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(43, 43, 43, 0.4),
                  ),
                  child: IconButton(
                    onPressed: () => appState.setBottomBarIndex(0),
                    icon: Icon(
                      FontAwesomeIcons.chevronLeft,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(12, 12, 12, 1)),
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 80,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Blogs',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap:
                                () => setState(() {
                                  index = 0;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: color(0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'All',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap:
                                () => setState(() {
                                  index = 1;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color(1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Following',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap:
                                () => setState(() {
                                  index = 2;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color(2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Recent',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap:
                                () => setState(() {
                                  index = 3;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color(3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Self',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    BlogSnippet(
                      timeAgo: '7 min',
                      readTime: '3 min',
                      title: 'aziz ullah khan',
                      authorName: 'khan kakar',
                    ),
                    BlogSnippet(
                      timeAgo: '7 min',
                      readTime: '3 min',
                      title: 'aziz ullah khan',
                      authorName: 'khan kakar',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 100,
          right: 18,
          child: Material(
            // Wrap with Material for proper touch handling
            elevation: 4, // Add some elevation
            color: Color.fromRGBO(255, 209, 26, 1),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              // Use InkWell instead of GestureDetector
              onTap: _showCreatePostDialog, // Direct call to dialog method
              child: Container(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.add, color: Colors.black, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
