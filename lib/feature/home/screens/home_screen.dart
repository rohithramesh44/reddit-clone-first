import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/feature/auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
        appBar: AppBar(
      title: const Text('Home'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user.profilePic),
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu),
      ),
    ));
  }
}
