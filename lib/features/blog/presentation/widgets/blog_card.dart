import 'package:clean_architecture_app/core/theme/app_pallete.dart';
import 'package:clean_architecture_app/core/utlis/calclute_reading_time.dart';
import 'package:clean_architecture_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        margin: EdgeInsets.all(16).copyWith(bottom: 4),
        padding: EdgeInsets.all(16),
        height: 200,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(e),
                              side: BorderSide(color: AppPallete.borderColor),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  blog.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
            Text("${calculateReadingTime(blog.content)} min")
          ],
        ),
      ),
    );
  }
}
