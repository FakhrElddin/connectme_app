import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  final List<Map<String, dynamic>> _dummyPosts = const [
    {
      'authorName': 'Thanh Pham',
      'timestamp': '1 hour ago',
      'content': 'Sunset at the city center today was completely breathtaking! Who else was there? 🌇✨',
      'imageUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
      'likesCount': 125,
      'commentsCount': 20,
      'isLiked': true,
    },
    {
      'authorName': 'Sarah Connor',
      'timestamp': '3 hours ago',
      'content': 'Excited to announce our upcoming Flutter developer community meetup this Saturday! RSVP now on the map tab. 🚀💙',
      'imageUrl': 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=800&q=80',
      'likesCount': 89,
      'commentsCount': 14,
      'isLiked': false,
    },
    {
      'authorName': 'Omar Khalil',
      'timestamp': '5 hours ago',
      'content': 'Clean architecture is not just about structure, it is about maintaining long-term development velocity and clarity. 📱💻',
      'imageUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
      'likesCount': 240,
      'commentsCount': 42,
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.homeBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 150),
                itemCount: _dummyPosts.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    authorName: _dummyPosts[index]['authorName'],
                    postTime: _dummyPosts[index]['timestamp'],
                    postImage: _dummyPosts[index]['imageUrl'],
                    likesCount: _dummyPosts[index]['likesCount'],
                    commentsCount: _dummyPosts[index]['commentsCount'],
                    isLiked: _dummyPosts[index]['isLiked'],
                    onLikeTap: () {},
                    onCommentTap: () {},
                    onShareTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
