// ใช้เพื่อติดต่อและจัดการข้อมูลไปยังฐานข้อมูลไปยังฐานข้อมูล Cloud Firestore เช้นการติดตามข้อมูลสินค้า การเพิ่มข้อมูล
// การแก้ไขข้อมูล และการลบข้อมูลสินค้า
import 'package:car_user/models/cars_model.dart';
import 'package:car_user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

//ติดต่อกับ firebase
class Database {
  static Database instance = Database._();
  Database._();
  Future<void> setCars({CarsModel? cars}) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    final reference =
        FirebaseFirestore.instance.collection('cars').doc('${_user?.uid}');
    // doc('users/SGxI1a2Zq9MKsTFvlGYzffd9aBn2/novel')
    try {
      await reference.set(cars!.toMap());
    } catch (err) {
      rethrow;
    }
  }
  Future<void> setUsers({UsersModel? user}) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    final reference =
        FirebaseFirestore.instance.collection('users').doc('${_user?.uid}');
    // doc('users/SGxI1a2Zq9MKsTFvlGYzffd9aBn2/novel')
    try {
      await reference.set(user!.toMap());
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setGetJob({UsersModel? users}) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    final reference = FirebaseFirestore.instance
        .collection('cars')
        .doc('${_user?.uid}')
        .collection('getjob')
        .doc("${users?.id}");
    // doc('users/SGxI1a2Zq9MKsTFvlGYzffd9aBn2/novel')
    try {
      await reference.set(users!.toMap());
      print('สร้าง getjob เรียบร้อย');
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setJobHistory({UsersModel? users, id}) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    final reference = FirebaseFirestore.instance
        .collection('cars')
        .doc('${_user?.uid}')
        .collection('jobhistory')
        .doc("${users?.id}");
    // doc('users/SGxI1a2Zq9MKsTFvlGYzffd9aBn2/novel')
    try {
      await reference.set(users!.toMap());
      print('สร้าง jobhistory เรียบร้อย');
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setUsersPublic({UsersModel? users}) async {
    final reference = FirebaseFirestore.instance
        .collection('userspublic')
        .doc('${users?.id}');
    // doc('users/SGxI1a2Zq9MKsTFvlGYzffd9aBn2/novel')
    try {
      await reference.set(users!.toMap());
      print('สร้าง user public แล้ว');
    } catch (err) {
      print('error ${err}');
      rethrow;
    }
  }

  Future<void> setCarsPublic({CarsModel? cars}) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    final reference = FirebaseFirestore.instance
        .collection('carspublic')
        .doc('${_user?.uid}');
    // doc('users/SGxI1a2Zq9MKsTFvlGYzffd9aBn2/novel')
    try {
      await reference.set(cars!.toMap());
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateCarsState({CarsModel? cars}) {
    final reference = FirebaseFirestore.instance.collection('cars');
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    return reference
        .doc(_user?.uid)
        .update({
          'state': cars?.state,
        })
        .then((value) => print("อัพเดต state"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateCarsStatejob({CarsModel? cars}) {
    final reference = FirebaseFirestore.instance.collection('cars');
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    return reference
        .doc(_user?.uid)
        .update({
          'statejob': cars?.statejob,
        })
        .then((value) => print("อัพเดต statejob"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Stream<List<CarsModel>> getCars() {
    final reference = FirebaseFirestore.instance.collection('cars');
    //เรียงเอกสารจากมากไปน้อย โดยใช้ ฟิลด์ id
    final snapshots = reference.snapshots();
    //QuerySnapshot<Map<String, dynamic>> snapshot
    //QuerySnapshot<Object?> snapshot
    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return CarsModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<UsersModel>> getUsersPublic() {
    final reference = FirebaseFirestore.instance.collection('userspublic');
    //เรียงเอกสารจากมากไปน้อย โดยใช้ ฟิลด์ id
    final snapshots = reference.snapshots();
    //QuerySnapshot<Map<String, dynamic>> snapshot
    //QuerySnapshot<Object?> snapshot
    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return UsersModel.fromMap(doc.data());
      }).toList();
    });
  }
  Stream<List<CarsModel>> getCarsPublic() {
    final reference = FirebaseFirestore.instance.collection('carspublic');
    //เรียงเอกสารจากมากไปน้อย โดยใช้ ฟิลด์ id
    final snapshots = reference.snapshots();
    //QuerySnapshot<Map<String, dynamic>> snapshot
    //QuerySnapshot<Object?> snapshot
    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return CarsModel.fromMap(doc.data());
      }).toList();
    });
  }
  Stream<List<UsersModel>> getGetJob() {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    final reference = FirebaseFirestore.instance.collection('cars').doc('${_user?.uid}').collection('getjob');
    //เรียงเอกสารจากมากไปน้อย โดยใช้ ฟิลด์ id
    final snapshots = reference.snapshots();
    //QuerySnapshot<Map<String, dynamic>> snapshot
    //QuerySnapshot<Object?> snapshot
    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return UsersModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> deleteUsersPublic({UsersModel? users}) async {
    
    final reference = FirebaseFirestore.instance
        .collection('userspublic')
        .doc('${users?.id}');
    // final reference = FirebaseFirestore.instance.doc('Order/${order?.id}');
    try {
      await reference.delete();
      print('ลบ user public เรียบร้อย');
    } catch (err) {
      print('ลบ userspublic ไม่ได้');
      rethrow;
    }
  }
  Future<void> deleteGetJob({UsersModel? users}) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    final reference = FirebaseFirestore.instance
        .collection('cars')
        .doc('${_user?.uid}').collection('getjob').doc('${users?.id}');
    // final reference = FirebaseFirestore.instance.doc('Order/${order?.id}');
    try {
      await reference.delete();
      print('ลบ getjob เรียบร้อย');
    } catch (err) {
      print('ลบ getjob ไม่ได้');
      rethrow;
    }
  }
  Future<void> deleteJobHistory({UsersModel? users}) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? _user;
    _user = _auth.currentUser;
    
    final reference = FirebaseFirestore.instance
        .collection('cars')
        .doc('${_user?.uid}').collection('jobhistory').doc('${users?.id}');
    // final reference = FirebaseFirestore.instance.doc('Order/${order?.id}');
    try {
      await reference.delete();
      print('ลบ jobhistory เรียบร้อย');
    } catch (err) {
      print('ลบ jobhistory ไม่ได้');
      rethrow;
    }
  }
}
