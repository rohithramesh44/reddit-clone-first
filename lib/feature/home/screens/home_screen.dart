import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/feature/auth/controller/auth_controller.dart';
import 'package:reddit_clone/feature/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/feature/home/drawers/community_drawer_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref)),
              icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.profilePic),
            ),
          ),
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
      ),
      drawer: const CommunityDrawerList(),
    );
  }
}
