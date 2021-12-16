//กำหนด class CarsModel เพื่อใช้เป็น model ในการเชื่อมต่อกับ firebase ใช้กับ การ login เเละสมัครสมาชิก
class UsersModel {
  String? id; //เก็บรหัสสินค้า
  String? userName; //ชื่อ user
  bool? state; //สถานะการรับงาน
  String? images; //ภาพ profile user
  String? location; //ตำแหน่งที่ตั้งของคนขับ
  String? time; //เวลาที่ถึง
  String? phone; //เบอร์โทรศัพท์
  String? email; //อีเมล
  String? address; //ที่อยู่
  UsersModel({
    this.id,
    this.userName,
    this.state,
    this.images,
    this.location,
    this.time,
    this.phone,
    this.email,
    this.address,
  });
  factory UsersModel.fromMap(Map<String, dynamic>? users) {
    String id = users?['id'];
    String userName = users?['userName'];
    bool state = users?['state'];
    String images = users?['images'];
    String location = users?['location'];
    String time = users?['time'];
    String phone = users?['phone'];
    String email = users?['email'];
    String address = users?['address'];
    return UsersModel(
        id: id,
        userName: userName,
        state: state,
        images: images,
        location: location,
        time: time,
        phone: phone,
        email: email,address: address);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'state': state,
      'images': images,
      'location': location,
      'time': time,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
