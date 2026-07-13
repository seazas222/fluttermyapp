import 'package:flutter/material.dart'; // ไลบรารี UI หลักของ Flutter

import 'dart:convert'; // สำหรับแปลงข้อมูลเป็น/จาก JSON (jsonEncode, jsonDecode) และ utf8
import 'package:crypto/crypto.dart'; // ไลบรารีเข้ารหัส ใช้ทำ sha256
import 'package:http/http.dart' as http; // ไลบรารีสำหรับยิง HTTP request ตั้งชื่อย่อว่า http

import 'package:my_app/config/app_config.dart'; // นำเข้าไฟล์ config เพื่อดึงค่า apiBaseUrl
import 'package:my_app/untils/date_util.dart'; // นำเข้า utility จัดรูปแบบวันที่
import 'package:shared_preferences/shared_preferences.dart'; // ไลบรารีเก็บข้อมูลแบบ key-value ลงเครื่อง (ใช้เก็บ token)


class LoginScreen extends StatefulWidget { // widget หน้า Login แบบมี state
  const LoginScreen({super.key}); // constructor
  State<LoginScreen> createState() => _LoginScreenState(); // สร้าง State object ของหน้านี้ (ขาด @override แต่ยังทำงานได้)
  
}



class _LoginScreenState extends State<LoginScreen> { // คลาสเก็บ state จริงของหน้า Login
  final _formKey = GlobalKey<FormState>(); // key ไว้อ้างอิงถึง Form widget เพื่อเรียก validate()

  final _usernameValueController = TextEditingController(); // ตัวควบคุมข้อความในช่อง username
  final _passwordValueController = TextEditingController(); // ตัวควบคุมข้อความในช่อง password

  Future<(bool, String, String)> _authenRequest() async { // ฟังก์ชัน async ขอ "authen token" จาก backend คืนค่าเป็น record (isError, data, errorMessage)
  String username = _usernameValueController.text; // ดึงข้อความ username ที่ผู้ใช้กรอก
  DateTime now = DateTime.now(); // เอาเวลาปัจจุบัน
  String formattedDateString = DateUtil.getFormattedDate(now); // แปลงเวลาปัจจุบันเป็น string รูปแบบ dd-MM-yyyy

  String combinedString = "$username&$formattedDateString"; // รวม username กับวันที่ คั่นด้วย & เพื่อเตรียม hash
  print(combinedString); // แสดงค่าที่รวมแล้วออกทาง console (สำหรับ debug)

  String authenRequestString = sha256 // เริ่มคำนวณ hash sha256
      .convert(utf8.encode(combinedString)) // แปลง string เป็น bytes (utf8) แล้ว hash ด้วย sha256
      .toString(); // แปลงผลลัพธ์ hash เป็น string hex
  print("authenRequestString: $authenRequestString"); // แสดงค่า hash ออกทาง console (debug)
  final response = await http.post( // ยิง HTTP POST ไปที่ backend และรอผลลัพธ์
    Uri.parse("${Appconfig.apiBaseUrl}/authen/authen_request"), // URL ปลายทาง: base url + /authen/authen_request
    headers: <String, String>{ // กำหนด header ของ request
      'Content-Type': 'application/json; charset=UTF-8', // บอกว่าเนื้อหาที่ส่งเป็น JSON
    },
    body: jsonEncode(<String, String>{'authen_request':authenRequestString}), // เนื้อหา body เป็น JSON ที่มี key authen_request
  );

  final json = jsonDecode(response.body); // แปลง response ที่ได้ (string JSON) กลับเป็น object Dart (Map)

  print(json); // แสดงผลลัพธ์ที่ได้จาก server (debug)

  return ( // คืนค่ากลับเป็น record 3 ค่า
    json["isError"] as bool, // แปลงค่า isError ใน JSON เป็น bool
    json["data"] as String, // แปลงค่า data (authen token) เป็น String
    json["errorMessage"] as String, // แปลงค่า errorMessage เป็น String
  );
  
}

Future<({bool isError, String data , String errorMessage})>_accessRequest( // ฟังก์ชัน async ขอ access token โดยใช้ authen token ที่ได้มาก่อนหน้า คืนค่าเป็น record ที่มีชื่อ field
  String authenToken, // พารามิเตอร์รับ authen token เข้ามา
  
) async {
  String username = _usernameValueController.text; // ดึงชื่อผู้ใช้ที่กรอก
  String password = _passwordValueController.text; // ดึงรหัสผ่านที่กรอก
  String passwordEncode = sha256.convert(utf8.encode(password)).toString(); // เข้ารหัสรหัสผ่านด้วย sha256 ก่อนส่ง (ไม่ส่ง plaintext)
  String combinedString = "$username&$passwordEncode&$authenToken"; // รวม username + รหัสผ่านที่เข้ารหัสแล้ว + authen token
  String authenSignature = sha256.convert(utf8.encode(combinedString)).toString(); // hash ค่าที่รวมกันอีกครั้งเป็น "ลายเซ็น" สำหรับยืนยันตัวตน

  print(combinedString); // debug
  print(authenSignature); // debug
  
 

  final response = await http.post( // ยิง POST request ไปที่ backend
    Uri.parse("${Appconfig.apiBaseUrl}/authen/access_request"), // URL: base url + /authen/access_request
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', // บอกว่าส่งข้อมูลแบบ JSON
    },
    body: jsonEncode(<String, String>{
      'authen_signature': authenSignature, // ส่งลายเซ็นที่คำนวณไว้
      'authen_token': authenToken // ส่ง authen token กลับไปด้วย
      
    }),
  );

