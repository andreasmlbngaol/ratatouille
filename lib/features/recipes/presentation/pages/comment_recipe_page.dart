import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/features/recipes/presentation/provider/recipe_detail_provider.dart';
import '../../domain/model/comment/comment_with_image.dart';

class CommentPage extends StatefulWidget {
  final int id;

  const CommentPage({
    super.key,
    required this.id,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeDetailProvider>().fetchComments(widget.id);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final provider = context.read<RecipeDetailProvider>();
    await provider.postComment(widget.id, _commentController.text.trim());

    _commentController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar berhasil dikirim')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Column(
        children: [
          /// 🔶 HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6A2A),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Komentar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          /// 💬 LIST KOMENTAR
          Expanded(
            child: Consumer<RecipeDetailProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF6A2A),
                    ),
                  );
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      'Error: ${provider.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final comments = provider.comments;

                if (comments.isEmpty) {
                  return const Center(
                    child: Text('Belum ada komentar'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Color(0xFFD9A88C),
                    height: 24,
                  ),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _buildCommentItem(comment);
                  },
                );
              },
            ),
          ),

          /// ✏️ INPUT KOMENTAR
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Berikan komentar...",
                      prefixIcon: const Icon(Icons.edit_note),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFF5E2A25),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _submitComment,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E2A25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentWithImage comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 👤 AVATAR
        CircleAvatar(
          child: ClipOval(
            child: comment.author.profilePictureUrl != null
            ? CachedNetworkImage(
                imageUrl: "${AppConstant.baseUrl}/${comment.author.profilePictureUrl}",
                fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              )
            )
            : Image.asset(
              'assets/images/default_profile_picture.png',
              fit: BoxFit.cover,
            ),
          )
        ),

        const SizedBox(width: 12),

        /// 💬 CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.author.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB85C38),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                comment.content,
                style: const TextStyle(
                  color: Color(0xFF5E2A25),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    _formatTime(comment.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  String _formatTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mnt';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam';
    } else {
      return '${difference.inDays} hari';
    }
  }
}