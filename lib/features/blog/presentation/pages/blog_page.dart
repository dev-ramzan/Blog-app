import 'package:clean_architecture_app/core/common/widgets/loader.dart';
import 'package:clean_architecture_app/core/theme/app_pallete.dart';
import 'package:clean_architecture_app/core/utlis/show_snackebar.dart';
import 'package:clean_architecture_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:clean_architecture_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:clean_architecture_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(getAllBlogsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Blog App"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, AddNewBlogPage.route());
                },
                icon: Icon(CupertinoIcons.add_circled))
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              ShowSnackbar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return Center(child: Loader());
            }
            if (state is BlogDisplaySuccess) {
              return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                      blog: blog,
                      color: index % 3 == 0
                          ? AppPallete.gradient1
                          : index % 3 == 1
                              ? AppPallete.gradient2
                              : Colors.red);
                },
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
