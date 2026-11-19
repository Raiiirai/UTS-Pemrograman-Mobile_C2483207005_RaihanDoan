import 'package:flutter/material.dart';
import 'package:uts_pemrograman_mobile/model/tugas.dart';
import 'package:uts_pemrograman_mobile/screens/form_tugas_page.dart';

// Jenis hasil tindakan pada halaman detail
enum DetailTugasAction {
  updated,
  deleted,
}

// Objek untuk mengirim hasil kembali ke daftar
class DetailTugasResult {
  final DetailTugasAction action;
  final Tugas tugas;

  const DetailTugasResult({
    required this.action,
    required this.tugas,
  });
}

class DetailTugasPage extends StatelessWidget {
  final Tugas tugas;

  const DetailTugasPage({
    super.key,
    required this.tugas,
  });

  // Membuka form edit
  Future<void> _ubahTugas(BuildContext context) async {
    final Tugas? hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(
        builder: (context) => FormTugasPage(
          tugas: tugas,
        ),
      ),
    );

    // Jika perubahan berhasil, kirim hasil ke halaman daftar
    if (hasil != null && context.mounted) {
      Navigator.pop(
        context,
        DetailTugasResult(
          action: DetailTugasAction.updated,
          tugas: hasil,
        ),
      );
    }
  }

  // Menampilkan konfirmasi hapus
  Future<void> _konfirmasiHapus(BuildContext context) async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Tugas?'),

          content: Text(
            'Apakah kamu yakin ingin menghapus "${tugas.judul}"?',
          ),

          actions: [

            // Membatalkan penghapusan
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),

            // Mengonfirmasi penghapusan
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),

          ],
        );
      },
    );

    // Jika pengguna memilih Hapus
    if (konfirmasi == true && context.mounted) {
      Navigator.pop(
        context,
        DetailTugasResult(
          action: DetailTugasAction.deleted,
          tugas: tugas,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Judul tugas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Judul Tugas',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    tugas.judul,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildDetail('ID Tugas', tugas.id, Icons.tag),

            _buildDetail(
              'Mata Kuliah',
              tugas.mataKuliah,
              Icons.book,
            ),

            _buildDetail(
              'Deskripsi',
              tugas.deskripsi,
              Icons.description,
            ),

            _buildDetail(
              'Tenggat',
              tugas.tenggat,
              Icons.calendar_today,
            ),

            _buildDetail(
              'Prioritas',
              tugas.prioritas,
              Icons.flag,
            ),

            _buildDetail(
              'Status',
              tugas.selesai ? 'Selesai' : 'Belum Selesai',
              Icons.check_circle,
            ),

            const SizedBox(height: 24),

            // Tombol edit dan hapus
            Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _ubahTugas(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Ubah'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _konfirmasiHapus(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan informasi tugas
  Widget _buildDetail(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: Colors.indigo,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
