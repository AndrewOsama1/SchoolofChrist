import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kdeccourse/app_colors.dart';
import 'package:kdeccourse/backend_requests.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'models/course_model.dart';

class EpisodeDetail extends StatefulWidget {
  final String name;

  const EpisodeDetail({Key? key, required this.name}) : super(key: key);

  @override
  State<EpisodeDetail> createState() => _EpisodeDetailState();
}

class _EpisodeDetailState extends State<EpisodeDetail> {
  bool autoPlay = false;
  late YoutubePlayerController _controller;
  CourseInfo? courseInfo;
  @override
  void initState() {
    super.initState();
    getCourseInfo();
  }

  Future<void> getCourseInfo() async {
    courseInfo = await BackendQueries.getCourseInfo(widget.name);
    String? videoId = getIdFromUrl(courseInfo!.courseLink);
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    )
      ..onInit = () {
        if (autoPlay) {
          _controller.loadVideoById(videoId: videoId!);
        } else {
          _controller.cueVideoById(videoId: videoId!);
        }
      }
      ..listen((event) {
        if (event.hasError) EasyLoading.showError("Something went wrong");
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 2.5;
    if (courseInfo != null) {
      return YoutubePlayerScaffold(
          controller: _controller,
          builder: (context, player) => Scaffold(
              appBar: AppBar(
                title: Text(courseInfo!.courseName,
                    style: TextStyle(fontSize: multiplier * unitHeightValue)),
                centerTitle: true,
                automaticallyImplyLeading: true,
                backgroundColor: AppColor.primary,
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    player,
                    if (courseInfo?.courseDescription != null &&
                        courseInfo!.courseDescription.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          courseInfo!.courseDescription,
                          style: TextStyle(
                            fontSize: multiplier * unitHeightValue,
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        if ((courseInfo?.coursePDF != null &&
                                courseInfo!.coursePDF.isNotEmpty) ||
                            (courseInfo?.courseMP3 != null &&
                                courseInfo!.courseMP3.isNotEmpty))
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "attachments".tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: multiplier * unitHeightValue,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (courseInfo?.coursePDF != null &&
                                  courseInfo!.coursePDF.isNotEmpty)
                                IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.filePdf,
                                      color: AppColor.secondary,
                                      size: multiplier * unitHeightValue,
                                    ),
                                    onPressed: () {
                                      _launchURL(courseInfo!.coursePDF);
                                    }),
                              if (courseInfo?.courseMP3 != null &&
                                  courseInfo!.courseMP3.isNotEmpty)
                                IconButton(
                                    icon: FaIcon(FontAwesomeIcons.music,
                                        color: AppColor.secondary,
                                        size: multiplier * unitHeightValue),
                                    onPressed: () {
                                      _launchURL(courseInfo!.courseMP3);
                                    }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ])));
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

void _launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
}
