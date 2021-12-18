import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'screen/login/login.dart';
import 'screen/screen_car/order.dart';
import 'service/auth_services.dart';

// ถ้าต้องใช้ async, await ก็ต้องใช้ Future โดยตัวนี้กำหนด type เป็น void
void main() async {
  // คือ การตั้งค่า firebase เพื่อให้เราสามารถใช้งานได้ อธิบายเต็มในโปรเจค v_cars
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // false เพื่อไม่เห็นข้อความ debug มุมขว้าบนในหน้า ui
      debugShowCheckedModeBanner: false,
      home: Last_Login(),
    );
  }
}

class Last_Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // StreamBuilder ใช้เพื่อติดตามข้อมูลของ Class User ซึ่งเป็น class ของ package
    // กำหนด type เป็น User? เพื่อเอาไว้กันว่าถ้าไม่ใช้ type นี้เเล้วเมื่อใส่ค่า parameter
    // ใน stream ไม่ถูกเเล้วมันถึงจะเเจ้ง error
    return StreamBuilder<User?>(
        // authStateChanges() ตรวจสอบว่ามีการเข้าสู่ระบบหรือไม่
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // snapshot.hasData ตรวจสอบว่ามีข้อมูลหรือไม่ โดยที่ outputเป็น ture หรือ false
          // !snapshot.hasData ถ้าไม่มีข้อมูลจะเป็น true ถ้ามีข้อมูลจะเป็น false เพราะมี ! หรือ not
          // ค่าเลยสลับกัน
          if (!snapshot.hasData) {
            // เข้าเมื่อยังไม่ได้ login หรือยังไม่ได้สมัคร
            return Login();
          }
          // เมื่อสมัครหรือ login แล้ว
          return OrderView();
        });
  }
}
