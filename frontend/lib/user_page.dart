import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPage extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final int followers;
  final int following;

  const UserPage({
    Key? key,
    this.username = "John Doe",
    this.profileImageUrl = "https://placeholder.com/150",
    this.followers = 1234,
    this.following = 567,
  }) : super(key: key);

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
              onPressed: () => print("back"),
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
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  const SizedBox(height: 16),

                  // Username
                  Text(
                    username,
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
                      _buildStatColumn("Followers", followers),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      _buildStatColumn("Following", following),
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
          Image.network(
            'https://placeholder.com/400x300',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
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
