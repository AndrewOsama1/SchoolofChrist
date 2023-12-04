class CourseInfo {
  late int id;
  late String courseName;
  late String courseCategory;
  late String courseDescription;
  late String courseLink;
  late String courseMP3;
  late String coursePDF;
  late int views;

  CourseInfo({
    required this.id,
    required this.courseName,
    required this.courseCategory,
    required this.courseDescription,
    required this.courseLink,
    required this.courseMP3,
    required this.coursePDF,
    required this.views,
  });

  CourseInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseName = json['courseName'];
    courseCategory = json['courseCategory'];
    courseDescription = json['courseDescription'];
    courseLink = json['courseLink'];
    courseMP3 = json['courseMP3'];
    coursePDF = json['coursePDF'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['courseName'] = courseName;
    data['courseCategory'] = courseCategory;
    data['courseDescription'] = courseDescription;
    data['courseLink'] = courseLink;
    data['courseMP3'] = courseMP3;
    data['coursePDF'] = coursePDF;
    data['views'] = views;
    return data;
  }
}
