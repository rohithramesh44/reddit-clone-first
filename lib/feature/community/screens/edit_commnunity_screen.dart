import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constant.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerImage;
  File? profileImage;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileImage = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor:
                Pallete.darkModeAppTheme.drawerTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit community'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Pallete
                              .darkModeAppTheme.textTheme.bodyMedium!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                // color: Colors.red[400],
                                borderRadius: BorderRadius.circular(10)),
                            child: bannerImage != null
                                ? Image.file(bannerImage!)
                                : community.banner.isEmpty ||
                                        community.banner ==
                                            Constant.bannerDefault
                                    ? const Center(
                                        child: Icon(Icons.camera_alt_outlined,
                                            size: 40),
                                      )
                                    : Image.network(community.banner),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: CircleAvatar(
                            backgroundImage: profileImage != null
                                ? FileImage(profileImage!)
                                : NetworkImage(community.avatar),
                            radius: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
