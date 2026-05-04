import 'package:flutter_test/flutter_test.dart';

class FirebaseAuth {
  bool isValidEmail(String email) => email.contains('@');

  bool isValidPassword(String password) {
    return password.length >= 8;
  }
}

void main() {
  final service = FirebaseAuth();
  test('validate email correctly', () async {
    const String email = 'medonsar326@gmail.com';
    const String password = '12345678';
    bool t=email.contains('@');
    if (t==false) {
      print('invalid email');
      expect(service.isValidEmail(email), true);
    } else {
      print('valid email');
    }
    expect(service.isValidPassword(password), false);
  });
}
