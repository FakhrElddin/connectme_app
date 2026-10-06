part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class GetPostsLoading extends PostState {}

final class GetPostsLoaded extends PostState {
  final List<Post> posts;

  GetPostsLoaded({required this.posts});
}

final class GetPostsError extends PostState {
  final Failures failure;

  GetPostsError({required this.failure});
}

final class CreatePostLoading extends PostState {}

final class CreatePostSuccess extends PostState {}

final class CreatePostError extends PostState {
  final Failures failure;
  CreatePostError({required this.failure});
}
