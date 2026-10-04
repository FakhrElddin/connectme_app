import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.authorName,
    required this.postTime,
    this.authorImage,
    this.content,
    this.postImage,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
  });

  final String authorName;
  final String postTime;
  final String? authorImage;
  final String? content;
  final String? postImage;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLiked;
  late int currentLikes;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    currentLikes = widget.likesCount;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        currentLikes++;
      } else {
        currentLikes = (currentLikes > 0) ? currentLikes - 1 : 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.2,
                  ),
                  backgroundImage: widget.authorImage != null
                      ? NetworkImage(widget.authorImage!)
                      : null,
                  child: widget.authorImage == null
                      ? Text(
                          widget.authorName.isNotEmpty
                              ? widget.authorName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontFamily: 'CircularStd',
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            fontSize: 16,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.authorName,
                  style: const TextStyle(
                    fontFamily: 'CircularStd',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextColor,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.postTime,
                  style: const TextStyle(
                    fontFamily: 'CircularStd',
                    fontSize: 14,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          if (widget.content != null && widget.content!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Text(
                widget.content!,
                style: const TextStyle(
                  fontFamily: 'CircularStd',
                  fontSize: 14,
                  color: AppColors.darkTextColor,
                  height: 1.3,
                ),
              ),
            ),
          if (widget.postImage != null && widget.postImage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.network(
                widget.postImage!,
                height: 224,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.lightGreyColor,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.greyColor,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: widget.onCommentTap,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 20,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.commentsCount}',
                        style: const TextStyle(
                          fontFamily: 'CircularStd',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                InkWell(
                  onTap: toggleLike,
                  child: Row(
                    children: [
                      Icon(
                        isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 21,
                        color: isLiked
                            ? AppColors.redColor
                            : AppColors.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$currentLikes',
                        style: TextStyle(
                          fontFamily: 'CircularStd',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isLiked
                              ? AppColors.redColor
                              : AppColors.darkGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
