import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constant.dart';
import 'package:reddit_clone/feature/auth/controller/auth_controller.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:reddit_clone/feature/post/controller/post_controller.dart';
import 'package:reddit_clone/model/post_model.dart';
import 'package:reddit_clone/responsive/responsive.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(BuildContext context, WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvotes(post);
  }

  void downvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(award: award, post: post, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';
    final currentTheme = ref.watch(themeNofifierProvider);
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;

    return Responsive(
      child: Column(
        children: [
          Container(
            decoration:
                BoxDecoration(color: currentTheme.scaffoldBackgroundColor),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb)
                  Column(
                    children: [
                      IconButton(
                        onPressed: (!isGuest) ? () => upvote(ref) : () {},
                        icon: Icon(
                          Constant.up,
                          size: 30,
                          color: post.upVotes.contains(user.uid)
                              ? Pallete.redColor
                              : null,
                        ),
                      ),
                      Text(
                        '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      IconButton(
                        onPressed: isGuest ? () {} : () => downvote(ref),
                        icon: Icon(
                          Constant.down,
                          size: 30,
                          color: post.downVotes.contains(user.uid)
                              ? Pallete.blueColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16)
                            .copyWith(right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            post.communityProfilePic),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUser(context),
                                            child: Text(
                                              'u/${post.username}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                    onPressed: () => deletePost(context, ref),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Pallete.redColor,
                                    ),
                                  )
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 24,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: post.awards.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        Image.asset(
                                          Constant.awards[post.awards[index]]!,
                                          height: 24,
                                        )),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.34,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: AnyLinkPreview(
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                    link: post.link!,
                                    titleStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            if (isTypeText)
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    post.description!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: (!isGuest)
                                            ? () => upvote(ref)
                                            : () {},
                                        icon: Icon(
                                          Constant.up,
                                          size: 30,
                                          color: post.upVotes.contains(user.uid)
                                              ? Pallete.redColor
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      IconButton(
                                        onPressed: isGuest
                                            ? () {}
                                            : () => downvote(ref),
                                        icon: Icon(
                                          Constant.down,
                                          size: 30,
                                          color:
                                              post.downVotes.contains(user.uid)
                                                  ? Pallete.blueColor
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          navigateToComments(context),
                                      icon: Icon(
                                        Icons.comment,
                                        size: 30,
                                        color: post.upVotes.contains(user.uid)
                                            ? Pallete.redColor
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(getCommunityByNameProvider(
                                        post.communityName))
                                    .when(
                                        data: (data) {
                                          if (data.mods.contains(user.uid)) {
                                            return IconButton(
                                                onPressed: () =>
                                                    deletePost(context, ref),
                                                icon: const Icon(Icons
                                                    .admin_panel_settings));
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                        error: (error, stackTrace) =>
                                            ErrorText(error: error.toString()),
                                        loading: () => const Loader()),
                              ],
                            ),
                            IconButton(
                                onPressed: isGuest
                                    ? () {}
                                    : () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: GridView.builder(
                                                        shrinkWrap: true,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    4),
                                                        itemCount:
                                                            user.awards.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final String award =
                                                              user.awards[
                                                                  index];
                                                          return GestureDetector(
                                                            onTap: () =>
                                                                awardPost(
                                                                    ref,
                                                                    award,
                                                                    context),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Image.asset(
                                                                  Constant
                                                                      .awards[user
                                                                          .awards[
                                                                      index]]!),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ));
                                      },
                                icon: const Icon(Icons.card_giftcard_outlined))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
