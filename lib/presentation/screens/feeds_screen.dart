import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/presentation/blocs/post_cubit.dart';
import 'package:connectme_app/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.homeBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<PostCubit, PostState>(
                buildWhen: (previous, current) {
                  return current is GetPostsLoading ||
                      current is GetPostsError ||
                      current is GetPostsLoaded;
                },
                builder: (context, state) {
                  if (state is GetPostsError) {
                    return FeedErrorWidget(
                      message: state.failure.errorMessage,
                      onRetry: () => context.read<PostCubit>().getPosts(),
                    );
                  } else if (state is GetPostsLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 150),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        String postTime = timeago.format(
                          state.posts[index].timestamp,
                        );
                        return PostCard(
                          authorName: state.posts[index].authorName,
                          postTime: postTime,
                          content: state.posts[index].content,
                          postImage: state.posts[index].postImageUrl,
                          likesCount: state.posts[index].likesCount,
                          commentsCount: state.posts[index].commentsCount,
                          isLiked: state.posts[index].isLiked,
                          onLikeTap: () {},
                          onCommentTap: () {},
                          onShareTap: () {},
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedErrorWidget extends StatelessWidget {
  const FeedErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.redColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.redColor,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Failed to load posts',
              style: TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 14,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text(
                'Try Again',
                style: TextStyle(
                  fontFamily: 'CircularStd',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
