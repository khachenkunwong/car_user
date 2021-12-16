import 'dart:async';

import 'package:car_user/models/cars_model.dart';
import 'package:car_user/service/database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  final lat;
  final long;
  const GoogleMapPage({Key? key, this.lat, this.long}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Location? location;
  LocationData? currentLocation;
  GoogleMapController? controller;
  Database db = Database.instance;
  List listindex = [0, 0];
  int index1 = 0;

  Future _goToMe() async {
    currentLocation = await location?.getLocation();
    print('currentLocation: ${currentLocation?.latitude}');

    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation!.latitude!.toDouble(),
          currentLocation!.longitude!.toDouble()),
      zoom: 16,
    )));

    // print('${currentLocation!.latitude}, ${currentLocation!.longitude}');
  }

  void mapCreated(controller2) {
    controller = controller2;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    location = Location(); //ตัว ทำให้มีลูกศอน location ของตัวเอง

    location?.onLocationChanged.listen((LocationData cLoc) {
      print('currentLocation: ${currentLocation?.latitude}');
      setState(() {
        currentLocation = cLoc;
      });
      // currentLocation = cLoc;
      // if (index1 == 0) {
      //   if (currentLocation?.latitude != null) {
      //     print("index1: $index1");
      //     // add listindex ที่ตำแหน่ง 0 เพื่อให้มันไม่ซ้ำกัน
      //     listindex[0] = currentLocation?.latitude;
      //     index1 += 1;
      //   }
      // } else {
      //   if (currentLocation?.latitude != null) {
      //     listindex[1] = currentLocation?.latitude;
      //     if (listindex[0] - listindex[1] == 0) {
      //       print("index1: $index1");
      //       setState(() {
      //         currentLocation = cLoc;
      //       });
      //     }
      //     index1 = 0;
      //   }
      // }
      print("listindex: $listindex");

      // print('currentLocation?.latitude: ${currentLocation?.latitude}');
      // controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //   //CameraPosition ใช้อั้นเดียวกันกับค่าเริ่มต้น

      //   target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      //   zoom: 16.0,
      // )));
    });
    print('${currentLocation?.latitude}, ${currentLocation?.longitude}');

    // เรียกดู location ของฉันในขณะนี้
    // location?.getLocation().then((LocationData cLoc) {
    //   print('cLoc.latitude: ${cLoc.latitude} 2');
    //   currentLocation = cLoc;
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    Stream<List<CarsModel>> state1 = db.getCars();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        backgroundColor: Color(0xFF0AC258),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _goToMe();
        }, //_goToMe,
        label: Text('My location'),
        icon: Icon(Icons.near_me),
      ),
      body: StreamBuilder<List<CarsModel>>(
          stream: state1,
          builder: (context, snapshot) {
            if (currentLocation?.latitude != null) {
              return Container(
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  mapToolbarEnabled: true, //เเถบเครื่องมือถ้าเป็น จริง
                  rotateGesturesEnabled: true, //ตอบสนองการหมุนเมือเเตะ จริง
                  scrollGesturesEnabled: true, //ตอบสนองการเลื่อนเมือเเตะ จริง
                  zoomGesturesEnabled: true, //ตอบสนองการซูมเมือเเตะ จริง
                  tiltGesturesEnabled: false,
                  trafficEnabled: true, // เปิดการจราจร จริง
                  mapType: MapType.normal,
                  // markers: Set.from(controller.allMarkers),

                  // กำหนดตำแหน่งเริ่มต้น
                  initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!.toDouble(),
                          currentLocation!.longitude!.toDouble()),
                      zoom: 16.0),
                  // ทำให้เมื่อทำการอัพเดด lat long เมื่อมีการกำหนด
                  onMapCreated: mapCreated,
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
