import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './news_provider.dart';

class NewsDetailPage extends StatelessWidget {
  final int articleId;
  const NewsDetailPage({super.key, required this.articleId});

  final String txt =
      "This is a dummy paragraph created solely for demonstration purposes. The application you are using has been developed by Aziz Ullah, who has put considerable effort into crafting a seamless and user-friendly experience. Please note that the content shown here is placeholder text and does not represent any real or factual information. Due to restrictions imposed by the news API provider, the full content of news articles cannot be displayed within the app. This limitation ensures compliance with copyright laws and respects the intellectual property of the original publishers. Consequently, only summaries or excerpts of news articles are accessible, and the rest of the content remains unavailable to users. Aziz Ullah has designed this app with a focus on functionality, speed, and efficient handling of news data. The app fetches and presents news headlines, brief descriptions, and relevant metadata, providing users with a snapshot of current events without infringing on copyright restrictions. Dummy lines such as these are useful placeholders when the actual data is restricted or unavailable. They help maintain the visual structure and layout of the app while respecting the boundaries set by data providers. The development process involved integrating multiple APIs, handling data caching, and optimizing performance for a smooth user experience. While the content here is fictitious, it serves as a reminder of the challenges developers face when balancing user needs with legal and ethical considerations. Aziz Ullah continues to update and improve the application to deliver timely, relevant news within these constraints. The app exemplifies a careful approach to content presentation, ensuring that users are informed while content rights are preserved. Users are encouraged to visit original news sources for full articles and in-depth reporting. This dummy text underscores the importance of respecting content ownership in the digital age. As the app evolves, more features will be added, but the respect for copyright will remain paramount. Aziz Ullah’s dedication to creating an informative platform is evident in the design and thoughtful handling of content limitations. The use of placeholder text helps developers and testers visualize how the app behaves in real-world scenarios. Finally, these dummy lines emphasize the collaborative effort between technology and legal compliance that shapes modern news delivery platforms.";

  int estimateReadingTimeSeconds(String text) {
    const int charsPerMinute = 1200;
    int length = text.length;
    double minutes = length / charsPerMinute;
    return (minutes * 60).ceil();
  }

  String cleanAuthorname(String? input) {
    input ??= 'ParityPoint';
    int commaIndex = input.indexOf(',');
    if (commaIndex != -1) {
      return input.substring(0, commaIndex);
    } else if (input.length > 18) {
      return input.substring(0, 18);
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    final article =
        Provider.of<NewsProvider>(context, listen: false).articles[articleId];
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              article['cover_image'] ??
                  'https://i.postimg.cc/zVn2MjpZ/imageholder.jpg',
              fit: BoxFit.cover,
              height: 200,
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 180),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(12, 12, 12, 1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        '${article['title']}',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.85),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '• ${estimateReadingTimeSeconds(article['content'])} minutes',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(126, 126, 129, 1),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            cleanAuthorname(article['author']),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(126, 126, 129, 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        article['content'] + txt,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(255, 255, 255, 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // AppBar icons (optional)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Icon(Icons.bookmark_border, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
