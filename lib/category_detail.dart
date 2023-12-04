import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kdeccourse/models/parent_model.dart';
import 'app_colors.dart';
import 'backend_requests.dart';
import 'course_detail.dart';

class CategoryDetails extends StatelessWidget {
  final String title;

  const CategoryDetails({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 2.5;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor: AppColor.primary,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Parent>>(
        future: BackendQueries.getAllParentsByName(
            title), //BackendQueries.getAllParents(),
        builder: (context, snapshot) => snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done
            ? GridView.count(
                crossAxisCount: 2,
                children: List.generate(snapshot.data!.length, (index) {
                  return Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => snapshot.data![index].hasChildren
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryDetails(
                                          title: snapshot.data![index].name)))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseDetail(
                                          courseName:
                                              snapshot.data![index].name,
                                          ext: snapshot.data![index].imgExt))),
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Hero(
                                        tag:
                                            snapshot.data![index].name.trim(),
                                        child: CachedNetworkImage(
                                            cacheKey:
                                                snapshot.data![index].name,
                                            imageUrl:
                                                "${BackendQueries.imageUrl}${snapshot.data![index].name}.${snapshot.data![index].imgExt}",
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
                                                    )))),
                              )),
                        ),
                      ),
                      Text(
                        snapshot.data![index].name.trim(),
                        style: TextStyle(
                            fontSize: multiplier * unitHeightValue * 0.7),
                      )
                    ],
                  );
                }))
            : !snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done
                ? const Center(child: Text("غير متاح الان"))
                : const SizedBox.shrink(),
      ),
    );
  }
}
