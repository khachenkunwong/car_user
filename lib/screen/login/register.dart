import 'package:car_user/service/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'forgot_password.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController actorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Image.asset(
                  'assets/images/vgistic.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                        controller: userController,
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
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                              Icons.email,
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'อีเมล์',
                          labelStyle: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          hintText: 'อีเมล์',
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
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                              Icons.phone,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทรศัพท์',
                          labelStyle: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          hintText: 'เบอร์โทรศัพท์',
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
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                        controller: actorController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Actor',
                          labelStyle: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          hintText: 'Actor',
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
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: TextButton(
                        child: Text(
                          'ลืมรหัสผ่าน',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            color: Color(0xFF0AC258),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordView()),
                          );
                        },
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: 325,
                  height: 47,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0AC258),
                    ),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      final String user = userController.text.trim();
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();
                      final String phone = phoneController.text.trim();

                      if (email.isEmpty) {
                        print("Email is Empty");
                      } else {
                        if (password.isEmpty) {
                          print("Password is Empty");
                        } else {
                          context
                              .read<AuthService>()
                              .signUp(
                                email,
                                password,
                                "user",
                                phone,
                                user,
                              )
                              .then((value) async {
                          
                            var user = FirebaseAuth.instance.currentUser;

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user?.uid)
                                .set({
                              "user": user,
                              "phone": phone,
                              'email': email,
                              'password': password,
                              'role': "user"
                            });
                          });
                        }
                      }
                      Navigator.pop(context);
                    },
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
                      'มีบัญชีอยู่แล้ว?',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: TextButton(
                      child: Text(
                        'เข้าสู่ระบบที่นี่',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Color(0xFF27AE60),
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text(
                    //     'เข้าสู่ระบบที่นี่',
                    //     style: GoogleFonts.getFont(
                    //       'Poppins',
                    //       color: Color(0xFF27AE60),
                    //       fontWeight: FontWeight.normal,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
