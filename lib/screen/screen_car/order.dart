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
  LocationData? currentLocation;
  Database db = Database.instance;
  Location? location;

  var uuid = Uuid();
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

  void mapCreated(controller2) {
    controller1 = controller2;
  }

  @override
  void initState() {
    super.initState();
    location = Location(); //ตัว ทำให้มีลูกศอน location ของตัวเอง
    location?.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
    });
    print('location?.getLocation() {$currentLocation}');
  }

  CollectionReference state3 = FirebaseFirestore.instance.collection('cars');

  @override
  Widget build(BuildContext context) {
    Stream<List<CarsModel>> state1 = db.getCars();
    Stream<List<UsersModel>> state2 = db.getUsersPublic();
    Stream<List<UsersModel>> state4 = db.getGetJob();

    var uid = uuid.v1();
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFF0AC258),
          bottom: TabBar(
            labelColor: Color(0xFF8C6262),
            indicatorColor: Color(0xFFC4C4C4),
            tabs: [
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
              FirebaseAuth.instance.signOut();
            },
          ),
          actions: [
            StreamBuilder<List<CarsModel>>(
                stream: state1,
                builder: (context, snapshot) {
                  return FutureBuilder<DocumentSnapshot>(
                      future: state3.doc('${_user?.uid}').get(),
                      builder: (context, snapshot5) {
                        if (snapshot5.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot5.hasData) {
                          if (snapshot5.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot5.data!.data() as Map<String, dynamic>;
                            this.state1 = data['state'];
                            if (data['state'] != null) {
                              return FlutterSwitch(
                                width: 70.0,
                                height: 35.0,
                                valueFontSize: 15.0,
                                toggleSize: 25.0,
                                value: data['state'],
                                borderRadius: 20.0,
                                padding: 3.0,
                                showOnOff: true,
                                activeColor: Colors.greenAccent,
                                onToggle: (bool val) {
                                  try {
                                    db.updateCarsState(
                                        cars: CarsModel(state: val));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              );
                            }
                          }
                        }

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
                    await db.setUsersPublic(
                      //ใช้ setProduct เพื่อเพิ่มหรือแก้ไขเอกสารไปยังฐานข้อมูล Cloud Firestore
                      users: UsersModel(
                        id: '$uid',
                        userName: '${_user?.displayName}',
                        state: false,
                        images: _user?.photoURL!,
                        location: '',
                        time: '',
                        phone: _user?.phoneNumber ?? '',
                        email: _user?.email ?? '',
                        address: '',
                      ),
                    );
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
          child: TabBarView(
            children: [
              StreamBuilder<List<CarsModel>>(
                  stream: state1,
                  builder: (context, snapshot1) {
                    return Container(
                      padding: EdgeInsets.only(top: 10),
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

                                    // เช็คว่ามีข้อมูลหรือไม่
                                    if (snapshot.data?.length == 0) {
                                      return Center(
                                        child: Text('ยังไม่มีข้อมูลสินค้า'),
                                      );
                                    }
                                    print('มีสมาชิกไหม ${snapshot.hasData}');
                                    if (data['state'] != null) {
                                      if (data['state'] == true) {
                                        return ListView.builder(
                                          itemCount: snapshot.data?.length,
                                          itemBuilder: (context, index) {
                                            return Slidable(
                                              actionPane:
                                                  SlidableScrollActionPane(),
                                              actions: [
                                                IconSlideAction(
                                                  caption: 'รับงาน',
                                                  color: Colors.green,
                                                  icon: Icons.archive,
                                                  onTap: () {
                                                    print('ลบ');

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
                                    return Center(
                                        child:
                                            Text('คุณปิดรับงานอยู่ในขณะนี้'));
                                  }
                                }

                                return Center(
                                    child: CircularProgressIndicator());
                              });
                        },
                      ),
                    );
                  }),

              /////////
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
                                                      builder: (context) =>
                                                          GoogleMapPage(
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
                                              print(
                                                  'id_userpublic = $id_userpublic');
                                              db.deleteGetJob(
                                                  users: UsersModel(
                                                id: '${snapshot00.data?[index].id}',
                                              ));
                                              db.deleteJobHistory(
                                                  users: UsersModel(
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
