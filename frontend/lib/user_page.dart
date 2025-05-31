import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/blog_post.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'blog_page.dart';
import 'dart:io';
import 'other_user_page.dart';

enum ProfileSection { posts, followers, following }

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ProfileSection currentSection = ProfileSection.posts;
  Key _key = UniqueKey();
  bool isLoading = false;
  List<Map<String, dynamic>>? userPosts;
  List<Map<String, dynamic>>? followers;
  List<Map<String, dynamic>>? following;
  int? followingNumber;

  void _reloadWidget() {
    setState(() {
      _key = UniqueKey();
    });
  }

  Future<void> fetchUserallData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(
          'https://12182293-5eb9-46c5-b253-aa80a5c694ad-00-myzx9t4jcrr0.sisko.replit.dev/posts/user-page',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': Provider.of<UserState>(context, listen: false).user?.id,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = Map<String, dynamic>.from(
          json.decode(response.body),
        );
        print(responseData);
        setState(() {
          userPosts = List<Map<String, dynamic>>.from(responseData['posts']);
          followers = List<Map<String, dynamic>>.from(
            responseData['followers'],
          );
          following = List<Map<String, dynamic>>.from(
            responseData['following'],
          );
          followingNumber = following!.length;
        });
      } else {
        throw (Exception('error: ${response.statusCode}'));
      }
    } catch (e) {
      print("error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void uploadUserImage() async {
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
        final userState = Provider.of<UserState>(context, listen: false);

        final String fileName = path.basename(image.path);
        print('fileName: $fileName');

        // ✅ Save to app documents directory
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String savedPath = path.join(appDir.path, fileName);
        final File savedImage = await File(image.path).copy(savedPath);

        // Update image path in app state
        userState.updateImage(savedImage.path); // store the real image path

        print('Image path saved: ${userState.user?.imageURL}');

        // Send update to backend
        final response = await http.post(
          Uri.parse(
            'https://12182293-5eb9-46c5-b253-aa80a5c694ad-00-myzx9t4jcrr0.sisko.replit.dev/user/update-image',
          ),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': userState.user!.email,
            'imageURL':
                savedImage
                    .path, // Or use just the filename if your backend needs that
          }),
        );

        final responseData = json.decode(response.body);
        print(responseData);

        if (response.statusCode == 200) {
          _reloadWidget();
        } else {
          throw Exception('Server error occurred');
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  Widget _buildSectionContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(255, 209, 26, 1),
        ),
      );
    }

    switch (currentSection) {
      case ProfileSection.posts:
        return _buildPostsList();
      case ProfileSection.followers:
        return _buildFollowersList();
      case ProfileSection.following:
        return _buildFollowingList();
    }
  }

  Widget _buildPostsList() {
    if (userPosts == null || userPosts!.isEmpty) {
      return Center(
        child: Text(
          'No posts yet',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: userPosts!.length,
      itemBuilder: (context, index) {
        final post = userPosts![index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildFollowersList() {
    if (followers == null || followers!.isEmpty) {
      return Center(
        child: Text(
          'No followers yet',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: followers!.length,
      itemBuilder: (context, index) {
        final follower = followers![index];
        // Check if we are following this follower
        final bool isFollowingThisUser =
            following?.any((user) => user['_id'] == follower['_id']) ?? false;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserPage(userId: follower['_id']),
              ),
            );
          },
          child: _buildUserCard(
            follower['name'],
            follower['_id'],
            follower['image'],
            isFollowing: isFollowingThisUser, // Use the actual following status
          ),
        );
      },
    );
  }

  Widget _buildFollowingList() {
    if (following == null || following!.isEmpty) {
      return Center(
        child: Text(
          'Not following anyone yet',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: following!.length,
      itemBuilder: (context, index) {
        final followedUser = following![index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OtherUserPage(userId: followedUser['_id']),
              ),
            );
          },
          child: _buildUserCard(
            followedUser['name'],
            followedUser['_id'],
            followedUser['image'],
            isFollowing: true,
          ),
        );
      },
    );
  }

  // Add this helper method near the top of the _UserPageState class
  ImageProvider _getImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage('assets/images/avatar.png');
    }

    if (imageUrl.startsWith('/') || imageUrl.contains('data/user')) {
      return FileImage(File(imageUrl));
    }

    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }

    return AssetImage(imageUrl);
  }

  Widget _buildUserCard(
    String name,
    String userId,
    String? imageUrl, {
    bool isFollowing = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(18, 18, 18, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
      child: Card(
        color: Color.fromRGBO(18, 18, 18, 1),
        elevation: 0,
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: _getImageProvider(imageUrl),
            onBackgroundImageError: (exception, stackTrace) {
              print('Error loading user image: $exception');
            },
          ),
          title: Text(
            name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          trailing: ElevatedButton(
            onPressed: () => _handleFollowAction(userId, isFollowing),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFollowing
                      ? Colors.transparent
                      : Color.fromRGBO(255, 209, 26, 1),
              minimumSize: Size(100, 36),
              side: BorderSide(
                color: isFollowing ? Colors.grey : Colors.transparent,
              ),
            ),
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(
                color: isFollowing ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    // Calculate time ago
    final DateTime createdAt = DateTime.parse(post['createdAt']);
    final Duration difference = DateTime.now().difference(createdAt);
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
                    timeAgo: timeAgo,
                    title: post['title'] ?? '',
                    content: post['content'] ?? '',
                    blogImage: post['imageURL'],
                    authorName: post['author']['name'] ?? 'Anonymous',
                    authorImageUrl: post['author']['image'],
                  ),
            ),
          ),
      child: Card(
        margin: const EdgeInsets.only(top: 12),
        color: Color.fromRGBO(18, 18, 18, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['imageURL'] != null)
              Container(
                width: double.infinity,
                height: 200,
                child: Builder(
                  builder: (context) {
                    final imageUrl = post['imageURL'].toString();
                    if (imageUrl.startsWith('/') ||
                        imageUrl.contains('data/user')) {
                      return Image.file(
                        File(imageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Image.asset(
                            'assets/images/imageholder.jpg',
                            fit: BoxFit.cover,
                            height: 200,
                          );
                        },
                      );
                    }
                    return Image.asset(
                      post['imageURL'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Image.asset(
                          'assets/images/imageholder.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                        );
                      },
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'] ?? 'Untitled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    post['content'] ?? 'No content',
                    style: TextStyle(color: Colors.grey[300]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modify the _buildStatColumn to make it tappable
  Widget _buildStatColumn(String label, int count, ProfileSection section) {
    final bool isSelected = currentSection == section;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentSection = section;
        });
      },
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  isSelected
                      ? Color.fromRGBO(255, 209, 26, 1)
                      : Color.fromRGBO(255, 255, 255, 0.8),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color.fromRGBO(255, 209, 26, 1) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserallData();
  }

  @override
  void dispose() {
    // Clean up any controllers or streams
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(12, 12, 12, 1),
        foregroundColor: Color.fromRGBO(255, 255, 255, 0.8),
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
                FontAwesomeIcons.chevronLeft,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(12, 12, 12, 1),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Consumer<UserState>(
                        builder: (context, userState, child) {
                          final imageUrl = userState.user?.imageURL;
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: _getImageProvider(imageUrl),
                            key: ValueKey(imageUrl),
                            onBackgroundImageError: (exception, stackTrace) {
                              print('Error loading image: $exception');
                            },
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: () => uploadUserImage(),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Username
                  Text(
                    Provider.of<UserState>(context, listen: false).user?.name ??
                        'Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Followers and Following
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatColumn(
                        "Posts",
                        userPosts?.length ?? 0,
                        ProfileSection.posts,
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      _buildStatColumn(
                        "Followers",
                        Provider.of<UserState>(
                              context,
                              listen: false,
                            ).user?.followers.length ??
                            0,
                        ProfileSection.followers,
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      _buildStatColumn(
                        "Following",
                        followingNumber ?? 0,
                        ProfileSection.following,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Posts Section
            const Divider(height: 1),
            Expanded(child: _buildSectionContent()),
          ],
        ),
      ),
    );
  }

  // Add this method to handle follow/unfollow actions
  Future<void> _handleFollowAction(
    String userId,
    bool isCurrentlyFollowing,
  ) async {
    try {
      final endpoint = isCurrentlyFollowing ? 'unfollow' : 'follow';
      final response = await http.post(
        Uri.parse(
          'https://12182293-5eb9-46c5-b253-aa80a5c694ad-00-myzx9t4jcrr0.sisko.replit.dev/user/$endpoint',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': Provider.of<UserState>(context, listen: false).user?.id,
          'targetUserId': userId,
        }),
      );

      if (response.statusCode == 200) {
        // This will update all data including the following number
        await fetchUserallData();
      } else {
        throw Exception('Failed to ${endpoint} user');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
