import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:goals/goals_page.dart';
import 'package:goals/secrets.dart';
import 'rbc_investease_api_client.dart';

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

  static Client? get currentClient => _currentClient;
  static Client? _currentClient;

  static Goal? _goal;
  static Goal? get currentuser => _goal;

  AuthService() {
    _currentUser = User(
      id: 'demo_user',
      name: 'Aruhant',
      email: 'a89mehta@uwaterloo.ca',
      accessToken: 'accessToken',
    );
    fetchUserProfile(_currentUser!);
  }

  static get currentUserId => _currentUser?.id ?? 'demo_user';

  static Future<User?> login() async {
    _currentUser = await demoSetup();
    if (_currentUser != null) return _currentUser;
    Auth0 auth0 = Auth0(Auth0Secrets['domain']!, Auth0Secrets['clientId']!);
    try {
      final credentials = await auth0.credentialsManager.credentials();
      _currentUser = User.fromCredentials(credentials);
      print(
        'login: Fetched user from credentials manager: ${_currentUser!.email}',
      );
      await fetchUserProfile(_currentUser!);
      return _currentUser;
    } catch (e) {
      try {
        print('login:No valid credentials, starting web authentication: $e');
        final credentials = await auth0.webAuthentication().login();
        _currentUser = User.fromCredentials(credentials);
        await fetchUserProfile(_currentUser!);
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

  static Future<void> fetchUserProfile(User user) async {
    if (user.email.isEmpty) {
      print('User email is empty, cannot fetch profile.');
      return;
    }
    if (_currentClient == null) {
      _currentClient = await InvestEaseApiClient().getClientByEmail(user.email);
      if (_currentClient == null) {
        try {
          _currentClient = await InvestEaseApiClient().createClient(
            ClientCreate(
              name: currentUser!.name,
              email: currentUser!.email,
              cash: 1000.0,
              portfolios: [
                {"type": "balanced", "initialAmount": 10000},
              ],
            ),
          );
          print('Created new investment account: $_currentClient');
        } catch (e) {
          print('Error creating investment account: $e');
        }
      } else {
        print('Fetched existing investment account: $_currentClient');
      }
    }

    _goal ??= await Goal.fetchGoalForUser(user.email);
  }

  static Future<User?> demoSetup() async {
    _currentUser = User(
      id: 'demo_user',
      name: 'Aruhant',
      email: 'a89mehta@uwaterloo.ca',
      accessToken: 'accessToken',
    );
    try {
      await fetchUserProfile(_currentUser!);
    } catch (e) {
      print('Error in demo setup: $e');
    }
    return _currentUser;
  }
}
