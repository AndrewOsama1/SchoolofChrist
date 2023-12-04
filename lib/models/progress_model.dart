class ProgressModel {
  late String userId;
  late String courseName;
  late int progress;
  late List<int> episodes;

  ProgressModel(this.userId, this.courseName, this.progress,this.episodes);

  ProgressModel.withoutProgress(this.userId, this.courseName);

  ProgressModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? "";
    courseName = json['courseName'] ?? "";
    progress = json['progress'] ?? 0;
    episodes = <int>[];
    if(json['episodes'] != null) {
      json['episodes'].forEach((element) {episodes.add(element);});
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId ;
    data['courseName'] = courseName;
    data['progress'] = progress;

    data['episodes'] = <int>[];
    for (var element in episodes) {data['episodes'].add(element);}
    return data;
  }
}