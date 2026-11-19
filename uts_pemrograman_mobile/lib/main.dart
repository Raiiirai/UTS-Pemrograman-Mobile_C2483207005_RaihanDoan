import 'package:uts_pemrograman_mobile/screens/daftar_tugas_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppTugas());
}

class AppTugas extends StatelessWidget {
  const AppTugas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pencatatan Tugas',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const DaftarTugasPage(),
    );
  }
}
