import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'dart:io';

enum ProfileSection { posts, followers, following }

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ProfileSection currentSection = ProfileSection.posts;
  Key _key = UniqueKey();

  void _reloadWidget() {
    setState(() {
      _key = UniqueKey(); // This forces a complete rebuild
    });
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
        final String relativePath = path.join(
          Directory.current.path,
          // '..',
          'assets',
          'images',
          fileName,
        );
        final File savedImage = await File(image.path).copy(relativePath);
        userState.updateImage('assets/images/$fileName');
        print(userState.user?.imageURL);
        // Send update to local server
        final response = await http.post(
          Uri.parse('http://localhost:3000/user/update-image'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': userState.user!.email,
            'imageURL': userState.user?.imageURL,
          }),
        );
        final responseData = json.decode(response.body);
        print(responseData);
        if (response.statusCode == 200) {
          _reloadWidget();
        } else {
          throw Exception('Error occured');
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Show error to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  Widget _buildSectionContent() {
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
    return ListView.builder(
      itemCount: 10, // Replace with actual posts count
      itemBuilder: (context, index) {
        return _buildPostCard();
      },
    );
  }

  Widget _buildFollowersList() {
    final followers =
        Provider.of<UserState>(context, listen: false).user?.followers ?? [];
    return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index) {
        return _buildUserCard(followers[index]);
      },
    );
  }

  Widget _buildFollowingList() {
    final following =
        Provider.of<UserState>(context, listen: false).user?.following ?? [];
    return ListView.builder(
      itemCount: following.length,
      itemBuilder: (context, index) {
        return _buildUserCard(following[index]);
      },
    );
  }

  Widget _buildUserCard(String userId) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Color.fromRGBO(18, 18, 18, 1),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar.png'),
          radius: 25,
        ),
        title: Text(
          'User Name', // Replace with actual user name
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Handle follow/unfollow
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(255, 209, 26, 1),
            minimumSize: Size(100, 36),
          ),
          child: Text('Follow', style: TextStyle(color: Colors.black)),
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
              onPressed: () => Navigator.popAndPushNamed(context, '/home'),
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
                            backgroundImage:
                                imageUrl != null
                                    ? (imageUrl.startsWith('assets/')
                                        ? AssetImage(imageUrl)
                                        : FileImage(File(imageUrl))
                                            as ImageProvider)
                                    : const AssetImage(
                                      'assets/images/avatar.png',
                                    ),
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
                        10, // Replace with actual posts count
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
                        Provider.of<UserState>(
                              context,
                              listen: false,
                            ).user?.following.length ??
                            0,
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

  Widget _buildPostCard() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image.network(
          //   'https://placeholder.com/400x300',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: 200,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Post Title',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Post description goes here...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