  final json = jsonDecode(response.body); // แปลง response กลับเป็น object
  print(json); // debug

  if(!json["isError"]) { // ถ้าไม่มี error (login สำเร็จ)
    SharedPreferences prefs = await SharedPreferences.getInstance(); // เปิดใช้งานพื้นที่เก็บข้อมูลในเครื่อง
    await prefs.setString("access_token", json["data"]["access_token"]); // บันทึก access_token ลงเครื่อง
    await prefs.setString("username",_usernameValueController.text); // บันทึก username ลงเครื่อง
    await prefs.setString("image_url", json["data"]["image_url"]); // บันทึก url รูปโปรไฟล์ลงเครื่อง
    
  }

  return ( // คืนค่ากลับเป็น record ที่มีชื่อ field
    isError: json["isError"] as bool, // สถานะ error
    data: json["data"]["access_token"] as String, // ค่า access token
    errorMessage: json["errorMessage"] as String, // ข้อความ error (ถ้ามี)
  );
  
}
void _doLogin (BuildContext context) async{ // ฟังก์ชันหลักที่ถูกเรียกเมื่อกดปุ่ม Login
  var (isError , authenToken, errorMessage) = await _authenRequest(); // ขั้นที่ 1: ขอ authen token ก่อน แล้วแตกค่าจาก record
  print("authenToken: $authenToken"); // debug แสดง authen token ที่ได้

  if(isError) { // ถ้าขั้นตอนขอ authen token ผิดพลาด
    showDialog( // แสดง dialog แจ้งเตือน
      context:context, // บริบทปัจจุบันของหน้าจอ
      builder: (context) { // ฟังก์ชันสร้าง widget ของ dialog
        return AlertDialog(content: Text(errorMessage)); // แสดงข้อความ error ใน AlertDialog
      },
        );    
  }else{ // ถ้าขอ authen token สำเร็จ
    var result = await _accessRequest(authenToken); // ขั้นที่ 2: ขอ access token โดยใช้ authen token ที่ได้

    print("access_token: ${result.data}"); // debug แสดง access token
    if(result.isError) { // ถ้าขอ access token ผิดพลาด
      //TO DO // *** ยังไม่ได้เขียนโค้ดจัดการ error ตรงนี้ (ค้าง TODO ไว้) ***
  }else{ // ถ้าไม่มี error (แต่โค้ดส่วนนี้เขียนสลับ logic ผิด — ดูหมายเหตุด้านล่าง)
    showDialog(
      context:context,
      builder: (context) {
        return AlertDialog(content: Text(result.errorMessage)); // แสดง errorMessage แม้ว่าจะเข้าเงื่อนไข "ไม่ error" ก็ตาม (bug)
      },
    );
  }
  }
}


  @override
  Widget build(BuildContext context) { // เมธอดสร้าง UI ของหน้า Login

     print("BUILD LOGIN SCREEN"); // debug แสดงว่าหน้านี้ถูก build
    return Scaffold( // โครงหน้าจอหลัก
      body: Container( // กล่อง container เต็มพื้นที่
        height: double.infinity, // สูงเต็มจอ
        width: double.infinity, // กว้างเต็มจอ
        decoration: BoxDecoration( // ตกแต่งพื้นหลัง
          image: DecorationImage( // ใช้รูปภาพเป็นพื้นหลัง
            image: AssetImage("assets/bg1.jpeg"), // โหลดรูปจาก assets ชื่อ bg1.jpeg
            fit: BoxFit.fill, // ยืดรูปให้เต็มพื้นที่ container
          ),
        ),
        alignment: Alignment.center, // จัดตำแหน่ง child ให้อยู่กึ่งกลาง
        child: Container( // กล่องด้านในสำหรับฟอร์ม login
          height: 400, // ความสูงคงที่ 400 pixel
          width: double.infinity, // กว้างเต็มพื้นที่ที่มี (แต่ถูกจำกัดด้วย margin ด้านล่าง)
          margin: const EdgeInsets.symmetric(horizontal: 30), // เว้นระยะซ้าย-ขวา 30 pixel
          decoration: BoxDecoration( // ตกแต่งกล่องฟอร์ม
            border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)), // ขอบสีขาว
            borderRadius: BorderRadius.circular(15), // มุมโค้งมน 15 pixel
            color: Colors.black.withValues(alpha: 0.1), // พื้นหลังสีดำโปร่งใส 10% (เอฟเฟกต์กระจกฝ้า)
          ),
          alignment: Alignment.center, // จัดตำแหน่ง child กึ่งกลาง
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // เว้นระยะขอบในกล่อง 10 pixel ทุกด้าน
          child: Form( // widget ฟอร์มที่รองรับการ validate
            key: _formKey, // ผูก key เพื่อเรียก validate() ได้ภายหลัง
            child: Column( // จัดวาง element ในฟอร์มแนวตั้ง
              children: [
                Container( // กล่องข้อความ "Username"
                  margin: EdgeInsets.only(top: 50), // เว้นระยะด้านบน 50 pixel
                  child: Text("Username"), // ป้ายข้อความ Username
                ),
                Container( // กล่องช่องกรอก username
                  padding: EdgeInsets.symmetric(horizontal: 30), // เว้นระยะซ้าย-ขวา 30 pixel
                  child: TextFormField( // ช่องกรอกข้อความที่ validate ได้
                    controller: _usernameValueController, // ผูกกับตัวควบคุมที่ประกาศไว้ด้านบน
                    validator: (value) { // ฟังก์ชันตรวจสอบความถูกต้องของค่าที่กรอก
                      if (value == null || value.isEmpty) { // ถ้าไม่ได้กรอกอะไรเลย
                        return 'กรุณากรอก Username'; // แสดงข้อความแจ้งเตือน
                      }
                      return null; // ถ้าผ่าน validate คืนค่า null (ไม่มี error)
                    },
                  ),
                ),
                Container( // กล่องข้อความ "Password"
                  margin: EdgeInsets.only(top: 50), // เว้นระยะด้านบน 50 pixel
                  child: Text("Password"), // ป้ายข้อความ Password
                ),
                Container( // กล่องช่องกรอก password
                  padding: EdgeInsets.symmetric(horizontal: 30), // เว้นระยะซ้าย-ขวา 30 pixel
                  child: TextFormField( // ช่องกรอกข้อความ
                    obscureText: true, // ซ่อนตัวอักษรที่พิมพ์ (สำหรับรหัสผ่าน)
                    controller: _passwordValueController, // ผูกกับตัวควบคุม password
                    validator: (value) { // ตรวจสอบความถูกต้อง
                      if (value == null || value.isEmpty) { // ถ้าไม่ได้กรอก
                        return 'กรุณากรอก Password'; // แจ้งเตือน
                      }
                      return null; // ผ่าน validate
                    },
                  ),
                ),
                Container( // กล่องปุ่ม Login
                  margin: EdgeInsets.only(top: 40), // เว้นระยะด้านบน 40 pixel
                  child: ElevatedButton( // ปุ่มแบบนูน
                    onPressed: ()  { // เมื่อกดปุ่ม
                      if (_formKey.currentState!.validate()) // ตรวจสอบฟอร์มทั้งหมดว่าผ่านหรือไม่ (! บอกว่ามั่นใจว่าไม่เป็น null)
                        {
                          _doLogin(context); // ถ้าผ่าน validate ให้เรียกฟังก์ชัน login
                        }
                    },
                    child: Text("Login"), // ข้อความบนปุ่ม
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}