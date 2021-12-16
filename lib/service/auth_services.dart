import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// login โดยการพิมพ์ข้อความลงไป
class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return "$e";
    }
  }

  Future<String> signUp(String email, String password, String role,
      String phone, String user) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User? user1 = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user1?.uid)
            .set({"user": user, 'email': email, "phone": phone, 'role': role});
      });
      return "Signed Up";
    } catch (e) {
      return "$e";
    }
  }
}
