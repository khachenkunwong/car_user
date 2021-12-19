# car_user

เเอปของคนขับรถ

## รายระเอียด

ความหมายของเครื่องหมาย

- :heavy_check_mark: คือ ทำเเล้ว
- :x: คือ ยังไม่ได้ทำเเละจำเป็นต้องทำ
- :warning: คือ ยังไม่ได้ทำและไม่จำเป็นต้องทำตอนนี้

## หน้า

### หน้าล็อกอิน

[![image.png](https://i.postimg.cc/xCGTbr8Q/image.png)](https://postimg.cc/zbB19cT2)

#### Design

- :heavy_check_mark: หน้าล็อกอิน

#### ระบบ

- :heavy_check_mark: ล็อกอิน Google
  - :heavy_check_mark: Authentication ระบบยืนยันตัวต้นว่า gmail นี้มีจริง
  - :heavy_check_mark: Cloud Firestore เก็บข้อมูลผู้ใช้ที่สมัครไว้
- :warning: ล็อกอิน Facebook
  - :warning: Authentication ระบบยืนยันตัวต้นว่า Facebook นี้มีจริง
  - :warning: Cloud Firestore เก็บข้อมูลผู้ใช้ที่สมัครไว้
- :warning: ล็อกอิน Email หรือเเบบพิมพ์ลงไปในชื่อผู้ใช้ และ รหัสผ่าน
  - :warning: Authentication ระบบยืนยันตัวต้นว่า Gmail นี้มีจริง
  - :warning: Cloud Firestore เก็บข้อมูลผู้ใช้ที่สมัครไว้
  - :warning: ลืมรหัสผ่าน
- :heavy_check_mark: เมื่อไม่เลือก บัญชี Gmail ที่จะล็อกอินแล้วกดย้อนกลับ

### หน้าเลือกรับงาน

[![image.png](https://i.postimg.cc/8cS1FmqJ/image.png)](https://postimg.cc/tZB0wWRp)

#### Design

- :heavy_check_mark: หน้าเลือกรับงาน

#### ระบบ

- :heavy_check_mark: แสดงข้อมูลงานทั้งหมด
- :heavy_check_mark: เชื่อมต่อ Cloud Firestore ที่เก็บข้อมูลของงานที่จะรับ
- :heavy_check_mark: เปิดปิดสถาะว่ารับงานหรือไม่รับงานถ้าไม่รับงานก็จะไม่แสดงบนหน้าจอของคนให้งาน
- :heavy_check_mark: ล็อกเอาท์
- :heavy_check_mark: ฟังชันรับงาน
- :heavy_check_mark: ฟังชันขออนุญาติผู้ใช้เปิดตำแหน่ง Location (GPS)
- :warning: ดูรายระเอีดยเพิ่มเติมของคนให้งาน

### หน้ารอกดเริ่มงาน

[![image.png](https://i.postimg.cc/1zFhpN0p/image.png)](https://postimg.cc/TyT4x14w)

#### Design

- :heavy_check_mark: หน้ารอกดเริ่มงาน

#### ระบบ

- :heavy_check_mark: เชื่อมต่อ Cloud Firestore ที่เก็บข้อมูลของงานที่จะรับ
- :heavy_check_mark: แสดงข้อมูลของผู้ให้งาน
- :heavy_check_mark: ฟังชันยกเลิกงาน
- :heavy_check_mark: ฟังชันเริ่มงาน
- :warning: โทรภายในแอป
- :warning: ฟังชันเสร็จงาน

### หน้านำทาง

[![image.png](https://i.postimg.cc/NMbNTgn6/image.png)](https://postimg.cc/1nnc1ZsX)

#### Design

- :heavy_check_mark: หน้านำทาง

#### ระบบ
- :heavy_check_mark: หาตำแหน่งของผู้ใช้ (My location)
- :heavy_check_mark:เชื่อม Google Map
- :heavy_check_mark: แสดง Google Map
- :heavy_check_mark: แสดงตำแหน่งของผู้ใช้ในปัจจุบัน
- :x: นำทาง ลากเส้นระหว่างตำแหน่งคนขับไปหาคนสั้งงาน
- :x: ฟังชันเสร็จงาน

## อัพเดดเวอร์ชันโปรเจค

- v0.7 ที่เก็บข้อมูลของคนเรียนรถและคนขับรถสลับกัน แก้บัคเมื่อคนขับใหม่ลงทะเบียนเเล้วเเอปค้าง แก้บัคการที่เก็บข้อมูล
