import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './blogCard.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../blog_post.dart';

class BlogSection extends StatefulWidget {
  const BlogSection({super.key});

  @override
  State<BlogSection> createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  List<Map<String, dynamic>>? blogsToShow;
  bool isLoading = false;

  Future<void> fetchHomeBlogs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // GET typically returns 200, not 201
        final responseData = json.decode(response.body);
        setState(() {
          blogsToShow = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching blogs: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHomeBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Blogs',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(255, 255, 255, 0.85),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              isLoading
                  ? Container(
                    constraints: BoxConstraints(minHeight: 100, minWidth: 100),
                    alignment: Alignment.center,
                    child: SpinKitThreeBounce(
                      color: Color.fromRGBO(255, 209, 26, 1),
                      size: 30,
                    ),
                  )
                  : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                          blogsToShow?.map((blog) {
                            // Parse the date string to DateTime
                            final DateTime createdAt = DateTime.parse(
                              blog['createdAt'],
                            );
                            final Duration difference = DateTime.now()
                                .difference(createdAt);

                            // Calculate time ago string
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
                                            title: blog['title'] ?? '',
                                            content: blog['content'] ?? '',
                                            blogImage: blog['imageURL'],
                                            authorName:
                                                blog['author']['name'] ??
                                                'Anonymous',
                                            authorImageUrl:
                                                blog['author']['image'], // Add this line
                                          ),
                                    ),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 9.0,
                                ),
                                child: SizedBox(
                                  width: 260, // Fixed width for each card
                                  child: BlogCard(
                                    title: blog['title'] ?? '',
                                    content: blog['content'] ?? '',
                                    blogImage: blog['imageURL'],
                                    authorName:
                                        blog['author']['name'] ?? 'Anonymous',
                                    authorImageUrl: blog['author']['image'],
                                    timeAgo: timeAgo,
                                  ),
                                ),
                              ),
                            );
                          }).toList() ??
                          [],
                    ),
                  ),
        ),
      ],
    );
  }
}
