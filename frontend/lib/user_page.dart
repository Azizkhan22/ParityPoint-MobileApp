import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? imageurl;
  @override
  Widget build(BuildContext context) {
    imageurl = Provider.of<UserState>(context, listen: false).user?.imageURL;
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
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          imageurl ?? 'assets/images/avatar.png',
                        ),
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
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                                maxWidth: 512,
                                maxHeight: 512,
                                imageQuality: 75,
                              );

                              if (image != null) {
                                final userState = Provider.of<UserState>(
                                  context,
                                  listen: false,
                                );

                                final fileName = '${userState.user!.email}.jpg';
                                final savedImage = File(
                                  'assets/images/$fileName',
                                );
                                // Copy the image to app directory
                                await File(image.path).copy(savedImage.path);

                                // Create URL for local server
                                final imageUrl = 'assets/images/$fileName';

                                // Send update to local server
                                final response = await http.post(
                                  Uri.parse(
                                    'http://localhost:3000/user/update-image',
                                  ),
                                  headers: {'Content-Type': 'application/json'},
                                  body: json.encode({
                                    'email': userState.user!.email,
                                    'imageURL': imageUrl,
                                  }),
                                );
                                final responseData = json.decode(response.body);
                                print(responseData);
                                if (response.statusCode == 200) {
                                  userState.updateImage(imageUrl);
                                  setState(() {
                                    imageurl = imageUrl;
                                  });
                                }
                              }
                            },
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
                        "Followers",
                        Provider.of<UserState>(
                              context,
                              listen: false,
                            ).user?.followers.length ??
                            0,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Posts Section
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual post count
                itemBuilder: (context, index) {
                  return _buildPostCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(255, 255, 255, 0.8),
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
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
