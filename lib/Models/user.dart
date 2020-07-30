class User {
  String mobile;
  String name;
  String profilepic;

  User({
    this.mobile,
    this.name,
    this.profilepic,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['mobile'] = user.mobile;
    data['name'] = user.name;
    data['profilepic'] = user.profilepic;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.mobile = mapData['mobile'];
    this.name = mapData['name'];
    this.profilepic = mapData['profilepic'];
  }
}