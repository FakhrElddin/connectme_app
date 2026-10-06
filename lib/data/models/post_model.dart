import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/domain/entities/post.dart';

class PostModel extends Post {
  PostModel({
    required super.postId,
    required super.authorId,
    required super.authorName,
    required super.content,
    required super.timestamp,
    super.postImageUrl,
    super.authorImage,
    super.commentsCount,
    super.isLiked,
    super.likesCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      content: json['content'] ?? '',
      postImageUrl: json['postImageUrl'],
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : (json['timestamp'] is String
                ? DateTime.parse(json['timestamp'])
                : DateTime.now()),
      authorImage: json['authorImage'],
      commentsCount: json['commentsCount'],
      isLiked: json['isLiked'],
      likesCount: json['likesCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'postImageUrl': postImageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'authorImage': authorImage,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'likesCount': likesCount,
    };
  }
}
