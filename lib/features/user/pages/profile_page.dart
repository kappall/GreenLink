import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/event/widgets/event_feed.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';
import 'package:greenlinkapp/features/feed/widgets/post_feed.dart';

import '../../auth/utils/role_parser.dart';
import '../../feed/models/comment_model.dart';
import '../../feed/providers/comment_provider.dart';
import '../../feed/widgets/comment_card.dart';
import '../providers/user_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final role = ref.watch(
      authProvider.select((auth) => auth.value?.role ?? AuthRole.unknown),
    );
    final colorScheme = Theme.of(context).colorScheme;

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text("Errore: $error"))),
      data: (_) {
        final currentUserAsync = ref.watch(currentUserProvider);
        return currentUserAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) =>
              Scaffold(body: Center(child: Text("Errore: $error"))),
          data: (currentUser) {
            final user = currentUser;

            if (user == null || user.id <= 0) {
              return Scaffold(
                appBar: AppBar(title: const Text("Profilo"), centerTitle: true),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 80,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Non hai un account",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Accedi per visualizzare il tuo profilo completo",
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).logout();
                        },
                        child: const Text("Accedi"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final userPostsAsync = ref.watch(postsProvider(user.id));
            final isPartner = role == AuthRole.partner;
            final userEventsAsync = isPartner
                ? ref.watch(eventsByPartnerProvider(user.id))
                : ref.watch(eventsByUserProvider(user.id));
            final userCommentsAsync = ref.watch(
              commentsByUserIdProvider(user.id),
            );
            final displayName = user.username ?? user.email;
            final email = user.email;
            final avatarLetter = displayName.characters.first.toUpperCase();
            final emptyEventsLabel = isPartner
                ? "Nessun evento creato"
                : "Nessun evento partecipato";

            return Scaffold(
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ),
                        sliver: SliverAppBar(
                          expandedHeight: 240.0,
                          floating: false,
                          pinned: true,
                          backgroundColor: colorScheme.primary,
                          iconTheme: const IconThemeData(color: Colors.white),
                          title: const Text(
                            "Profilo",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              onPressed: () => context.push('/settings'),
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.primary,
                                    const Color(0xFF0D9488),
                                  ],
                                ),
                              ),
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              radius: 38,
                                              backgroundColor:
                                                  colorScheme.primaryContainer,
                                              child: Text(
                                                avatarLetter,
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  color: colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  displayName,
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  email,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withAlpha(230),
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withAlpha(51),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withAlpha(77),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    roleLabel(role),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          userPostsAsync.when(
                                            data: (page) => _buildStatItem(
                                              "Post",
                                              page.totalItems.toString(),
                                            ),
                                            loading: () =>
                                                _buildStatItem("Post", "-"),
                                            error: (_, __) =>
                                                _buildStatItem("Post", "!"),
                                          ),
                                          userEventsAsync.when(
                                            data: (page) => _buildStatItem(
                                              "Eventi",
                                              page.totalItems.toString(),
                                            ),
                                            loading: () =>
                                                _buildStatItem("Eventi", "-"),
                                            error: (_, __) =>
                                                _buildStatItem("Eventi", "!"),
                                          ),
                                          userCommentsAsync.when(
                                            data: (comments) => _buildStatItem(
                                              "Commenti",
                                              comments.length.toString(),
                                            ),
                                            loading: () =>
                                                _buildStatItem("Commenti", "-"),
                                            error: (_, __) =>
                                                _buildStatItem("Commenti", "!"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            labelColor: colorScheme.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: colorScheme.primary,
                            tabs: const [
                              Tab(text: "Post"),
                              Tab(text: "Eventi"),
                              Tab(text: "Commenti"),
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      _PostTab(postPageAsync: userPostsAsync, userId: user.id),
                      _EventTab(
                        eventsAsync: userEventsAsync,
                        emptyLabel: emptyEventsLabel,
                      ),
                      _CommentsTab(userCommentsAsync),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 12),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _PostTab extends ConsumerWidget {
  final AsyncValue<PaginatedResult<PostModel>> postPageAsync;
  final int userId;

  const _PostTab({required this.postPageAsync, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      key: const PageStorageKey('profile-posts'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        postPageAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: Center(child: Text("Errore nel caricamento")),
          ),
          data: (page) {
            if (page.items.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text("Nessun post pubblicato")),
              );
            }
            return PostFeed(postPageAsync: postPageAsync);
          },
        ),

        // Load-more trigger
        SliverToBoxAdapter(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent * 0.9) {
                ref.read(postsProvider(userId).notifier).loadMore();
              }
              return false;
            },
            child: const SizedBox(height: 1),
          ),
        ),
      ],
    );
  }
}

class _EventTab extends StatelessWidget {
  final AsyncValue<PaginatedResult<EventModel>> eventsAsync;
  final String emptyLabel;

  const _EventTab({required this.eventsAsync, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('profile-events'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        eventsAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, st) => SliverFillRemaining(
            child: Center(child: Text("Errore nel caricamento")),
          ),
          data: (page) {
            if (page.items.isEmpty) {
              return SliverFillRemaining(
                child: Center(child: Text(emptyLabel)),
              );
            }
            return EventFeed(eventsAsync: eventsAsync);
          },
        ),
      ],
    );
  }
}

class _CommentsTab extends StatelessWidget {
  final AsyncValue<List<CommentModel>> commentsAsync;

  const _CommentsTab(this.commentsAsync);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('profile-comments'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        commentsAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: Center(child: Text("Errore nel caricamento")),
          ),
          data: (comments) {
            if (comments.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text("Nessun commento pubblicato")),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemCount: comments.length,
                itemBuilder: (context, index) => CommentCard(
                  comment: comments[index],
                  postId: comments[index].contentId,
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}
