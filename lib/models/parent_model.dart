class Parent {
  late String name;
  late bool hasChildren;
  late String parentName;
  late String imgExt;
  Parent(this.name,this.hasChildren,this.parentName,this.imgExt);

  Parent.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hasChildren = json['hasChildren'];
    parentName = json['parentName'];
    imgExt = json['imgExt'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['hasChildren'] = hasChildren;
    data['parentName'] = parentName;
    data['imgExt'] = imgExt;
    return data;
  }
}