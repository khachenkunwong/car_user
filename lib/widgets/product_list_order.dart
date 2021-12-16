import 'package:car_user/models/cars_model.dart';
import 'package:car_user/models/user_model.dart';
import 'package:car_user/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Database db = Database.instance;
  CollectionReference state3 = FirebaseFirestore.instance.collection('cars');
  var state;
  @override
  Widget build(BuildContext context) {
    Stream<List<UsersModel>> state = db.getUsersPublic();
    Stream<List<CarsModel>> state2 = db.getCars();
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    return StreamBuilder<List<CarsModel>>(
        stream: state2,
        builder: (context, snapshot1) {
          return Container(
            padding: EdgeInsets.only(top: 10),
            child: StreamBuilder<List<UsersModel>>(
              stream: state,
              builder: (context, snapshot) {
                return FutureBuilder<DocumentSnapshot>(
                    future: state3.doc('${_user?.uid}').get(),
                    builder: (context, snapshot5) {
                      if (snapshot5.hasError) {
                        return Text("Something went wrong");
                      }
                      // เช็คว่ามีข้อมูลที่สร้างขึ้นมาหรือไม่
                      if (snapshot.hasData) {
                        if (snapshot5.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot5.data!.data() as Map<String, dynamic>;
                          this.state = data['state'];

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
                                    actionPane: SlidableScrollActionPane(),
                                    actions: [
                                      IconSlideAction(
                                        caption: 'รับงาน',
                                        color: Colors.green,
                                        icon: Icons.archive,
                                        onTap: () {
                                          print('ลบ');
                                          db.setGetJob(
                                            users: UsersModel(
                                              id: snapshot.data?[index].id,
                                              userName: snapshot
                                                  .data?[index].userName,
                                              state:
                                                  snapshot.data?[index].state,
                                              images:
                                                  snapshot.data?[index].images,
                                              location: snapshot
                                                  .data?[index].location,
                                              time: snapshot.data?[index].time,
                                              phone:
                                                  snapshot.data?[index].phone,
                                              email:
                                                  snapshot.data?[index].email,
                                              address:
                                                  snapshot.data?[index].address,
                                            ),
                                          );
                                          db.setJobHistory(
                                            users: UsersModel(
                                              id: snapshot.data?[index].id,
                                              userName: snapshot
                                                  .data?[index].userName,
                                              state:
                                                  snapshot.data?[index].state,
                                              images:
                                                  snapshot.data?[index].images,
                                              location: snapshot
                                                  .data?[index].location,
                                              time: snapshot.data?[index].time,
                                              phone:
                                                  snapshot.data?[index].phone,
                                              email:
                                                  snapshot.data?[index].email,
                                              address:
                                                  snapshot.data?[index].address,
                                            ),
                                          );
                                          // db.deleteUsersPublic(
                                          //     users: UsersModel(
                                          //         id: snapshot
                                          //             .data?[index].id));
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          height: 127,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/pes.png',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'ชื่อพ่อค้าเเม่ค้า: ${snapshot.data?[index].userName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.getFont(
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
                                                          GoogleFonts.getFont(
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
                              child: Text('คุณปิดรับงานอยู่ในขณะนี้'));
                        }
                      }

                      return Center(child: CircularProgressIndicator());
                    });
              },
            ),
          );
        });
  }
}
