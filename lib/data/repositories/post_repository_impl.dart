import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/data/datasources/post_datasource.dart';
import 'package:connectme_app/data/datasources/post_datasource_factory.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

/// Design Pattern: Factory Pattern
/// Where applied:
/// [PostRepositoryImpl.fromType] factory constructor utilizes [PostDatasourceFactory]
/// to instantiate the correct [PostDatasource] (remote Firestore vs. local cache) based on [PostDatasourceType].
///
/// Why applied:
/// Decouples repository orchestration from data source instantiation, adhering to the Factory Pattern
/// by providing a clean creation interface while allowing seamless switching between remote and offline datasources.
class PostRepositoryImpl implements PostRepository {
  final PostDatasource postDatasource;

  PostRepositoryImpl({required this.postDatasource});

  factory PostRepositoryImpl.fromType(PostDatasourceType type) {
    return PostRepositoryImpl(
      postDatasource: PostDatasourceFactory.create(type),
    );
  }

  @override
  Future<Either<Failures, Unit>> createPost({
    required Post post,
  }) async {
    var either = await postDatasource.createPost(
      post: post,
    );
    return either.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Stream<Either<Failures, List<Post>>> getPosts() {
    return postDatasource.getPosts();
  }
}
