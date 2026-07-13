import 'package:intl/intl.dart'; // นำเข้าไลบรารี intl สำหรับจัดรูปแบบวันที่/เวลา

class DateUtil { // คลาส utility สำหรับจัดการเรื่องวันที่
  static String getFormattedDate(DateTime dt) { // ฟังก์ชัน static รับ DateTime แล้วคืนค่าเป็น String ที่จัดรูปแบบแล้ว
     String formattedDate = DateFormat('dd-MM-yyyy').format(dt); // แปลง DateTime เป็นรูปแบบ วัน-เดือน-ปี (เช่น 13-07-2026)
    return formattedDate; // คืนค่าข้อความวันที่ที่จัดรูปแบบแล้ว
  }
}