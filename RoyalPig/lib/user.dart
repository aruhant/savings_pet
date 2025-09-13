import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:goals/secrets.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String accessToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
  });

  factory User.fromCredentials(Credentials credentials) {
    return User(
      id: credentials.user.sub,
      name: credentials.user.name ?? '',
      email: credentials.user.email ?? '',
      accessToken: credentials.accessToken,
    );
  }
}

class AuthService {
  static User? _currentUser;
  static User? get currentUser => _currentUser;

  AuthService();

  static get currentUserId => _currentUser?.id ?? 'demo_user';

  static Future<User?> login() async {
    Auth0 auth0 = Auth0(Auth0Secrets['domain']!, Auth0Secrets['clientId']!);
    try {
      final credentials = await auth0.credentialsManager.credentials();
      _currentUser = User.fromCredentials(credentials);
      return _currentUser;
    } catch (e) {
      try {
        final credentials = await auth0.webAuthentication().login();
        _currentUser = User.fromCredentials(credentials);
        return _currentUser;
      } catch (e) {
        print('Login failed: $e');
        return null;
      }
    }
  }

  Future<void> logout() async {
    await Auth0(
      Auth0Secrets['domain']!,
      Auth0Secrets['clientId']!,
    ).webAuthentication().logout();
  }
}
