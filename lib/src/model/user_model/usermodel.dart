class UserModel {
  String? image;
  String? name;
  String? about;
  String? createdAt;
  String? lastActive;
  bool? isOnline;
  var id;
  String? email;
  String? pushToken;

  UserModel(
      {this.image,
        this.name,
        this.about,
        this.createdAt,
        this.lastActive,
        this.isOnline,
        this.id,
        this.email,
        this.pushToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? ' ';
    name = json['name'] ?? ' ';
    about = json['about'] ?? ' ';
    createdAt = json['created_at'] ?? ' ';
    lastActive = json['last_active'] ?? ' ';
    isOnline = json['is_online']  ?? ' ';
    id = json['id'] ?? ' ';
    email = json['email'] ?? ' ';
    pushToken = json['push_token'] ?? ' ';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['about'] = this.about;
    data['created_at'] = this.createdAt;
    data['last_active'] = this.lastActive;
    data['is_online'] = this.isOnline;
    data['id'] = this.id;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}
