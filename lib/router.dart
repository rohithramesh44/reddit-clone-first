import 'package:flutter/material.dart';
import 'package:reddit_clone/feature/auth/screens/login_screen.dart';
import 'package:reddit_clone/feature/community/screens/community_screen.dart';
import 'package:reddit_clone/feature/community/screens/create_community_screen.dart';
import 'package:reddit_clone/feature/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(name: route.pathParameters['name']!)),
  },
);
