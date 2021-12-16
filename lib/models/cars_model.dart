//กำหนด class CarsModel เพื่อใช้เป็น model ในการเชื่อมต่อกับ firebase ใช้กับ การ login เเละสมัครสมาชิก
class CarsModel {
  String? id; //เก็บรหัสสินค้า
  String? userName; //ชื่อ user
  bool? state; //สถานะการรับงาน
  bool? statejob; //สถานะการเปิดรับงาน
  String? images; //ภาพ profile user
  String? cartype; //ประเภทรถ
  String? location; //ตำแหน่งที่ตั้งของคนขับ
  String? time; //เวลาที่ถึง
  String? cost; //ค่าบริการ
  String? phone; //เบอร์โทรศัพท์
  String? email; //อีเมล
  CarsModel({
    this.id,
    this.userName,
    this.state,
    this.statejob,
    this.images,
    this.cartype,
    this.location,
    this.time,
    this.cost,
    this.phone,
    this.email,
  });
  factory CarsModel.fromMap(Map<String, dynamic>? users) {
    String id = users?['id'];
    String userName = users?['userName'];
    bool state = users?['state'];
    bool statejob = users?['statejob'];
    String images = users?['images'];
    String cartype = users?['cartype'];
    String location = users?['location'];
    String time = users?['time'];
    String cost = users?['cost'];
    String phone = users?['phone'];
    String email = users?['email'];
    return CarsModel(
        id: id,
        userName: userName,
        state: state,
        statejob: statejob,
        images: images,
        cartype: cartype,
        location: location,
        time: time,
        cost: cost,
        phone: phone,
        email: email);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'state': state,
      'statejob': statejob,
      'images': images,
      'cartype': cartype,
      'location': location,
      'time': time,
      'cost': cost,
      'phone': phone,
      'email': email,
    };
  }
}
