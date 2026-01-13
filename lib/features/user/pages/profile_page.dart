import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/feed/providers/comment_provider.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';
import 'package:greenlinkapp/features/feed/widgets/comment_card.dart';
import 'package:greenlinkapp/features/feed/widgets/post_card.dart';
import 'package:greenlinkapp/features/user/providers/user_provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../event/providers/event_provider.dart';
import '../../event/widgets/event_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            final userEventsAsync = ref.watch(eventsByUserIdProvider(user.id));
            final userCommentsAsync = ref.watch(
              commentsByUserIdProvider(user.id),
            );
            final displayName = user.username ?? user.email;
            final email = user.email;
            final avatarLetter = displayName.characters.first.toUpperCase();

            return Scaffold(
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 340.0,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    const SizedBox(height: 16),
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        roleLabel(role),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        userPostsAsync.when(
                                          data: (page) => _buildStatItem(
                                            "Post",
                                            page.items.length.toString(),
                                          ),
                                          loading: () =>
                                              _buildStatItem("Post", "-"),
                                          error: (_, __) =>
                                              _buildStatItem("Post", "!"),
                                        ),
                                        userEventsAsync.when(
                                          data: (events) => _buildStatItem(
                                            "Eventi",
                                            events.length.toString(),
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
                      userPostsAsync.when(
                        data: (page) => page.items.isEmpty
                            ? const Center(
                                child: Text("Nessun post pubblicato"),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: page.items.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 32, thickness: 1),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => context.push(
                                        '/post-info',
                                        extra: page.items[index],
                                      ),
                                      child: PostCard(post: page.items[index]),
                                    ),
                              ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Errore: $error")),
                      ),
                      userEventsAsync.when(
                        data: (events) => events.isEmpty
                            ? const Center(
                                child: Text("Nessun evento partecipato"),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: events.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) =>
                                    EventCard(event: events[index]),
                              ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Errore: $error")),
                      ),
                      userCommentsAsync.when(
                        data: (comments) => comments.isEmpty
                            ? const Center(
                                child: Text("Nessun commento pubblicato"),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: comments.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) => CommentCard(
                                  comment: comments[index],
                                  postId: comments[index].contentId,
                                ),
                              ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Errore: $error")),
                      ),
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
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
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
