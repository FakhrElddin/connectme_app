import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

abstract class FirestorePostDatasource {
  Future<Either<Failures, Unit>> createPost({
    required Post post,
    required String localImagePath,
  });

  Future<Either<Failures, List<Post>>> getPosts();
}

class FirestorePostDatasourceImpl implements FirestorePostDatasource {
  @override
  Future<Either<Failures, Unit>> createPost({
    required Post post,
    required String localImagePath,
  }) {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, List<Post>>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
}
