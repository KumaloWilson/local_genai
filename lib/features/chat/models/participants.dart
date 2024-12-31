class Participant {
  final String id;
  final String displayName;
  final String email;
  final String profilePicture;
   String fcmToken;

  Participant({
    required this.id,
    required this.displayName,
    required this.email,
    required this.profilePicture,
    required this.fcmToken,

  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      displayName: json['displayName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      fcmToken: json['fcmToken']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'profilePicture': profilePicture,
      'fcmToken': fcmToken
    };
  }
}