import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/data/datasources/firestore_post_datasource.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

class PostRepositoryImpl implements PostRepository {
  final FirestorePostDatasource firestorePostDatasource;

  PostRepositoryImpl({required this.firestorePostDatasource});
  @override
  Future<Either<Failures, Unit>> createPost({
    required Post post,
    required String localImagePath,
  }) async {
    var either = await firestorePostDatasource.createPost(
      post: post,
      localImagePath: localImagePath,
    );
    return either.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failures, List<Post>>> getPosts() async {
    var either = await firestorePostDatasource.getPosts();
    return either.fold((failure) => Left(failure), (posts) => Right(posts));
  }
}
