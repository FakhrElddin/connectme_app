class Post {
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String? content;
  final String postImageUrl;
  final DateTime timestamp;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  const Post({
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    this.content,
    required this.postImageUrl,
    required this.timestamp,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
  });
}
