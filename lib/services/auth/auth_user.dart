import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final String? email;
  final String? uid;

  const AuthUser({
    required this.email,
    required this.uid,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        uid: user.uid,
      );
}
