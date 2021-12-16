import 'dart:async';
import 'package:car_user/models/cars_model.dart';
import 'package:car_user/models/user_model.dart';
import 'package:car_user/service/auth_services.dart';
import 'package:car_user/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';

import 'forgot_password.dart';
import 'register.dart';

final kFirebaseAnalytics = FirebaseAnalytics();

// ต้องใส่ sha 1 ด้วยใน firebase โดย ทำการคอมเม็น android.enableJetifier=true ออก เเล้วถึงจะห้า shi 1 เห็นเเล้วเมือจะรันก็มาเอาคอมเม็นออกจาก android.enableJetifier=trueไม่งั้นมันจะรันไม่ออก
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = firebase_auth.FirebaseAuth.instance;
  Database db = Database.instance;
  firebase_auth.User? _user;
  // If this._busy=true, the buttons are not clickable. This is to avoid
  // clicking buttons while a previous onTap function is not finished.
  // ถ้า this._busy=true ปุ่มต่างๆ จะไม่สามารถคลิกได้ นี่คือการหลีกเลี่ยง
  // คลิกปุ่มในขณะที่ฟังก์ชัน onTap ก่อนหน้ายังไม่เสร็จสิ้น
  bool _busy = false;
  var user;
  // แสดงโปรไฟล์ของผู้ใช้ในหน้าจอใหม่
  void _showUserProfilePage(firebase_auth.User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: const Text('user profile'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(title: Text('User: $user')),
              ListTile(title: Text('User id: ${user.uid}')), // id
              ListTile(title: Text('Display name: ${user.displayName}')),
              ListTile(
                  title: Text(
                      'Anonymous: ${user.isAnonymous}')), // เช็กว่าเป็น Anonymous
              ListTile(title: Text('Email: ${user.email}')), // email
              ListTile(
                title: const Text('Profile photo: '),
                trailing: user.photoURL != null
                    ? CircleAvatar(
                        //ภาพ Profile
                        backgroundImage: NetworkImage(user.photoURL!),
                      )
                    : CircleAvatar(
                        //ทำภาพเป็น ตัวอักษร
                        child: Text(user.displayName![0]),
                      ),
              ),
              ListTile(
                title: Text(
                    'Last sign in: ${user.metadata.lastSignInTime}'), //เข้าสู่ระบบครั้งล่าสุด
              ),
              ListTile(
                title: Text(
                    'Creation time: ${user.metadata.creationTime}'), //เวลาสร้างเเอ็กเคา
              ),
              ListTile(
                  title: Text(
                      'ProviderData: ${user.providerData}')), //ข้อมูลผู้ให้บริการ
              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ProductListGoogleLogin()),
                    // );
                  },
                  child: const Text('ถัดไป'))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('firebase == user');
    _user = _auth.currentUser;
    // _auth.authStateChanges().listen((firebase_auth.User? usr) {
    //   _user = usr;
    //   debugPrint('user=$_user');
    // });
    print('firebase == end');
  }

  @override
  Widget build(BuildContext context) {
    //Widget Button google login
    final googleLoginBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blueAccent,
      ),
      onPressed: _busy
          ? null
          : () async {
              setState(() => _busy = true);

              final user = await _googleSignIn();

              // setState(() => _busy = false);
              if (mounted) {
                setState(() => _busy = false);
                print('กำลังทำงาน = $mounted');
              }
              print('_busy = $mounted');
            },
      child: const Text('Log in with Google'),
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Image.asset(
                  'assets/images/vgistic.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment(0, 0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF0AC258),
                            ),
                            alignment: Alignment(0, 0),
                            child: Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'ชื่อผู้ใช้',
                          labelStyle: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          hintText: 'ชื่อผู้ใช้',
                          hintStyle: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF0AC258),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF0AC258),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Color(0xFF616161),
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment(0, 0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF0AC258),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(1),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            alignment: Alignment(0, 0),
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          labelStyle: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          hintText: 'รหัสผ่าน',
                          hintStyle: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF0AC258),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF0AC258),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Color(0xFF616161),
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
                    child: TextButton(
                      onPressed: () {
                        // Get.toNamed(Routes.SEARCH_PASSWORD);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordView()),
                        );
                      },
                      child: Text(
                        'ลืมรหัสผ่าน',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Color(0xFF0AC258),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: SizedBox(
                  height: 47,
                  width: 325,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0AC258),
                    ),
                    child: Text(
                      "เข้าสู่ระบบ",
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();

                      if (email.isEmpty) {
                        print("Email is Empty");
                      } else {
                        if (password.isEmpty) {
                          print("Password is Empty");
                        } else {
                          context.read<AuthService>().login(
                                email,
                                password,
                              );
                        }
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text('หรือ')),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: SizedBox(
                            height: 47,
                            width: 325,
                            child: ElevatedButton.icon(
                              onPressed: _busy
                                  ? null
                                  : () async {
                                      setState(() => _busy = true);

                                      final user = await _googleSignIn();

                                      // setState(() => _busy = false);
                                      if (mounted) {
                                        setState(() => _busy = false);
                                        print('กำลังทำงาน = $mounted');
                                      }
                                      print('_busy = $mounted');
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 4,
                                side: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                                textStyle: GoogleFonts.getFont(
                                  'Roboto',
                                  color: const Color(0xFF1877F2),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.transparent,
                                size: 20,
                              ),
                              label: Text(
                                'Login with Google',
                                style: GoogleFonts.getFont(
                                  'Roboto',
                                  color: const Color(0xFF606060),
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-0.83, 0),
                          child: Container(
                            width: 22,
                            height: 22,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/google.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(
                      'ยังไม่มีบัญชี?',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Color(0xFF303030),
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        //await Get.toNamed(Routes.REGISTER);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterView()),
                        );
                      },
                      child: Text(
                        'ลงทะเบียน',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Color(0xFF27AE60),
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign in with Google.
  Future<firebase_auth.User?> _googleSignIn() async {
    try {
      final curUser = _user ?? _auth.currentUser;

      if (curUser != null && !curUser.isAnonymous) {
        return curUser;
      }
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Note: user.providerData[0].photoUrl == googleUser.photoUrl.
      final user = (await _auth.signInWithCredential(credential)).user;
      print('user = 1111111 $user');
      print('กำลังเข้า store');
      // นำข้อมูลใน firestore มาเเสดง
      final userData = await FirebaseFirestore.instance
          .collection('cars')
          .doc(user!.uid)
          .get();

      FirebaseAuth.instance.userChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
        }
      });
      if (userData.data() == null) {
        await db.setCars(
          //ใช้ setProduct เพื่อเพิ่มหรือแก้ไขเอกสารไปยังฐานข้อมูล Cloud Firestore
          cars: CarsModel(
            id: user.uid,
            userName: '${user.displayName}',
            state: false,
            statejob: false,
            images: user.photoURL!,
            cartype: '',
            location: '',
            time: '',
            cost: '',
            phone: user.phoneNumber ?? '',
            email: user.email ?? '',
          ),
        );
      }
      // ต้องเอาออกเมื่อใช้เสร็จ
      // await db.setUsersPublic(
      //     //ใช้ setProduct เพื่อเพิ่มหรือแก้ไขเอกสารไปยังฐานข้อมูล Cloud Firestore
      //     users: UsersModel(
      //       id: user.uid,
      //       userName: '${user.displayName}',
      //       state: false,
      //       images: user.photoURL!,
      //       location: '',
      //       time: '',
      //       phone: user.phoneNumber ?? '',
      //       email: user.email ?? '',
      //       address: '',
      //     ),
      //   );
    } catch (err) {
      print(err);
    }
    kFirebaseAnalytics.logLogin();
    if (mounted) {
      setState(() => _user = user);
      print('mouted user = $mounted');
    }

    return user;
  }

  // Sign in Anonymously.

}
