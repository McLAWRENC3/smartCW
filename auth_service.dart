class AuthService {
  // Simulate login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // Simulate registration
  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
