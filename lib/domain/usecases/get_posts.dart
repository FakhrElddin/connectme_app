import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

class GetPosts {
  final PostRepository postRepository;

  GetPosts({required this.postRepository});

  Stream<Either<Failures, List<Post>>> call() {
    return postRepository.getPosts();
  }
}
