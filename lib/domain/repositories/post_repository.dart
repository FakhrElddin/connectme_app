import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  Future<Either<Failures, Unit>> createPost({
    required Post post,
    required String localImagePath,
  });

  Future<Either<Failures, List<Post>>> getPosts();
}
