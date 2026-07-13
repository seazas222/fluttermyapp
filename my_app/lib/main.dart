import 'package:flutter/material.dart'; // นำเข้าไลบรารี Material Design
import 'package:my_app/login_screen.dart'; // นำเข้าไฟล์ login_screen.dart ที่เขียนเอง เพื่อใช้ widget LoginScreen

void main() { // จุดเริ่มต้นโปรแกรม
  runApp(const MyApp()); // รัน widget MyApp เป็น root
}

class MyApp extends StatelessWidget { // widget หลักของแอป ไม่มี state
  const MyApp({super.key}); // constructor

  @override
  Widget build(BuildContext context) { // สร้าง UI ของแอป
    return MaterialApp( // wrapper หลักของแอป
      title: 'Flutter Demo', // ชื่อแอป
      theme: ThemeData( // ธีมสี
        colorScheme: .fromSeed(seedColor: Colors.deepPurple), // สร้างชุดสีจากสีตั้งต้น
      ),
      home: const LoginScreen(), // *** จุดสำคัญ: กำหนดให้หน้าแรกของแอปคือหน้า LoginScreen (ต่างจากไฟล์แรกที่ใช้ MyHomePage) ***
    );
  }
}

// ด้านล่างนี้คือโค้ด MyHomePage ที่เหลือค้างจาก template เดิม แต่ไม่ได้ถูกเรียกใช้งานแล้ว เพราะ home ถูกเปลี่ยนไปเป็น LoginScreen ด้านบน
class MyHomePage extends StatefulWidget { // widget หน้า Home เดิม (ตอนนี้ไม่ได้ใช้)
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { // state ของหน้า Home เดิม (ไม่ได้ใช้แล้ว)
  int _counter = 0; // ตัวนับ
  void _incrementCounter() { // ฟังก์ชันเพิ่มค่า
    setState(() {
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) { // สร้าง UI (ไม่ถูกเรียกเพราะไม่ใช่หน้าแรกแล้ว)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}