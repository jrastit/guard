class User {
  final int id;
  final String login;

  User({
    required this.id,
    required this.login,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user')) {
      var jsonUser = json['user'];
      if (jsonUser is Map<String, dynamic>) {
        if (jsonUser['id'] == 0) {
          return User(
            id: 0,
            login: jsonUser['login'] ?? '',
          );
        }
      }
    }
    return switch (json) {
      {
        'user': {
          'id': int id,
          'login': String login,
        }
      } =>
        User(
          id: id,
          login: login,
        ),
      _ => throw FormatException('Failed to load user. $json'),
    };
  }
}
