// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
// (คอมเมนต์เดิมของ Flutter template: บอกว่าไฟล์นี้เป็น test พื้นฐาน ใช้ WidgetTester จำลองการแตะ/สกรอลล์และตรวจสอบค่า widget)

import 'package:flutter/material.dart'; // นำเข้าไลบรารี Material Design (จำเป็นเพราะใช้ Icons.add ด้านล่าง)
import 'package:flutter_test/flutter_test.dart'; // นำเข้าเครื่องมือทดสอบของ Flutter (testWidgets, expect, find, WidgetTester)

import 'package:trying_flutter/main.dart'; // นำเข้าไฟล์ main.dart ของโปรเจกต์ "trying_flutter" เพื่อดึง class MyApp มาทดสอบ (คนละโปรเจกต์กับ my_app)

void main() { // จุดเริ่มต้นของไฟล์ test
  testWidgets('Counter increments smoke test', (WidgetTester tester) async { // ประกาศ test case ชื่อนี้ รับ tester เป็นเครื่องมือควบคุม/ตรวจสอบ widget
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // สร้าง widget tree ของ MyApp (ของ trying_flutter) ขึ้นมาจริงในสภาพแวดล้อมทดสอบ แล้ว render เฟรมแรก

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget); // ตรวจสอบว่ามีข้อความ "0" อยู่บนหน้าจอ 1 ตัว (ค่าเริ่มต้นของ counter)
    expect(find.text('1'), findsNothing); // ตรวจสอบว่ายังไม่มีข้อความ "1" ปรากฏเลย

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add)); // จำลองการแตะที่ widget ที่มีไอคอนเครื่องหมายบวก (FloatingActionButton)
    await tester.pump(); // สั่งให้ Flutter rebuild UI ใหม่หลังจาก state เปลี่ยน (เทียบเท่ากับหลัง setState ทำงาน)

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing); // ตรวจสอบว่าข้อความ "0" หายไปแล้ว
    expect(find.text('1'), findsOneWidget); // ตรวจสอบว่ามีข้อความ "1" ปรากฏขึ้นมาแทน 1 ตัว
  });
}