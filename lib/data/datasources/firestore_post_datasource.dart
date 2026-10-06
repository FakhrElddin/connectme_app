import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/data/models/post_model.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

abstract class FirestorePostDatasource {
  Future<Either<Failures, Unit>> createPost({
    required Post post,
  });

  Stream<Either<Failures, List<Post>>> getPosts();
}

class FirestorePostDatasourceImpl implements FirestorePostDatasource {
  @override
  Future<Either<Failures, Unit>> createPost({
    required Post post,
  }) async {
    try {
      final db = FirebaseFirestore.instance;
      final docRef = db
          .collection("posts")
          .withConverter<PostModel>(
            fromFirestore: (snapshot, options) =>
                PostModel.fromJson(snapshot.data()!),
            toFirestore: (postModel, options) => postModel.toJson(),
          )
          .doc();
      PostModel postModel = PostModel(
        postId: docRef.id,
        authorId: post.authorId,
        authorName: post.authorName,
        authorImage: post.authorImage,
        postImageUrl: post.postImageUrl,
        timestamp: post.timestamp,
        content: post.content,
        likesCount: post.likesCount,
        commentsCount: post.commentsCount,
        isLiked: post.isLiked,
      );
      await docRef.set(postModel);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseException(e));
    } catch (e) {
      return Left(
        UnexpectedFailure(
          errorMessage: 'Failed to create post, please try again later',
        ),
      );
    }
  }

  @override
  Stream<Either<Failures, List<Post>>> getPosts() {
    return FirebaseFirestore.instance
        .collection("posts")
        .withConverter<PostModel>(
          fromFirestore: (snapshot, options) =>
              PostModel.fromJson(snapshot.data()!),
          toFirestore: (postModel, options) => postModel.toJson(),
        )
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map<Either<Failures, List<Post>>>((snapshot) {
          // List<PostModel> posts = [];
          // doc.data() equal post
          // for (var doc in snapshot.docs) {
          //   PostModel singlePost = doc.data();
          //   posts.add(singlePost);
          // }
          final posts = snapshot.docs.map((doc) => doc.data()).toList();
          return Right(posts);
        })
        .handleError((error) {
          if (error is FirebaseException) {
            return Left(FirestoreFailure.fromFirebaseException(error));
          }
          return Left(
            UnexpectedFailure(
              errorMessage: 'Failed to fetch posts, please try again later',
            ),
          );
        });
  }
}
