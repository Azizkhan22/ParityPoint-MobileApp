import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/blog_post.dart';
import 'package:frontend/custom/bottomNavigationBar.dart';
import 'package:frontend/service_locator.dart';
import 'package:frontend/user_state.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'custom/blog_snippet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final appState = getIt<AppState>();
  String section = 'All';
  List<Map<String, dynamic>>? blogsToShow;
  List<Map<String, dynamic>>? userBlogs;
  List<Map<String, dynamic>>? followingBlogs;
  List<Map<String, dynamic>>? programmingBlogs;
  List<Map<String, dynamic>>? recentBlogs;
  List<Map<String, dynamic>>? allBlogs;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? blogImage;
  String? userId;
  bool _isLoading = false;

  Future<void> fetchBlogs() async {
    print('test1');
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(
          'https://12182293-5eb9-46c5-b253-aa80a5c694ad-00-myzx9t4jcrr0.sisko.replit.dev/posts/get-posts',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': Provider.of<UserState>(context, listen: false).user?.id,
        }),
      );
      print('testnew');
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('All Blogs Structure:');
        if (responseData['allBlogs'].isNotEmpty) {
          print('First blog sample:');
          print('Type: ${responseData['allBlogs'][0].runtimeType}');
          print('Keys: ${responseData['allBlogs'][0].keys}');
          print('Sample blog: ${json.encode(responseData['allBlogs'][0])}');
        }
        setState(() {
          userBlogs = List.castFrom(responseData['userBlogs']);
          followingBlogs = List.castFrom(responseData['followingBlogs']);
          programmingBlogs = List.castFrom(responseData['programmingBlogs']);
          recentBlogs = List.castFrom(responseData['recentBlogs']);
          allBlogs = List.castFrom(responseData['allBlogs']);
        });
      } else {
        throw Exception('Something went wrong: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
        blogsToShow = allBlogs;
      });
    }
  }

  Color color(String idx) {
    return (section == idx) ? Color.fromRGBO(255, 209, 26, 1) : Colors.grey;
  }

  Future<void> createPost() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(
          'https://12182293-5eb9-46c5-b253-aa80a5c694ad-00-myzx9t4jcrr0.sisko.replit.dev/posts/',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': titleController.text,
          'content': contentController.text,
          'imageURL': blogImage,
          'author': userId,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post Created successfully')));
      }
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (e) {
      print("Error:$e , Please try again");
    } finally {
      fetchBlogs();
    }
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

        // Get the app's documents directory (writable)
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String savedImagePath = path.join(appDir.path, fileName);

        final File savedImage = await File(image.path).copy(savedImagePath);
        print('Saved to: $savedImagePath');

        setState(() {
          blogImage = savedImagePath;
          userId =
              Provider.of<UserState>(context, listen: false).user?.id ??
              'default';
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
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
                                  child: Image.file(
                                    File(blogImage!),
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
                              Navigator.pop(context);
                              createPost();
                              titleController.clear();
                              contentController.clear();
                              setState(() {
                                blogImage = null;
                              });
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
  void initState() {
    super.initState();
    userId = Provider.of<UserState>(context, listen: false).user?.id;
    blogsToShow = [];
    fetchBlogs();
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
            constraints: BoxConstraints(minHeight: 800),
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
              // Add this in your AppBar actions
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap:
                                () => setState(() {
                                  section = 'All';
                                  blogsToShow = allBlogs;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: color('All'),
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
                                  section = 'Recent';
                                  blogsToShow = recentBlogs;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color('Recent'),
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
                                  section = 'Following';
                                  blogsToShow = followingBlogs;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color('Following'),
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
                                  section = 'Programming';
                                  blogsToShow = programmingBlogs;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color('Programming'),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Programming',
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
                                  section = 'My Blogs';
                                  blogsToShow = userBlogs;
                                }),
                            child: Container(
                              constraints: BoxConstraints(minWidth: 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color('My Blogs'),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'My Blogs',
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
                    _isLoading
                        ? Container(
                          constraints: BoxConstraints(
                            minHeight: 300,
                            minWidth: 100,
                          ),
                          alignment: Alignment.center,
                          child: SpinKitThreeBounce(
                            color: Color.fromRGBO(255, 209, 26, 1),
                            size: 30,
                          ),
                        )
                        : Column(
                          children:
                              ( // Safe null check
                                  (blogsToShow?.isEmpty ?? true))
                                  ? [
                                    Container(
                                      width: 400,
                                      height: 200,
                                      child: Center(
                                        child: Text(
                                          'No Blogs available to show',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                              158,
                                              158,
                                              158,
                                              0.6,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                  : blogsToShow?.map((blog) {
                                        // Parse the date string to DateTime
                                        final DateTime createdAt =
                                            DateTime.parse(blog['createdAt']);
                                        final Duration difference =
                                            DateTime.now().difference(
                                              createdAt,
                                            );

                                        // Calculate time ago string
                                        String timeAgo;
                                        if (difference.inDays > 0) {
                                          timeAgo =
                                              '${difference.inDays} days ago';
                                        } else if (difference.inHours > 0) {
                                          timeAgo =
                                              '${difference.inHours} hrs ago';
                                        } else {
                                          timeAgo =
                                              '${difference.inMinutes} mins ago';
                                        }

                                        return GestureDetector(
                                          onTap:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => BlogDetailPage(
                                                        timeAgo: timeAgo,
                                                        title:
                                                            blog['title'] ?? '',
                                                        content:
                                                            blog['content'] ??
                                                            '',
                                                        blogImage:
                                                            blog['imageURL'],
                                                        authorName:
                                                            blog['author']['name'] ??
                                                            'Anonymous',
                                                        authorImageUrl:
                                                            blog['author']['image'],
                                                      ),
                                                ),
                                              ),
                                          child: BlogSnippet(
                                            title: blog['title'] ?? '',
                                            content: blog['content'] ?? '',
                                            blogImage: blog['imageURL'],
                                            authorName:
                                                blog['author']['name'] ??
                                                'Anonymous',
                                            authorImageUrl:
                                                blog['author']['image'],
                                            timeAgo: timeAgo,
                                          ),
                                        );
                                      }).toList() ??
                                      [],
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
