import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/feature/auth/controller/auth_controller.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:reddit_clone/feature/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    final isGuest = !user.isAuthenticated;
    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) =>
                ref.watch(userPostProvider(communities)).when(
                      data: (data) => ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = data[index];
                          return PostCard(post: post);
                        },
                      ),
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
    } else {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) => ref.watch(guestPostsProvider).when(
                  data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
    }
  }
}
