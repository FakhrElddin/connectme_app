import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

class CreatePost {
  final PostRepository postRepository;

  CreatePost({required this.postRepository});

  Future<Either<Failures, Unit>> call({
    required Post post,
    required String localImagePath,
  }) {
    return postRepository.createPost(
      post: post,
      localImagePath: localImagePath,
    );
  }
}
