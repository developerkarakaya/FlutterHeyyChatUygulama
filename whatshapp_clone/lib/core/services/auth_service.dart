import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: deprecated_member_use
  Future<FirebaseUser> signIn() async {
    var user = await _auth.signInAnonymously();
    return user.user;
  }
}
