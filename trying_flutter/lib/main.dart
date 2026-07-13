import 'package:flutter/material.dart'; // นำเข้าไลบรารี Material Design ของ Flutter (widget ต่างๆ เช่น Scaffold, AppBar)

void main() { // ฟังก์ชันหลัก จุดเริ่มต้นของโปรแกรม Dart
  runApp(const MyApp()); // สั่งให้ Flutter รัน widget MyApp เป็น root ของแอป
}

class MyApp extends StatelessWidget { // ประกาศคลาส MyApp เป็น widget แบบไม่มี state (ไม่เปลี่ยนแปลงข้อมูลภายในตัวเอง)
  const MyApp({super.key}); // constructor รับ key (ใช้ระบุ widget ใน tree) ส่งต่อให้ parent class

  // This widget is the root of your application.
  @override // บอกว่าฟังก์ชันนี้ override มาจาก class แม่ (StatelessWidget)
  Widget build(BuildContext context) { // เมธอดสร้าง UI โดยรับ context (ข้อมูลตำแหน่งใน widget tree)
    return MaterialApp( // คืนค่า widget MaterialApp ซึ่งเป็น wrapper หลักของแอปที่ใช้ธีม Material
      title: 'Flutter Demo', // ชื่อแอป (ใช้แสดงใน task switcher ของ OS)
      theme: ThemeData( // กำหนดธีมสีของแอปทั้งหมด
        colorScheme: .fromSeed(seedColor: Colors.deepPurple), // สร้างชุดสีจากสีตั้งต้น (deepPurple) แบบอัตโนมัติ
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'), // กำหนดหน้าแรกที่จะแสดงเมื่อเปิดแอป พร้อมส่ง title เข้าไป
    );
  }
}

class MyHomePage extends StatefulWidget { // ประกาศคลาส MyHomePage เป็น widget แบบมี state (เปลี่ยนแปลงข้อมูลได้)
  const MyHomePage({super.key, required this.title}); // constructor รับ key และ title (บังคับต้องส่งมา)

  final String title; // ตัวแปรเก็บชื่อหัวข้อ (immutable เพราะ final)

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // สร้าง object State ที่จะดูแลข้อมูลและ UI ของหน้านี้
}

class _MyHomePageState extends State<MyHomePage> { // คลาส State ที่เก็บข้อมูลจริงๆ ของ MyHomePage
  int _counter = 0; // ตัวแปรนับจำนวนครั้งที่กดปุ่ม เริ่มต้นที่ 0

  void _incrementCounter() { // ฟังก์ชันเพิ่มค่า counter เมื่อกดปุ่ม
    setState(() { // เรียก setState เพื่อบอก Flutter ว่าข้อมูลเปลี่ยน ให้ build ใหม่
      _counter++; // เพิ่มค่า counter ขึ้น 1
    });
  }

  @override
  Widget build(BuildContext context) { // เมธอดสร้าง UI ของหน้านี้ (จะถูกเรียกใหม่ทุกครั้งที่ setState ทำงาน)
    return Scaffold( // widget โครงหน้าเว็บ/แอปพื้นฐาน (มี appBar, body, floatingActionButton)
      appBar: AppBar( // แถบด้านบนของหน้าจอ
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // สีพื้นหลังของ AppBar ดึงจากธีม
        title: Text(widget.title), // ข้อความหัวข้อบน AppBar ใช้ค่า title ที่ส่งมาจาก widget
      ),
      body: Center( // เนื้อหาหลักของหน้าจอ จัดกึ่งกลาง
        child: Column( // จัดวาง widget ลูกในแนวตั้ง
          mainAxisAlignment: .center, // จัดตำแหน่งแนวตั้งให้อยู่กึ่งกลาง
          children: [ // รายการ widget ลูกที่จะแสดง
            const Text('You have pushed the button this many times:'), // ข้อความคงที่บอกคำอธิบาย
            Text( // แสดงตัวเลข counter
              '$_counter', // แปลงค่า _counter เป็นข้อความ
              style: Theme.of(context).textTheme.headlineMedium, // ใช้สไตล์ตัวอักษรขนาดใหญ่จากธีม
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton( // ปุ่มลอยมุมขวาล่าง
        onPressed: _incrementCounter, // เมื่อกดปุ่มนี้ ให้เรียกฟังก์ชันเพิ่มค่า counter
        tooltip: 'Increment', // ข้อความ tooltip เวลา hover/กดค้าง
        child: const Icon(Icons.add), // ไอคอนเครื่องหมายบวกบนปุ่ม
      ),
    );
  }
}