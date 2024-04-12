class User {
  final int id;
  final String login;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.login,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user')) {
      var jsonUser = json['user'];
      if (jsonUser is Map<String, dynamic>) {
        if (jsonUser['id'] == 0) {
          return User(
            id: 0,
            login: jsonUser['login'] ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      }
    }
    return switch (json) {
      {
        'user': {
          'id': String id,
          'login': String login,
          'createdAt': String createdAt,
          'updatedAt': String updatedAt,
        }
      } =>
        User(
            id: int.parse(id),
            login: login,
            createdAt: DateTime.parse(createdAt),
            updatedAt: DateTime.parse(updatedAt),
        ),
      _ => throw FormatException('Failed to load user. $json'),
    };
  }
}

