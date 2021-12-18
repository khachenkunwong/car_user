import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}
// หน้าลืมรหัสผ่านยังไม่ได้ใช้ตอนนี้
class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color(0xFF0AC258),
        automaticallyImplyLeading: true,
        title: Text(
          'ค้นหาบัญชีของคุณ',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Color(0xFF303030),
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text(
                  'โปรดป้อนอีเมลหรือหมายเลขโทรศัพท์ของ\nคุณเพื่อค้นหาบัญชีของคุณ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontSize: 18,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 50, 10, 1),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    alignment: Alignment(0, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: TextFormField(
                        controller: phoneController,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'หมายเลขโทรศัพท์มือถือ',
                          hintStyle: GoogleFonts.getFont(
                            'Roboto',
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                        style: GoogleFonts.getFont(
                          'Roboto',
                          color: Color(0xFF303030),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: SizedBox(
                    width: 345,
                    height: 49,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0AC258),
                      ),
                      child: Text(
                        'ค้นหาบัญชีของคุณ',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        print("ค้นหาบัญชี");
                      },
                    ),
                  )
                  // FFButtonWidget(
                  //   onPressed: () {
                  //     print('Button pressed ...');
                  //   },
                  //   text: 'ค้นหาบัญชีของคุณ',
                  //   options: FFButtonOptions(
                  //     width: 345,
                  //     height: 49,
                  //     color: Color(0xFF27AE60),
                  //     textStyle:
                  //     GoogleFonts.getFont(
                  //       'Poppins',
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 20,
                  //     ),
                  //     borderSide: BorderSide(
                  //       color: Colors.transparent,
                  //       width: 1,
                  //     ),
                  //     borderRadius: 12,
                  //   ),
                  // ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
