import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:kdeccourse/app_colors.dart';
import 'package:kdeccourse/backend_requests.dart';
import 'package:kdeccourse/course_detail.dart';
import 'package:kdeccourse/models/progress_model.dart';
import 'package:provider/provider.dart';
import 'firebase_auth_service.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends GetView<BackendQueries> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 2.5;
    return context.watch<User?>() != null
        ? Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 30,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    child: Center(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              elevation: 0),
                          onPressed: () {
                            context.read<FirebaseAuthService>().signOut();
                          },
                          icon: const Icon(Icons.logout),
                          label: Text('logout'.tr())),
                    ),
                  )
                ]),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: SingleChildScrollView(
                  child: FutureBuilder<List<ProgressModel>>(
                      future: BackendQueries.getUserProgress(
                          context.read<User?>()!.email!),
                      builder: (context, snapshot) {
                        if (ConnectionState.done == snapshot.connectionState) {
                          List<ProgressModel> completed = snapshot.data!
                              .where((e) => e.episodes.length == e.progress)
                              .toList();
                          List<ProgressModel> watching = snapshot.data!
                              .where((e) => e.episodes.length < e.progress)
                              .toList();

                          return Align(
                            alignment: Alignment.centerRight,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("were_watching".tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                              ),
                              SizedBox(
                                height: 250,
                                child: watching.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: watching.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseDetail(
                                                              courseName:
                                                                  watching[
                                                                          index]
                                                                      .courseName,
                                                              ext: '',
                                                            ))),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Hero(
                                                        tag: watching[index]
                                                            .courseName
                                                            .trim(),
                                                        child: Stack(
                                                          children: [
                                                            CachedNetworkImage(
                                                                cacheKey: watching[
                                                                        index]
                                                                    .courseName,
                                                                imageUrl:
                                                                    "${BackendQueries.imageUrl}${watching[index].courseName}.jpg",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                      "images/placeholder.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                      "images/placeholder.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                            Positioned(
                                                                bottom: 5,
                                                                right: 20,
                                                                child: Text(
                                                                    "${watching[index].episodes.length}/${watching[index].progress}",
                                                                    style: const TextStyle(
                                                                        color: AppColor
                                                                            .primary)))
                                                          ],
                                                        ))),
                                              ));
                                        })
                                    : Text("watching".tr()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("watched".tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                              ),
                              SizedBox(
                                height: 250,
                                child: completed.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: completed.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseDetail(
                                                              courseName:
                                                                  completed[
                                                                          index]
                                                                      .courseName,
                                                              ext: '',
                                                            ))),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Hero(
                                                        tag: completed[index]
                                                            .courseName
                                                            .trim(),
                                                        child: Stack(
                                                          children: [
                                                            CachedNetworkImage(
                                                                cacheKey: completed[
                                                                        index]
                                                                    .courseName,
                                                                imageUrl:
                                                                    "${BackendQueries.imageUrl}${completed[index].courseName}.jpg",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Center(
                                                                        child:
                                                                            CircularProgressIndicator())),
                                                            const Positioned(
                                                                bottom: 5,
                                                                right: 10,
                                                                child: Icon(
                                                                    Icons
                                                                        .done_all,
                                                                    color: AppColor
                                                                        .primary))
                                                          ],
                                                        ))),
                                              ));
                                        })
                                    : Text("didnt_watch".tr()),
                              ),
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 1.5 * multiplier * unitHeightValue,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.primary),
                                    child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "Delete Account",
                                          style: TextStyle(
                                              fontSize:
                                                  multiplier * unitHeightValue),
                                        ).tr()),
                                    onPressed: () async {
                                      try {
                                        // Get the current user
                                        User? user =
                                            FirebaseAuth.instance.currentUser;

                                        if (user != null) {
                                          // Delete the user's account
                                          await user.delete();

                                          // User account deleted successfully, navigate to the login screen or do other actions if needed
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => const LoginScreen()));
                                        }
                                      } catch (e) {
                                        // Handle any errors that occur during the account deletion process
                                        print("Error deleting account: $e");
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ]),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                ),
              ),
            ),
          )
        : const LoginScreen();
  }
}
