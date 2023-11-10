class ChatUser {
  late String id;
  late String name;
  late String email;
  late String about;
  late String image;
  late String createdAt;
  late String lastActive;
  late bool isOnline;
  late String pushToken;

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.image,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.pushToken,
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    image = json['image'] ?? '';
    createdAt = json['createdAt'] ?? '';
    lastActive = json['lastActive'] ?? '';
    isOnline = json['isOnline'] ?? '';
    pushToken = json['pushToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['about'] = about;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['lastActive'] = lastActive;
    data['isOnline'] = isOnline;
    data['pushToken'] = pushToken;

    return data;
  }
}