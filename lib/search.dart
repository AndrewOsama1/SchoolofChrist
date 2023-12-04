import 'package:flutter/material.dart';
import 'package:kdeccourse/models/course_model.dart';

import 'backend_requests.dart';
import 'course_detail.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<CourseInfo>>(
      future: BackendQueries.getSearch(query),
      builder: (context, snapshot) => snapshot.hasData
          ? ListView.separated(
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) => ListTile(
                    title: Text(snapshot.data?[index].courseName ?? ""),
                    subtitle: Text(snapshot.data?[index].courseCategory ?? ""),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourseDetail(
                                    courseName:
                                        snapshot.data?[index].courseCategory ??
                                            "",
                                    ext: '',
                                  )));
                    },
                  ),
              itemCount: snapshot.data!.length)
          : !snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done
              ? const Center(child: Text("غير متاح الان"))
              : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
