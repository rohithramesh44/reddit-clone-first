import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constant.dart';
import 'package:reddit_clone/feature/auth/controller/auth_controller.dart';
import 'package:reddit_clone/feature/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/feature/home/drawers/community_drawer_list.dart';
import 'package:reddit_clone/feature/home/drawers/profile_drawer.dart';
import 'package:reddit_clone/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNofifierProvider);
    final user = ref.watch(userProvider)!;
    final isGuest = !user
        .isAuthenticated; //false value become true value so isGust is now true.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref)),
              icon: const Icon(Icons.search)),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayEndDrawer(context),
              icon: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.profilePic),
              ),
            );
          }),
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
      ),
      body: Constant.tabWidgets[_page],
      drawer: const CommunityDrawerList(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar: isGuest
          ? null
          : CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
              ],
              onTap: onPageChanged,
              currentIndex: _page,
            ),
    );
  }
}
