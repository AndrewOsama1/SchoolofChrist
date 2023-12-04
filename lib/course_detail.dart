import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kdeccourse/app_colors.dart';
import 'package:kdeccourse/backend_requests.dart';
import 'package:kdeccourse/email_screen.dart';
import 'package:kdeccourse/episode_detail.dart';
import 'dart:math' as math;
import 'package:kdeccourse/models/course_model.dart';
import 'package:kdeccourse/models/progress_model.dart';
import 'package:provider/provider.dart';

class CourseDetail extends StatefulWidget {
  final String courseName, ext;

  const CourseDetail({Key? key, required this.courseName, required this.ext})
      : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  late ProgressModel progressData;
  Set<int> watched = {};
  @override
  void initState() {
    getProgressData();
    super.initState();
  }

  Future<void> getProgressData() async {
    BackendQueries.getProgress(ProgressModel.withoutProgress(
            context.read<User?>()?.email ?? "", widget.courseName))
        .then((value) {
      progressData = value;
      setState(() {
        watched = progressData.episodes.toSet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 2.5;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmailScreen()));
            },
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: const Icon(Icons.help, size: 47))),
        appBar: AppBar(
          title: Text(
            widget.courseName,
            style: TextStyle(fontSize: multiplier * unitHeightValue),
          ),
          centerTitle: true,
          toolbarHeight: 50,
          elevation: 0,
          backgroundColor: AppColor.primary,
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: FutureBuilder<List<CourseInfo>>(
            future: BackendQueries.getAllCourses(widget.courseName),
            builder: (context, coursesData) => coursesData.hasData
                ? Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Hero(
                                          tag: widget.courseName,
                                          child: CachedNetworkImage(
                                              cacheKey: widget.courseName,
                                              imageUrl:
                                                  "${BackendQueries.imageUrl}${widget.courseName}.${widget.ext}",
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                    "images/placeholder.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                        "images/placeholder.png",
                                                        fit: BoxFit.cover,
                                                      ))))),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () async {
                                        if (context.read<User?>() != null) {
                                        setState(() {
                                          watched.add(index);
                                          });
                                          await BackendQueries.addProgress(
                                            ProgressModel(
                                              context.read<User?>()!.email!,
                                              widget.courseName,
                                              coursesData.data!.length,
                                              watched.toList(),
                                            ),
                                          ).then(
                                            (value) => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EpisodeDetail(
                                                  name: coursesData
                                                      .data![index].courseName,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EpisodeDetail(
                                                name: coursesData
                                                    .data![index].courseName,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Card(
                                        elevation: 2,
                                        child: ListTile(
                                            minVerticalPadding:
                                                multiplier * unitHeightValue,
                                            title: Text(
                                              coursesData
                                                  .data![index].courseName,
                                              style: TextStyle(
                                                  fontSize: multiplier *
                                                      unitHeightValue),
                                            ),
                                            leading: watched.contains(index)
                                                ? Icon(
                                                    Icons.done,
                                                    color: AppColor.secondary,
                                                    size: multiplier *
                                                        unitHeightValue *
                                                        1.5,
                                                  )
                                                : null,
                                            trailing: Icon(
                                              Icons.play_circle_fill,
                                              color: AppColor.primary,
                                              size: multiplier *
                                                  unitHeightValue *
                                                  1.5,
                                            )),
                                      ),
                                    ),
                                itemCount: coursesData.data!.length),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ));
  }
}
