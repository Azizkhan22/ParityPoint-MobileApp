import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'blog_post.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'dart:io';

class OtherUserPage extends StatefulWidget {
  final String userId;

  const OtherUserPage({Key? key, required this.userId}) : super(key: key);

  @override
  _OtherUserPageState createState() => _OtherUserPageState();
}

class _OtherUserPageState extends State<OtherUserPage> {
  bool isLoading = false;
  List<Map<String, dynamic>>? userPosts;
  Map<String, dynamic>? userData;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final currentUserId =
          Provider.of<UserState>(context, listen: false).user?.id;
      final response = await http.post(
        Uri.parse(
          'https://12182293-5eb9-46c5-b253-aa80a5c694ad-00-myzx9t4jcrr0.sisko.replit.dev/posts/other-user',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': widget.userId,
          'currentUserId': currentUserId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          userPosts = List<Map<String, dynamic>>.from(responseData['posts']);
          userData = responseData['userData'];
          isFollowing = responseData['isFollowing'];
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleFollowAction() async {
    try {
      final endpoint = isFollowing ? 'unfollow' : 'follow';
      final response = await http.post(
        Uri.parse(
          'https://12182293-5eb9-46c5-b253-aa80a5c694ad-00-myzx9t4jcrr0.sisko.replit.dev/user/$endpoint',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': Provider.of<UserState>(context, listen: false).user?.id,
          'targetUserId': widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFollowing = !isFollowing;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Add this helper method
  ImageProvider _getImageProvider(String? imageUrl, bool isAvatar) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return AssetImage(
        isAvatar ? 'assets/images/avatar.png' : 'assets/images/imageholder.jpg',
      );
    }

    if (imageUrl.startsWith('/') || imageUrl.contains('data/user')) {
      return FileImage(File(imageUrl));
    }

    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }

    return AssetImage(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 12, 1),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(255, 209, 26, 1),
                ),
              )
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromRGBO(43, 43, 43, 0.4),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _getImageProvider(
                            userData?['image'],
                            true,
                          ),
                          onBackgroundImageError: (exception, stackTrace) {
                            print('Error loading avatar: $exception');
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          userData?['name'] ?? 'User',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _handleFollowAction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isFollowing
                                    ? Colors.transparent
                                    : Color.fromRGBO(255, 209, 26, 1),
                            minimumSize: Size(120, 36),
                            side: BorderSide(
                              color:
                                  isFollowing
                                      ? Colors.grey
                                      : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            isFollowing ? 'Following' : 'Follow',
                            style: TextStyle(
                              color: isFollowing ? Colors.grey : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Posts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = userPosts![index];

                      // Calculate timeAgo
                      final DateTime createdAt = DateTime.parse(
                        post['createdAt'],
                      );
                      final Duration difference = DateTime.now().difference(
                        createdAt,
                      );
                      String timeAgo;

                      if (difference.inDays > 0) {
                        timeAgo = '${difference.inDays} days ago';
                      } else if (difference.inHours > 0) {
                        timeAgo = '${difference.inHours} hours ago';
                      } else {
                        timeAgo = '${difference.inMinutes} minutes ago';
                      }

                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlogDetailPage(
                                      title: post['title'],
                                      content: post['content'],
                                      blogImage: post['imageURL'],
                                      authorName:
                                          userData?['name'] ?? 'Anonymous',
                                      authorImageUrl: userData?['image'],
                                      timeAgo: timeAgo, // Add this parameter
                                    ),
                              ),
                            ),
                        child: Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(18, 18, 18, 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post['imageURL'] != null)
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: Builder(
                                    builder: (context) {
                                      final imageUrl = post['imageURL'];
                                      if (imageUrl != null &&
                                          (imageUrl.startsWith('/') ||
                                              imageUrl.contains('data/user'))) {
                                        return Image.file(
                                          File(imageUrl),
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            print(
                                              'Error loading post image: $error',
                                            );
                                            return Container(
                                              color: Color.fromRGBO(
                                                26,
                                                26,
                                                26,
                                                1,
                                              ),
                                              child: Image.asset(
                                                'assets/images/imageholder.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      return Image(
                                        image: _getImageProvider(
                                          imageUrl,
                                          false,
                                        ),
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          print(
                                            'Error loading post image: $error',
                                          );
                                          return Container(
                                            color: Color.fromRGBO(
                                              26,
                                              26,
                                              26,
                                              1,
                                            ),
                                            child: Image.asset(
                                              'assets/images/imageholder.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: 16),
                              Text(
                                post['title'] ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                post['content'] ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: userPosts?.length ?? 0),
                  ),
                ],
              ),
    );
  }
}
