import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/core/providers/geocoding_provider.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/widgets/comment_input_field.dart';
import 'package:greenlinkapp/features/map/pages/map.dart';
import 'package:greenlinkapp/features/user/providers/user_provider.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/feedback_utils.dart';
import '../providers/comment_provider.dart';
import '../providers/post_provider.dart';
import '../widgets/comment_card.dart';

class PostInfoPage extends ConsumerStatefulWidget {
  final PostModel post;

  const PostInfoPage({super.key, required this.post});

  @override
  ConsumerState<PostInfoPage> createState() => _PostInfoPageState();
}

class _PostInfoPageState extends ConsumerState<PostInfoPage> {
  bool _isDeleting = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postFromProvider =
        ref.watch(
          postsProvider(null).select(
            (value) => value.value?.items.firstWhere(
              (p) => p.id == widget.post.id,
              orElse: () => widget.post,
            ),
          ),
        ) ??
        widget.post;

    final post = postFromProvider;
    final timestamp = post.createdAt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(post.createdAt!.toLocal())
        : '';

    final geoKey = (lat: post.latitude, lng: post.longitude);
    final locationAsync = ref.watch(placeNameProvider(geoKey));
    final locationName =
        locationAsync.value ?? "${post.latitude}, ${post.longitude}";

    final authState = ref.watch(authProvider);
    final isAdmin = authState.asData?.value.isAdmin ?? false;
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == post.author?.id;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dettaglio Post"),
        actions: [
          if (isAdmin || isAuthor)
            IconButton(
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _isDeleting ? null : () => _confirmDelete(context),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[200],
                          child: post.author != null
                              ? Text(post.author!.displayName[0].toUpperCase())
                              : Icon(
                                  Icons.person_off,
                                  size: 28,
                                  color: Colors.black54,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.author?.displayName ?? "[DELETED]",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              timestamp,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        UiBadge(
                          label: post.category.label,
                          icon: post.category.icon,
                          color: post.category.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      post.description,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                    ),

                    const SizedBox(height: 24),
                    if (post.media.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const PageScrollPhysics(),
                            itemCount: post.media.length,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => _openImageViewer(
                                  context,
                                  images: post.media,
                                  initialIndex: index,
                                ),
                                child: Image.memory(
                                  post.media[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (post.media.length > 1) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            post.media.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withValues(
                                        alpha: 0.25,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                    const Text(
                      "Posizione",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: isAdmin
                          ? null
                          : () {
                              context.go(
                                '/map',
                                extra: MapTargetLocation(
                                  latitude: post.latitude,
                                  longitude: post.longitude,
                                  zoom: 15,
                                  post: post,
                                ),
                              );
                            },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                locationName,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            if (!isAdmin) ...[
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      label: post.hasVoted
                          ? "Hai votato questo post. Totale voti: ${post.votesCount}"
                          : "Vota questo post. Attualmente ha ${post.votesCount} voti",
                      button: true,
                      onTapHint: "Tocca per votare",
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(postsProvider(null).notifier)
                              .votePost(post.id!, post.hasVoted);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                post.hasVoted
                                    ? Icons.trending_up
                                    : Icons.trending_up_outlined,
                                size: 22,
                                color: post.hasVoted
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${post.votesCount} Upvotes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: post.hasVoted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: post.hasVoted
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("${post.commentsCount} Commenti"),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text("Recenti"),
                          selected:
                              ref.watch(commentSortProvider) ==
                              CommentSortCriteria.recent,
                          onSelected: (val) => ref
                              .read(commentSortProvider.notifier)
                              .setCriteria(CommentSortCriteria.recent),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text("Più votati"),
                          selected:
                              ref.watch(commentSortProvider) ==
                              CommentSortCriteria.mostLiked,
                          onSelected: (val) => ref
                              .read(commentSortProvider.notifier)
                              .setCriteria(CommentSortCriteria.mostLiked),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ref
                        .watch(commentsProvider(post.id!))
                        .when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) =>
                              Text("Errore nel caricamento dei commenti: $err"),
                          data: (comments) {
                            if (comments.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Nessun commento presente. Sii il primo!",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return CommentCard(
                                  comment: comment,
                                  postId: post.id!,
                                );
                              },
                            );
                          },
                        ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CommentInputField(postId: post.id!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Elimina Post"),
        content: const Text("Sei sicuro di voler eliminare questo post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Elimina", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      try {
        await ref
            .read(postsProvider(null).notifier)
            .deletePost(widget.post.id!);
        if (mounted) {
          Navigator.pop(context);
        }
        FeedbackUtils.showSuccess(context, "Post eliminato con successo");
      } catch (e) {
        if (mounted) {
          FeedbackUtils.showError(context, e);
        }
      } finally {
        if (mounted) {
          setState(() => _isDeleting = false);
        }
      }
    }
  }

  void _openImageViewer(
    BuildContext context, {
    required List<Uint8List> images,
    required int initialIndex,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Center(child: Image.memory(images[index])),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        color: Colors.black.withValues(alpha: 0.6),
                        child: Text(
                          'Immagine ${index + 1} di ${images.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
