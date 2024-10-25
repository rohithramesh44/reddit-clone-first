import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:reddit_clone/feature/post/controller/post_controller.dart';
import 'package:reddit_clone/model/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  File? bannerImage;
  final titleController = TextEditingController();
  final linkController = TextEditingController();
  final descriptionController = TextEditingController();
  Community? selectedCommunity;
  List<Community> communities = [];

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerImage != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerImage);
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          description: descriptionController.text.trim());
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    } else {
      showSnackBar(context, "Fill all fields currectly");
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';

    final currentTheme = ref.read(themeNofifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text('Post ${widget.type}'),
          actions: [
            TextButton(
              onPressed: sharePost,
              child: const Text('Share'),
            ),
          ],
        ),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Title Here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isTypeImage) ...[
                      //this is another way to add multiple widget inside a column or row if condition
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyMedium!.color!,
                          child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  // color: Colors.red[400],
                                  borderRadius: BorderRadius.circular(10)),
                              child: bannerImage != null
                                  ? Image.file(bannerImage!)
                                  : const Center(
                                      child: Icon(Icons.camera_alt_outlined,
                                          size: 40),
                                    )),
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 10,
                    ),
                    if (isTypeText) // way to add single widget insde a column or row children with if condition
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Description Here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLines: 6,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isTypeLink)
                      TextField(
                        controller: linkController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Link Here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Community',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ref.watch(userCommunitiesProvider).when(
                        data: (data) {
                          communities = data;
                          if (data.isEmpty) {
                            return const SizedBox();
                          }
                          return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader())
                  ],
                ),
              ));
  }
}
