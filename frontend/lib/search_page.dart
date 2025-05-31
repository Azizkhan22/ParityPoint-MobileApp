import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'other_user_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _searchResults = [];
  Set<String> followingUsers = {};

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUserId =
          Provider.of<UserState>(context, listen: false).user?.id;

      // Update the URL to include currentUserId as query parameter
      final response = await http.get(
        Uri.parse(
          'http://localhost:3000/user/search?query=$query&userId=$currentUserId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(
            responseData['users'],
          );
          // Initialize followingUsers set with users that current user follows
          followingUsers = Set<String>.from(
            (responseData['following'] as List).map((id) => id.toString()),
          );
        });
      } else {
        throw Exception('Failed to search users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching users: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error searching users: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleFollowAction(String userId) async {
    try {
      final endpoint = followingUsers.contains(userId) ? 'unfollow' : 'follow';
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': Provider.of<UserState>(context, listen: false).user?.id,
          'targetUserId': userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          if (followingUsers.contains(userId)) {
            followingUsers.remove(userId);
          } else {
            followingUsers.add(userId);
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 12, 1),
      appBar: AppBar(
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
              icon: Icon(Icons.arrow_back, size: 20, color: Colors.white),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                  ), // Reduced height
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 209, 26, 1),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(18, 18, 18, 1),
                ),
                onSubmitted: _performSearch,
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(255, 209, 26, 1),
                          ),
                        )
                        : _searchResults.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_outlined,
                                size: 64,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Search for users',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final user = _searchResults[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            OtherUserPage(userId: user['_id']),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(18, 18, 18, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 3,
                                ),
                                child: Card(
                                  color: Color.fromRGBO(18, 18, 18, 1),
                                  elevation: 0,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        user['image'] ??
                                            'assets/images/avatar.png',
                                      ),
                                    ),
                                    title: Text(
                                      user['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed:
                                          () =>
                                              _handleFollowAction(user['_id']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            followingUsers.contains(user['_id'])
                                                ? Colors.transparent
                                                : Color.fromRGBO(
                                                  255,
                                                  209,
                                                  26,
                                                  1,
                                                ),
                                        minimumSize: Size(100, 36),
                                        side: BorderSide(
                                          color:
                                              followingUsers.contains(
                                                    user['_id'],
                                                  )
                                                  ? Colors.grey
                                                  : Colors.transparent,
                                        ),
                                      ),
                                      child: Text(
                                        followingUsers.contains(user['_id'])
                                            ? 'Following'
                                            : 'Follow',
                                        style: TextStyle(
                                          color:
                                              followingUsers.contains(
                                                    user['_id'],
                                                  )
                                                  ? Colors.grey
                                                  : Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
