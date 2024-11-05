import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/feature/auth/controller/auth_controller.dart';
import 'package:reddit_clone/feature/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/model/post_model.dart';
import 'package:reddit_clone/model/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(firebaseStorageProvider);
  return UserProfileController(
      userProfileRepository: userProfileRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required userProfileRepository,
      required ref,
      required storageRepository})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    // communities/profile/profile.jpg
    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profile',
          id: user.uid,
          file: profileFile,
          webFile: profileWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }

    if (bannerFile != null || bannerWebFile != null) {
      // communities/banner/banner.jpg
      final res = await _storageRepository.storeFile(
          path: 'users/banner',
          id: user.name,
          file: bannerFile,
          webFile: bannerWebFile);
      //res working fine its a link for the photo uploaded
      res.fold((l) => showSnackBar(context, l.message), (r) {
        user = user.copyWith(banner: r);
      }); // check this area for current error. is user updated?
    }
    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);
    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}
