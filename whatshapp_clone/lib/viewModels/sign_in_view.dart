import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatshapp_clone/core/locater.dart';
import 'package:whatshapp_clone/core/services/auth_service.dart';

class SignInModel with ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  // ignore: deprecated_member_use
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signIn(String userName) async {
    if (userName.isEmpty) return;
    var user = await _authService.signIn();
    await _firestore
        .collection('profile')
        // ignore: deprecated_member_use
        .document(user.uid)
        // ignore: deprecated_member_use
        .setData({'userName': userName, 'image': 'denemeimgurl'});

    await _firestore
        .collection('profile')
        .add({'userName': userName, 'image': 'denemeımgurl'});
  }
}
