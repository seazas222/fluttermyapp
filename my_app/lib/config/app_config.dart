class Appconfig { // คลาสเก็บค่า config ของแอป (ใช้ static เพื่อเรียกใช้ได้โดยไม่ต้องสร้าง instance)
  static const String apiBaseUrl = 'http://localhost:3000/api'; // URL ตั้งต้นของ backend API (ชี้ไปที่ localhost port 3000 — ใช้ตอน dev เท่านั้น)
}