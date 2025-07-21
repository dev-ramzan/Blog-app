import 'dart:io';
import 'package:clean_architecture_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_architecture_app/core/common/widgets/loader.dart';
import 'package:clean_architecture_app/core/theme/app_pallete.dart';
import 'package:clean_architecture_app/core/utlis/pick_image.dart';
import 'package:clean_architecture_app/core/utlis/show_snackebar.dart';
import 'package:clean_architecture_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:clean_architecture_app/features/blog/presentation/pages/blog_page.dart';
import 'package:clean_architecture_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final formKey = GlobalKey<FormState>(); // fom key
  final titleControler = TextEditingController();
  final contentControler = TextEditingController();
  List<String> selectedTopics = [];

// for image to select
  File? image;
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

// Icon button function to upload blog etc
  void uploadBlog() async {
    final posterId =
        (context.read<AppUserCubit>().state as AppUserLogggedIn).user.id;

    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      context.read<BlogBloc>().add(BlogUploadEvent(
          posterId: posterId,
          title: titleControler.text.trim(),
          content: contentControler.text.trim(),
          image: image!,
          topics: selectedTopics));
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleControler.dispose();
    contentControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                uploadBlog();
              },
              icon: Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            return ShowSnackbar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Center(child: Loader());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image != null
                        ? SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image!,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: [10, 4],
                              radius: Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select your image",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: [
                        'Technology',
                        'Business',
                        'Programming',
                        'Entertainment'
                      ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      label: Text(e),
                                      backgroundColor:
                                          selectedTopics.contains(e)
                                              ? AppPallete.gradient1
                                              : Colors.transparent,
                                      side: BorderSide(
                                          color: AppPallete.borderColor),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                        controler: titleControler, hintText: "Blog title"),
                    SizedBox(height: 8),
                    BlogEditor(
                        controler: contentControler, hintText: "Blog Content")
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
