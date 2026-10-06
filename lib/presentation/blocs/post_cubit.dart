import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/usecases/create_post.dart';
import 'package:connectme_app/domain/usecases/get_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPosts getPostsUsecase;
  final CreatePost createPostUsecase;
  StreamSubscription? _postsSubscription;

  PostCubit({required this.getPostsUsecase, required this.createPostUsecase})
    : super(PostInitial());

  void createPost({required String content}) async {
    emit(CreatePostLoading());
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    String authorName = userDoc.data()!['name'];
    Post post = Post(
      postId: '',
      authorId: currentUser.uid,
      authorName: authorName,
      content: content,
      postImageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&auto=format&fit=crop&q=80',
      timestamp: DateTime.now(),
    );
    var either = await createPostUsecase.call(post: post);
    either.fold(
      (failure) => emit(CreatePostError(failure: failure)),
      (_) => emit(CreatePostSuccess()),
    );
  }

  void getPosts() {
    emit(GetPostsLoading());
    print('=========> after loading and before cancel');
    _postsSubscription?.cancel();
    print('=========> after loading and after cancel');

    _postsSubscription = getPostsUsecase.call().listen((either) {
      print('=========> after loading and inside listen');

      either.fold(
        (failure) => emit(GetPostsError(failure: failure)),
        (posts) => emit(GetPostsLoaded(posts: posts)),
      );
    });
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
