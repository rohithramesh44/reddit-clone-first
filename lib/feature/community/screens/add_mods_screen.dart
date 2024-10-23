import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/feature/auth/controller/auth_controller.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  int count = 0;
  Set<String> uids = {};
  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() => uids.remove(uid));
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addMods(
          widget.name,
          uids.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: saveMods,
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) {
              return ListView.builder(
                itemCount: community.member.length,
                itemBuilder: (BuildContext context, index) {
                  final member = community.member[index];
                  return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member) && count == 0) {
                          uids.add(member);
                        }
                        count++;
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUid(user.uid);
                            } else {
                              removeUid(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                      loading: () => const Loader());
                },
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()));
  }
}
