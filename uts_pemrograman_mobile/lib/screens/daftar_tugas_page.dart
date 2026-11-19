import 'package:flutter/material.dart';
import 'package:aplikasi_pencatatan_tugas/model/tugas.dart';
import 'package:aplikasi_pencatatan_tugas/screens/form_tugas_page.dart';
import 'package:aplikasi_pencatatan_tugas/screens/detail_tugas_page.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  // Penyimpanan sementara menggunakan List
  final List<Tugas> daftarTugas = [
    Tugas(
      id: '001',
      judul: 'Membuat Laporan Flutter',
      mataKuliah: 'Pemrograman Mobile',
      deskripsi: 'Membuat laporan praktikum aplikasi Flutter.',
      tenggat: '22-11-2026',
      prioritas: 'Tinggi',
    ),

    Tugas(
      id: '002',
      judul: 'Mengerjakan Makalah',
      mataKuliah: 'Etika Profesi',
      deskripsi: 'Menyusun makalah tentang etika teknologi.',
      tenggat: '25-11-2026',
      prioritas: 'Sedang',
    ),

    Tugas(
      id: '003',
      judul: 'Praktikum Jaringan',
      mataKuliah: 'Jaringan Komputer',
      deskripsi: 'Menyelesaikan konfigurasi jaringan komputer.',
      tenggat: '28-11-2026',
      prioritas: 'Rendah',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int totalTugas = daftarTugas.length;

    int tugasSelesai = daftarTugas.where((tugas) => tugas.selesai).length;

    int tugasBelumSelesai = totalTugas - tugasSelesai;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WOI NUGAS!!!'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () async {
          final Tugas? tugasBaru = await Navigator.push<Tugas>(
            context,
            MaterialPageRoute(builder: (context) => const FormTugasPage()),
          );

          if (!mounted) return;

          if (tugasBaru != null) {
            setState(() {
              daftarTugas.add(tugasBaru);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tugas berhasil ditambahkan!')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Ringkasan tugas
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  _buildStat('Total', totalTugas),
                  _buildStat('Selesai', tugasSelesai),
                  _buildStat('Belum Selesai', tugasBelumSelesai),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Daftar Tugas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Daftar tugas
            Expanded(
              child: ListView.builder(
                itemCount: daftarTugas.length,

                itemBuilder: (context, index) {
                  final tugas = daftarTugas[index];

                  return GestureDetector(
                    onTap: () async {
                  // Membuka detail dan menunggu hasil tindakan pengguna
                  final hasil = await Navigator.push<DetailTugasResult>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailTugasPage(
                        tugas: tugas,
                      ),
                    ),
                  );

                  if (!mounted || hasil == null) return;

                  bool berhasil = false;

                  // Mencari tugas berdasarkan ID
                  setState(() {
                    final index = daftarTugas.indexWhere(
                      (item) => item.id == hasil.tugas.id,
                    );

                    if (index == -1) return;

                    if (hasil.action == DetailTugasAction.updated) {

                      // Mengganti data lama dengan data baru
                      daftarTugas[index] = hasil.tugas;

                    } else if (hasil.action == DetailTugasAction.deleted) {

                      // Menghapus satu data berdasarkan ID
                      daftarTugas.removeAt(index);

                    }

                    berhasil = true;
                  });

                  // Memberikan konfirmasi kepada pengguna
                  if (berhasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          hasil.action == DetailTugasAction.updated
                              ? 'Tugas berhasil diperbarui!'
                              : 'Tugas berhasil dihapus!',
                        ),
                      ),
                    );
                  }
                },


                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            tugas.judul,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(tugas.mataKuliah),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text('Tenggat: ${tugas.tenggat}'),

                              Text(
                                tugas.prioritas,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _warnaPrioritas(tugas.prioritas),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            tugas.selesai
                                ? 'Status: Selesai'
                                : 'Status: Belum Selesai',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ringkasan
  Widget _buildStat(String label, int jumlah) {
    return Column(
      children: [
        Text(
          jumlah.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        Text(label),
      ],
    );
  }

  // Warna berdasarkan prioritas
  Color _warnaPrioritas(String prioritas) {
    switch (prioritas) {
      case 'Tinggi':
        return Colors.red;

      case 'Sedang':
        return Colors.orange;

      case 'Rendah':
        return Colors.green;

      default:
        return Colors.black;
    }
  }
}
