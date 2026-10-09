import 'dart:async';

import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/data/datasources/post_datasource.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

abstract class LocalPostDatasource implements PostDatasource {}

class LocalPostDatasourceImpl implements LocalPostDatasource {
  final List<Post> _cachedPosts = [];
  final StreamController<Either<Failures, List<Post>>> _postsController =
      StreamController<Either<Failures, List<Post>>>.broadcast();

  @override
  Future<Either<Failures, Unit>> createPost({required Post post}) async {
    try {
      final newPost = post.postId.isEmpty
          ? Post(
              postId: 'local_${DateTime.now().millisecondsSinceEpoch}',
              authorId: post.authorId,
              authorName: post.authorName,
              authorImage: post.authorImage,
              postImageUrl: post.postImageUrl,
              timestamp: post.timestamp,
              content: post.content,
              likesCount: post.likesCount,
              commentsCount: post.commentsCount,
              isLiked: post.isLiked,
            )
          : post;

      _cachedPosts.insert(0, newPost);
      _postsController.add(Right(List.unmodifiable(_cachedPosts)));
      return const Right(unit);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          errorMessage: 'Failed to save post locally, please try again later',
        ),
      );
    }
  }

  @override
  Stream<Either<Failures, List<Post>>> getPosts() async* {
    yield Right(List.unmodifiable(_cachedPosts));
    yield* _postsController.stream;
  }
}
