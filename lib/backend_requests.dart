import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kdeccourse/models/category_model.dart';
import 'package:kdeccourse/models/course_model.dart';
import 'package:kdeccourse/models/parent_model.dart';
import 'package:kdeccourse/models/progress_model.dart';
import 'package:flutter/material.dart';

import 'package:kdeccourse/firebase_controller.dart';
import 'models/user_model.dart';

class BackendQueries extends GetxController {
  final RxBool loading = false.obs;
  static const baseUrl = "https://kdec-course.herokuapp.com";
  static const imageUrl = "$baseUrl/file/download/";

  static Future<CourseInfo> getCourseInfo(String course) async {
    EasyLoading.show(status: "loading");
    var response = await http.get(Uri.parse("$baseUrl/api/course/$course"));
    EasyLoading.dismiss();
    // final vs = CourseInfo.fromJson(
    //     jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));

    return CourseInfo.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
  }

  static Future<List<CourseInfo>> getAllCourses(String name) async {
    log("Getting courses");
    log(name);
    EasyLoading.show(status: "loading");
    var response = await http.get(Uri.parse("$baseUrl/api/course/all/$name"));
    EasyLoading.dismiss();

    List<CourseInfo> list = <CourseInfo>[];
    if (response.statusCode == 200) {
      try {
        var albums =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        for (var a in albums) {
          list.add(CourseInfo.fromJson(a));
        }
      } catch (e) {
        log(e.toString());
      }
    }
    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

  Future<void> deleteProfile() async {
    loading(true);

    bool confirmDelete = await Get.defaultDialog(
      content: const Text('Are you sure you want to delete your account?'),
      onConfirm: () async {
        await Get.find<FirebaseController>().firebaseAuth.currentUser!.delete();
        // You can add any additional cleanup or navigation logic here if needed.
        // For example, you might want to navigate to the login screen after deletion.
      },
      onCancel: () {},
    );

    loading(false);

    if (confirmDelete) {
      // The user confirmed the deletion, you can perform any additional actions here.
      // For example, navigate to the login screen.
      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  static Future<List<Category>> getAllCategories(String parent) async {
    var response = await http.get(Uri.parse("$baseUrl/api/category/$parent"));

    List<Category> list = <Category>[];
    if (response.statusCode == 200) {
      try {
        var albums =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        for (var a in albums) {
          list.add(Category.fromJson(a));
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return list;
  }

  static Future<List<Parent>> getAllParents() async {
    EasyLoading.show(status: "loading");
    var response = await http.get(Uri.parse("$baseUrl/api/parent/all"));
    EasyLoading.dismiss();
    List<Parent> list = <Parent>[];
    if (response.statusCode == 200) {
      try {
        var albums =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        for (var a in albums) {
          list.add(Parent.fromJson(a));
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return list;
  }

  static Future<List<Parent>> getAllParentsByName(String name) async {
    EasyLoading.show(status: "loading");
    var response = await http.get(Uri.parse("$baseUrl/api/parent/$name"));
    EasyLoading.dismiss();
    List<Parent> list = <Parent>[];
    if (response.statusCode == 200) {
      try {
        var albums =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        for (var a in albums) {
          list.add(Parent.fromJson(a));
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return list;
  }

  static Future<String> createUser(String token, String user) async {
    var response =
        await http.post(Uri.parse("$baseUrl/api/users/create/$token"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: user);
    return response.body;
  }

  static Future<UserModel> getUserInfo(String idToken) async {
    var response = await http.get(Uri.parse("$baseUrl/api/users/$idToken"));
    var result = UserModel.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
    return result;
  }

  static Future<void> addProgress(ProgressModel progressModel) async {
    EasyLoading.show(status: "loading");
    await http.post(Uri.parse("$baseUrl/api/progress/create/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(progressModel));
    EasyLoading.dismiss();
  }

  static Future<ProgressModel> getProgress(ProgressModel progressModel) async {
    var response = await http.get(Uri.parse(
        "$baseUrl/api/progress/course/${progressModel.userId}/${progressModel.courseName}"));
    log(response.body);
    return ProgressModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  static Future<List<ProgressModel>> getUserProgress(String userId) async {
    EasyLoading.show(status: "loading");
    var response =
        await http.get(Uri.parse("$baseUrl/api/progress/course/$userId"));
    EasyLoading.dismiss();
    var temp = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
    List<ProgressModel> list = <ProgressModel>[];
    for (var i in temp) {
      list.add(ProgressModel.fromJson(i));
    }
    return list;
  }

  static Future<List<CourseInfo>> getSearch(String query) async {
    var response =
        await http.get(Uri.parse("$baseUrl/api/course?search=$query"));
    var list =
        (jsonDecode(const Utf8Decoder().convert(response.bodyBytes)) as List);
    List<CourseInfo> songList = <CourseInfo>[];
    for (final e in list) {
      songList.add(CourseInfo.fromJson(e));
    }
    return songList;
  }
}
