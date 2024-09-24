import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawerList extends ConsumerWidget {
  const CommunityDrawerList({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            title: const Text('Create Community'),
            leading: const Icon(Icons.add),
            onTap: () => navigateToCreateCommunity(context),
          )
        ],
      ),
    );
  }
}
