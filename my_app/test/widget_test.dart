// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
// (คอมเมนต์เดิมจาก Flutter template: อธิบายว่าไฟล์นี้คือ test พื้นฐาน ใช้ WidgetTester จำลองการแตะ/สกรอลล์ และตรวจสอบค่าของ widget)

import 'package:flutter/material.dart'; // นำเข้าไลบรารี Material Design (จำเป็นเพราะอ้างถึง Icons.add ด้านล่าง)
import 'package:flutter_test/flutter_test.dart'; // นำเข้าเครื่องมือสำหรับเขียน unit test/widget test ของ Flutter (testWidgets, expect, find)

import 'package:my_app/main.dart'; // นำเข้าไฟล์ main.dart ของแอปจริง เพื่อดึง class MyApp มาทดสอบ

void main() { // จุดเริ่มต้นของไฟล์ test (Dart test runner จะเรียกฟังก์ชันนี้)
  testWidgets('Counter increments smoke test', (WidgetTester tester) async { // ประกาศ test case ชื่อ "Counter increments smoke test" รับ tester เป็นเครื่องมือควบคุม widget
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // สร้าง widget tree ของ MyApp ขึ้นมาจริงๆ ในสภาพแวดล้อมทดสอบ แล้ว render เฟรมแรก

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget); // ตรวจสอบว่ามี widget ข้อความ "0" อยู่บนหน้าจอ 1 ตัว (ค่าเริ่มต้นของ counter)
    expect(find.text('1'), findsNothing); // ตรวจสอบว่ายังไม่มีข้อความ "1" อยู่บนหน้าจอเลย

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add)); // จำลองการแตะที่ widget ซึ่งมีไอคอนเครื่องหมายบวก (ปุ่ม FloatingActionButton)
    await tester.pump(); // สั่งให้ Flutter rebuild หน้าจอใหม่หลังจากมีการเปลี่ยนแปลง state (คล้าย setState)

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing); // ตรวจสอบว่าข้อความ "0" หายไปแล้ว (เพราะค่าถูกเพิ่มแล้ว)
    expect(find.text('1'), findsOneWidget); // ตรวจสอบว่ามีข้อความ "1" ปรากฏขึ้นมาแทน 1 ตัว
  });
}