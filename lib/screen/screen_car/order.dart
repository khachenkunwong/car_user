import 'package:car_user/models/cars_model.dart';
import 'package:car_user/models/user_model.dart';
import 'package:car_user/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:uuid/uuid.dart';

import 'googlemappage.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  GoogleMapController? controller1;
  // ใช้เพื่อเกิบ My location ของผู้ใช้เช่น 19.00562,99.82707 หรือ lat,long
  LocationData? currentLocation;
  // เรียกใช้เพื่อติดต่อกับ Cloud Firestore เพี่อ get set updata delete
  Database db = Database.instance;
  // เอามาใช้เพื่อหา my location ของผู้ใช้
  Location? location;
  // เอาไว้สร้าง id แบบไม่ซ้ำ
  var uuid = Uuid();
  // 35-45 เอาไว้เก็บฟิลใน firebase
  var state_userpublic;
  var state1;
  var userName_userpublic;
  var images_userpublic;
  var location1_userpublic;
  var time_userpublic;
  var phone_userpublic;
  var email_userpublic;
  var address_userpublic;
  var id_userpublic;
  var id_cars;
  // ทำเพื่อเมื่อต้องการกดให้หน้า google map ที่เราตั้งไว้มันจะจำให้หน้า google map
  // เลื่อหาตำแหน่งของผู้ใช้งานที่อยู่ในปัจจุบัน หรือที่อื้นที่เรากำหนดไว้ เช่น 19.00562,99.82707
  void mapCreated(controller2) {
    controller1 = controller2;
  }

  @override
  void initState() {
    super.initState();
    //ตัว ทำให้มีลูกศอน location ของตำเเหน่งตัวเอง
    location = Location();
    // วิธีเอา lat,long ของตำเเหน่งของผู้ใช้งานมาใส่ในตัวแปร currentLocation
    location?.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
    });
    print('currentLocation = {$currentLocation}');
  }

  // เลือกดู collection cars ใน Cloud Firestore
  CollectionReference state3 = FirebaseFirestore.instance.collection('cars');

  @override
  Widget build(BuildContext context) {
    // เรียกใช้ collection cars ใน Cloud Firestore มาเพื่อเป็นส่วนนึกในการแสดงข้อมูล
    // หมายเหตุ type ต้องตรงกัน <List<CarsModel>>
    Stream<List<CarsModel>> state1 = db.getCars();
    // เรียกใช้ collection userspublic ใน Cloud Firestore มาเพื่อเป็นส่วนนึกในการแสดงข้อมูล
    Stream<List<UsersModel>> state2 = db.getUsersPublic();
    // เรียกใช้ collection getjob ใน Cloud Firestore มาเพื่อเป็นส่วนนึกในการแสดงข้อมูล
    Stream<List<UsersModel>> state4 = db.getGetJob();
    // แรนดอม id เช่น ScQHfMOi1UYPXkvvv08DI7JsFh23
    var uid = uuid.v1();
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;

    return DefaultTabController(
      // มี Tabbar 2อัน
      length: 2,
      // เริ่มที่หน้า เเรก แต่ถ้าหน้า 2 ต้องกำหนดเป็น 1
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFF0AC258),
          // กำหนด Tabar และกำหนดสี
          bottom: TabBar(
            labelColor: Color(0xFF8C6262),
            indicatorColor: Color(0xFFC4C4C4),
            tabs: [
              // กำหนดชื่อของ Tabbar
              Tab(
                text: 'รายการ',
              ),
              Tab(
                text: 'รับเเล้ว',
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              // ล็อกเอาท์
              FirebaseAuth.instance.signOut();
            },
          ),
          actions: [
            // เป็นการนำ collection cars ใน Cloud Firestore มาเพื่อแสดงข้อมูล
            // Widget StreamBuilder ที่ใช้เพราะจะได้แสดงข้อมูลแบบเรียวทาม
            // หมายเหตุ type ต้องตรงกัน <List<CarsModel>>
            StreamBuilder<List<CarsModel>>(
                // หมายเหตุ ต้องกำหนด type เป็น Stream<List<CarsModel>> เท่านั้น ใช้ตัวอื้นอย่าง
                // UsersModel ไม่ได้มันจะ error และในขณะเดียวกัน ถ้า StreamBuilder<List<UsersModel>>
                // เป็นอย่างนี้ถึงจะสามารถใส่ Stream<List<UsersModel>>
                // state1 มี type เป็น Stream<List<CarsModel>>
                stream: state1,
                // ตัวที่จะเอาไปใช้ในการดูข้อมูลได้คือ snapshot
                builder: (context, snapshot) {
                  // ที่ใช้ตัวนี้เพราะต้องการนำข้อมูลของคนที่ login ชี้ไปยังข้อมูลอย่างถูกต้องเพราะ
                  // ข้อมูลใน firebase คล้ายๆกับ list ที่ต้องกำหนด index เวลาดูเช่น
                  // snapshot00.data?[0].userName คือข้อมูล userName มาแสดง
                  // ถ้ายังไม่เข้าใจก็คือ ถ้าใน Cloud Firestore มี 2 แอกเคาท์
                  // แล้วเราจะต้องกำหนด index เพื่อให้ดูข้อมูลที่ต้องการ เช่น snapshot00.data?[0]
                  // คือ เเอกเคาท์ ที่ 1 snapshot00.data?[2] เเต่ไม่สามารถกำหนดอย่างนี้ได้
                  // เพราะเมื่อเรามีหลายเเอกเคาท์ มันจะไม่ตรงกับ ข้อมูลของผู้ใช้
                  return FutureBuilder<DocumentSnapshot>(
                      // ตัวนี้ใช้การชี้ไปยังข้อมูลผู้ใช้เลยโดยที่ไม่ต้องใช้ index เพราะอันนี้กำหนด
                      // id ผู้ใช้โดยตรงเลย
                      future: state3.doc('${_user?.uid}').get(),
                      builder: (context, snapshot5) {
                        // กรณี่ถ้าข้อมูลที่เรียกใช้งาน error
                        if (snapshot5.hasError) {
                          return Text("error");
                        }

                        // เช็คว่ามีข้อมูล ฟิล์ใน document id ข้องผู้ใช้หรือไม่
                        if (snapshot5.hasData) {
                          print(
                              'snapshot5.data?.data() ${snapshot5.data?.data()}');
                          if (snapshot5.data?.data() == null) {
                            return Center(child: Text("รอ.."));
                          }
                          // ไม่รู้
                          if (snapshot5.connectionState ==
                              ConnectionState.done) {
                            // นำข้อมูลใน Cloud Firestore มาเก็มในตัวเเปร data
                            // การกำหนด ! หน้า .data()เป็นการบอกว่า snapshot5.data
                            // มีข้อมูลเเน่นอน เเต่ถ้าไม่เเน่ใจว่ามีข้อมูลหรือไม่ให้ใส่ ? แทน !
                            // ! จะใช้บางกรณีเพราะมันจะทำให้ error ถ้าไม่มีข้อมูล

                            Map<String, dynamic> data =
                                snapshot5.data?.data() as Map<String, dynamic>;
                            this.state1 = data['state'];
                            // เช็ค ข้อมูลฟิล state ในข้อมูลผู้ใช้ว่าไม่ว่างหรือไม่ถ้าไม่ว่างเข้าเงื่อนไขนี้
                            // data['state'] type คือ bool ใน Cloud Firestore
                            if (data['state'] != null) {
                              // สวิดเปิดปิด
                              return FlutterSwitch(
                                // ขนาดของสวิต
                                width: 70.0,
                                height: 35.0,
                                valueFontSize: 15.0,
                                toggleSize: 25.0,
                                // นำข้อมูลใน Cloud Firestore ฟิล state มาเเสดงเพี่อที่จะได้รู้ว่า
                                // ผู้ใช้มีสถาะว่างหรือไม่
                                value: data['state'],
                                borderRadius: 20.0,
                                padding: 3.0,
                                showOnOff: true,
                                activeColor: Colors.greenAccent,
                                // val เป็นค่าใน widget นี้ โดยที่เราไม่ได้ประการตัวเเปลนี้เอง
                                // คือมันติดมากับ widget นี้อยู่เเล้ว
                                // val เป็นการบอกว่าสวิดเปิดหรือปิดอยู่โดยouput เป็น true false
                                onToggle: (bool val) {
                                  // เอาไว้กัน error
                                  try {
                                    // ทำการอัพเดต State โดยเฉพาะลงใน Cloud Firestore
                                    db.updateCarsState(
                                        // กำหนดให้อัพเดต val ลงใน Cloud Firestore
                                        cars: CarsModel(state: val));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              );
                            }
                          }
                        }
                        // จะแสดงเมื่อข้อมูลยังโหลดไม่เสร็จ
                        return Text('');
                      });
                }),
          ],
          title: Row(
            children: [
              Text(
                'เลือก',
                style: GoogleFonts.getFont(
                  'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    print('uid = $uid');
                    //ใช้ setProduct เพื่อสร้างเอกสารไปยังฐานข้อมูล Cloud Firestore
                    await db.setUsersPublic(
                      users: UsersModel(
                        // กำหนด id โดยการเเรนดอม
                        id: '$uid',
                        // กำหนดข้อมูลจาก Authentication ที่เป็น name ของผู้ใช้
                        userName: '${_user?.displayName}',
                        // กำนหดให้ state มีค่าเริ่มต้นเป็น false
                        state: false,
                        // กำหนดข้อมูลจาก Authentication ที่เป็น urlภาพ ของผู้ใช้ ลงไปในฐานข้อมูล Cloud Firestore
                        // ลงในฟิล images
                        images: _user?.photoURL!,
                        location: '',
                        time: '',
                        // กำหนดข้อมูลจาก Authentication ที่เป็น เบอร์โทร ของผู้ใช้ ลงไปในฐานข้อมูล Cloud Firestore
                        // ลงใน ฟิล phone การใช้ตัวนี้ ?? ก็เหมือนกับการใช้ if else เช่น
                        // if (_user?.phoneNumber != null) {
                        // คือถ้าไม่ได้เป็นค่าว่างก็จะไม่ทำอะไร เช่นค่าเดิมคือ 08830303030 ก็จะกำหนดเป็น 08830303030 เหมือนเดิม
                        //   return _user?.phoneNumber;
                        // } else {
                        //  ถ้าค่าว่างก็จะกำหนดเป็น ''
                        //  return '';
                        // }
                        phone: _user?.phoneNumber ?? '',
                        email: _user?.email ?? '',
                        address: '',
                      ),
                    );
                    // สั่งให้ รีโหลดหน้า
                    setState(() {
                      print('relord');
                    });
                  },
                  child: Text('เพิ่มรายการ')),
            ],
          ),
          centerTitle: true,
          elevation: 4,
        ),
        body: SafeArea(
          // เป็นส่วนประกอบข้อง TabBar
          child: TabBarView(
            children: [
              // tabview ที่ 1 ที่ชื่อ รายการ
              // นำข้อมูลใน collection cars มาแสดง
              StreamBuilder<List<CarsModel>>(
                  stream: state1,
                  builder: (context, snapshot1) {
                    return Container(
                      padding: EdgeInsets.only(top: 10),
                      // นำข้อมูลใน collection users มาแสดง
                      child: StreamBuilder<List<UsersModel>>(
                        stream: state2,
                        builder: (context, snapshot) {
                          return FutureBuilder<DocumentSnapshot>(
                              future: state3.doc('${_user?.uid}').get(),
                              builder: (context, snapshot5) {
                                if (snapshot5.hasError) {
                                  return Text("Something went wrong");
                                }
                                // เช็คว่ามีข้อมูลที่สร้างขึ้นมาหรือไม่
                                if (snapshot.hasData) {
                                  if (snapshot5.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> data = snapshot5.data!
                                        .data() as Map<String, dynamic>;
                                    this.state1 = data['state'];

                                    // เช็คว่ามีข้อมูลหรือไม่ คือมี collection
                                    // แต่ไม่มี ฟิลท์
                                    if (snapshot.data?.length == 0) {
                                      return Center(
                                        child: Text('ยังไม่มีข้อมูลสินค้า'),
                                      );
                                    }
                                    print('มีสมาชิกไหม ${snapshot.hasData}');
                                    // ป้องกัน ฟิลท์ state เป็นค่าว่าง
                                    if (data['state'] != null) {
                                      // เอาไว้ดักเมื่อเราเปิดว่างงานเเล้วเเสดงงาน
                                      if (data['state'] == true) {
                                        // ใช้listview เพื่อให้มันเรียกข้อมูลมาแสดงตามลำดับโดยใช้ตัวอ่างอิงเป็นindex
                                        // ก็คือมีเเบบ กำหนดตำเเหน่งข้อมูลของผู้ใช้ เป็น id กลับ index หรือก็คือมี 2วิธี
                                        return ListView.builder(
                                          // ใน collection นั้นมี doc กีตัว เเล้วกำหนดจำนวนลงใน itemCount
                                          itemCount: snapshot.data?.length,
                                          itemBuilder: (context, index) {
                                            // Slidable ทาให้เวลาเลื่อนมีเเถบเมนู
                                            return Slidable(
                                              // ไม่รู้ว่าทำไหมถึงกำหนดตัวนี้เพราะไป copy มา
                                              actionPane:
                                                  SlidableScrollActionPane(),
                                              // กำหนดว่ามีเเถบเมนูมีอะไรบ้าง
                                              actions: [
                                                IconSlideAction(
                                                  caption: 'รับงาน',
                                                  color: Colors.green,
                                                  icon: Icons.archive,
                                                  onTap: () {
                                                    print('ลบ');
                                                    // 1.หลักการของการรับงานนั้นก็คือนำข้อมูลที่เลือกใน collection userspublic  มาเก็บไว้ใน
                                                    // collection getjob เเปลว่ารับงาน โดย collection getjob ถูกครอบด้วย collection users ของ doc(id) ที่กำหนด
                                                    // หมายความว่าผู้ใช้จะดู getjob ของคนอื้นไม่ได้ถ้ายังไม่รู้จัก id ของอีกคน
                                                    // 2.นำข้อมูลที่เลือกใน collection userspublic มาเก็บไว้ใน collection jobhistory แปลว่าประวัติงาน
                                                    // 3.ลบ collection userspublic ที่เลือกไว้ ตัวนี้ไม่ได้หมายถึงลบ collection userspublic เเต่หมายถึงลบ doc ที่เลือกไว้ใน collection userspublic
                                                    // เพราะใน collection userspublic มี doc หลายตัวหรืองานหลายอัน

                                                    db.setGetJob(
                                                      users: UsersModel(
                                                        id: snapshot
                                                            .data?[index].id,
                                                        userName: snapshot
                                                            .data?[index]
                                                            .userName,
                                                        state: snapshot
                                                            .data?[index].state,
                                                        images: snapshot
                                                            .data?[index]
                                                            .images,
                                                        location: snapshot
                                                            .data?[index]
                                                            .location,
                                                        time: snapshot
                                                            .data?[index].time,
                                                        phone: snapshot
                                                            .data?[index].phone,
                                                        email: snapshot
                                                            .data?[index].email,
                                                        address: snapshot
                                                            .data?[index]
                                                            .address,
                                                      ),
                                                    );
                                                    db.setJobHistory(
                                                      users: UsersModel(
                                                        id: snapshot
                                                            .data?[index].id,
                                                        userName: snapshot
                                                            .data?[index]
                                                            .userName,
                                                        state: snapshot
                                                            .data?[index].state,
                                                        images: snapshot
                                                            .data?[index]
                                                            .images,
                                                        location: snapshot
                                                            .data?[index]
                                                            .location,
                                                        time: snapshot
                                                            .data?[index].time,
                                                        phone: snapshot
                                                            .data?[index].phone,
                                                        email: snapshot
                                                            .data?[index].email,
                                                        address: snapshot
                                                            .data?[index]
                                                            .address,
                                                      ),
                                                    );
                                                    // กำหนด this เพื่อเก็บ ตัวเเปลนอก class
                                                    // ถ้าไม่ทำอย่างนี้ก็จะทำให้เวลาเรียกใช้ id_userpublic
                                                    // ก็จะไม่มีค่า snapshot.data?[index].id; มาเเสดง
                                                    // เเต่จะเป็นค่าอื้นที่เรากำหนดค่าเริ่มต้นไว้ตอนประการตัวเเปล
                                                    this.id_userpublic =
                                                        snapshot
                                                            .data?[index].id;
                                                    this.userName_userpublic =
                                                        snapshot.data?[index]
                                                            .userName;
                                                    this.state_userpublic =
                                                        snapshot
                                                            .data?[index].state;
                                                    this.images_userpublic =
                                                        snapshot.data?[index]
                                                            .images;
                                                    this.location1_userpublic =
                                                        snapshot.data?[index]
                                                            .location;
                                                    this.time_userpublic =
                                                        snapshot
                                                            .data?[index].time;
                                                    this.phone_userpublic =
                                                        snapshot
                                                            .data?[index].phone;
                                                    this.email_userpublic =
                                                        snapshot
                                                            .data?[index].email;
                                                    this.address_userpublic =
                                                        snapshot.data?[index]
                                                            .address;

                                                    // doc ใน collection userspublic ที่เลือกไว้จะถูกลบ

                                                    db.deleteUsersPublic(
                                                        users: UsersModel(
                                                            id: snapshot
                                                                .data?[index]
                                                                .id));
                                                  },
                                                ),
                                              ],
                                              child: Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    print('คลิก');
                                                    // db.setOrder(setorder: OrderModel(id: 'PYsl6xWkT38546necrxt', cartype: 'รถกระบะ', cost: '10 บาท', location: 'GeoPoint(-26.1711459, 27.9002758)', name: 'arm', state: false, stategetjob: false, time: '30 นาที'));
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                    height: 127,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/pes.png',
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      0, 0, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // เเสดงชื่อของคนให้งาน
                                                              Text(
                                                                'ชื่อพ่อค้าเเม่ค้า: ${snapshot.data?[index].userName}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .getFont(
                                                                  'Poppins',
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'สถานะ: ',
                                                                    style: GoogleFonts
                                                                        .getFont(
                                                                      'Poppins',
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data?[index].state}',
                                                                    style: GoogleFonts
                                                                        .getFont(
                                                                      'Poppins',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                'ใช้เวลา: ${snapshot.data?[index].time} นาที',
                                                                style:
                                                                    GoogleFonts
                                                                        .getFont(
                                                                  'Poppins',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );

                                            // Dismissible(
                                            //   key: UniqueKey(),
                                            //   child: OrderItem(
                                            //     order: snapshot.data![index],
                                            //   ),
                                            //   onDismissed: (a) {
                                            //     print('aaaaa = $a');
                                            //   },

                                            //   background: Container(
                                            //     color: Colors.red,
                                            //   ),
                                            //   onResize: () {
                                            //     print('arms');
                                            //   },

                                            // );
                                          },
                                        );
                                      }
                                    }
                                    // จะเเสดงเมื่อปิดสวิส
                                    return Center(
                                        child:
                                            Text('คุณปิดรับงานอยู่ในขณะนี้'));
                                  }
                                }
                                // จะเเสดงเมื่อเกิด error หรือ type ไม่ตรงกันเพราะงานต้องเช็ค ฟิลในCloud Firestore
                                // และ ในmodelที่เขียนไว้ใน cars_model.dart และ user_model.dart ว่า type ตรงกันไหม
                                return Center(
                                    child: CircularProgressIndicator());
                              });
                        },
                      ),
                    );
                  }),

              // tabview ที่ 2 คือเเทบที่ชื่อ รับงานแล้ว
              StreamBuilder<List<UsersModel>>(
                  stream: state4,
                  builder: (context, snapshot00) {
                    if (snapshot00.hasError) {
                      return Center(child: Text('เกิดข้อผิดพลาด'));
                    }
                    if (snapshot00.data?.length == 0) {
                      return Center(
                        child: Text('ยังไม่ได้รับงาน'),
                      );
                    }
                    if (snapshot00.hasData) {
                      return ListView.builder(
                          itemCount: snapshot00.data?.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 350,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment(-0.95, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            'รับมาจาก ${snapshot00.data?[index].userName}',
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: Color(0xFF303030),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Align(
                                        alignment: Alignment(-0.95, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            'ได้รับงานจาก VGISTIC0075',
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: Color(0xFF303030),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment(-0.95, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            'วันที่เริ่มงาน 12-03-2543 ${snapshot00.data?[index].time}',
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: Color(0xFF303030),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment(-0.95, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            snapshot00.data?[index].state ==
                                                    true
                                                ? 'สถานะ รับงานแล้ว'
                                                : 'สถานะ รอรับงาน',
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: Color(0xFF303030),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 20, 0, 0),
                                        child: SizedBox(
                                          width: 335,
                                          height: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0x003474E0),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'ติดต่อปลายทาง',
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: SizedBox(
                                          width: 335,
                                          height: 48,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF0AC258),
                                            ),
                                            onPressed: () {
                                              // ไปหน้า googlemmap
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => GoogleMapPage(
                                                          // lat:
                                                          //     snapshot00.data[
                                                          //             index]
                                                          //         .lat,
                                                          // long:
                                                          //     snapshot00.data[
                                                          //             index]
                                                          //         .long,
                                                          )));
                                            },
                                            child: Text(
                                              'เริ่มงาน',
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: SizedBox(
                                          width: 335,
                                          height: 48,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                            ),
                                            onPressed: () {
                                              // 1.การยกเลิกงานคือลบ doc ใน collection getjob โดยในต้องส่งค่า id ของ user เข้าไปใน deleteGetJob ด้วยตันนี้จำเป็น
                                              // 2.ลบ doc ใน collection jobhistory โดยในต้องส่งค่า id ของ user เข้าไปใน deleteJobHistory ด้วยตันนี้จำเป็นจำเป็น
                                              // 3.นำ ค่าที่เคยส่งเค้าไปใน collection getjob และ collection jobhistory กลับคืนมา ใน collection userspublic
                                              // ทั้งหมด ถ้าสงสัยข้อนี้ควรกับไปดูบันทัดที่ 306 ลงมาดูก่อน
                                              print(
                                                  'id_userpublic = $id_userpublic');
                                              db.deleteGetJob(
                                                  users: UsersModel(
                                                // id จาก collection users
                                                id: '${snapshot00.data?[index].id}',
                                              ));
                                              db.deleteJobHistory(
                                                  users: UsersModel(
                                                // id จาก collection users
                                                id: '${snapshot00.data?[index].id}',
                                              ));
                                              db.setUsersPublic(
                                                  users: UsersModel(
                                                id: '${snapshot00.data?[index].id}',
                                                images:
                                                    '${snapshot00.data?[index].images}',
                                                userName:
                                                    '${snapshot00.data?[index].userName}',
                                                location:
                                                    '${snapshot00.data?[index].location}',
                                                state: false,
                                                time:
                                                    '${snapshot00.data?[index].time}',
                                                email:
                                                    '${snapshot00.data?[index].email}',
                                                phone:
                                                    '${snapshot00.data?[index].phone}',
                                                address:
                                                    '${snapshot00.data?[index].address}',
                                              ));
                                            },
                                            child: Text(
                                              'ยกเลิกงาน',
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Align(
                                      alignment: Alignment(-0.9, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'จุดรับสินค้า',
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 0, 0),
                                            child: Text(
                                              'บ้านโพธิ์ชัย ต.หนองกวั่ง อ.บ้านม่วง จ.สกลนคร ${snapshot00.data?[index].address}',
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: Color(0xFF666666),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            child: Text(
                                              '47120',
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: Color(0xFF666666),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            child: Text(
                                              '138 กิโล',
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: Color(0xFF666666),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceAround,
                                          //   children: [
                                          //     SizedBox(
                                          //       width: 169,
                                          //       height: 40,
                                          //       child: ElevatedButton(
                                          //           style: ElevatedButton
                                          //               .styleFrom(
                                          //                   primary: Color(
                                          //                       0xFF0BA11A)),
                                          //           onPressed: () {},
                                          //           child: Text(
                                          //             'เปิดเส้นทาง',
                                          //             style:
                                          //                 GoogleFonts.getFont(
                                          //               'Poppins',
                                          //               color: Colors.black,
                                          //               fontWeight:
                                          //                   FontWeight.normal,
                                          //               fontSize: 16,
                                          //             ),
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       width: 169,
                                          //       height: 40,
                                          //       child: ElevatedButton(
                                          //           style: ElevatedButton
                                          //               .styleFrom(
                                          //                   primary: Color(
                                          //                       0xFF0BA11A)),
                                          //           onPressed: () {},
                                          //           child: Text(
                                          //             'เสร็จงาน',
                                          //             style:
                                          //                 GoogleFonts.getFont(
                                          //               'Poppins',
                                          //               color: Colors.black,
                                          //               fontWeight:
                                          //                   FontWeight.normal,
                                          //               fontSize: 16,
                                          //             ),
                                          //           )),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                ////////
                              ],
                            );
                          });
                    }
                    // ถ้า error คือ type ของฟิลตัวใดตัวหนึ่งไม่ตรงให้ทำตรงนี้
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
