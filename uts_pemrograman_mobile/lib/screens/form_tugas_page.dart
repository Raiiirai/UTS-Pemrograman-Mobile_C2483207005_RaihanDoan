import 'package:flutter/material.dart';
import 'package:uts_pemrograman_mobile/model/tugas.dart';

class FormTugasPage extends StatefulWidget {
  final Tugas? tugas;

  const FormTugasPage({super.key, this.tugas});

  @override
  State<FormTugasPage> createState() => _FormTugasPageState();
}

class _FormTugasPageState extends State<FormTugasPage> {
  final _formKey = GlobalKey<FormState>();

  final _judulController = TextEditingController();
  final _mataKuliahController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tenggatController = TextEditingController();

  String? _prioritas;
  bool _selesai = false;

  // Menentukan apakah form digunakan untuk edit
  bool get _modeEdit => widget.tugas != null;

  @override
  void initState() {
    super.initState();

    // Mengisi form dengan data lama jika sedang edit
    if (_modeEdit) {
      _judulController.text = widget.tugas!.judul;
      _mataKuliahController.text = widget.tugas!.mataKuliah;
      _deskripsiController.text = widget.tugas!.deskripsi;
      _tenggatController.text = widget.tugas!.tenggat;

      _prioritas = widget.tugas!.prioritas;
      _selesai = widget.tugas!.selesai;
    }
  }

  // Validasi tanggal DD-MM-YYYY
  bool _validasiTanggal(String tanggal) {
    final pola = RegExp(r'^\d{2}-\d{2}-\d{4}$');

    if (!pola.hasMatch(tanggal)) {
      return false;
    }

    final bagian = tanggal.split('-');

    final hari = int.parse(bagian[0]);
    final bulan = int.parse(bagian[1]);
    final tahun = int.parse(bagian[2]);

    if (tahun < 1) {
      return false;
    }

    final tanggalInput = DateTime(tahun, bulan, hari);

    return tanggalInput.day == hari &&
        tanggalInput.month == bulan &&
        tanggalInput.year == tahun;
  }

  // Membersihkan controller
  @override
  void dispose() {
    _judulController.dispose();
    _mataKuliahController.dispose();
    _deskripsiController.dispose();
    _tenggatController.dispose();

    super.dispose();
  }

  // Menyimpan hasil tambah atau edit
  void _simpanTugas() {
    if (_formKey.currentState!.validate()) {
      final tugasHasil = Tugas(
        id:
            widget.tugas?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),

        judul: _judulController.text.trim(),
        mataKuliah: _mataKuliahController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        tenggat: _tenggatController.text.trim(),
        prioritas: _prioritas!,
        selesai: _selesai,
      );

      Navigator.pop(context, tugasHasil);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modeEdit ? 'Edit Tugas' : 'Tambah Tugas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul tugas
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  hintText: 'Masukkan judul tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tugas wajib diisi';
                  }

                  if (value.trim().length < 3) {
                    return 'Judul minimal 3 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Mata kuliah
              TextFormField(
                controller: _mataKuliahController,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  hintText: 'Masukkan nama mata kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mata kuliah wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Deskripsi
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi tugas',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }

                  if (value.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Tenggat
              TextFormField(
                controller: _tenggatController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Tenggat Tugas',
                  hintText: 'DD-MM-YYYY',
                  helperText: 'Contoh: 25-11-2026',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal tenggat wajib diisi';
                  }

                  if (!_validasiTanggal(value.trim())) {
                    return 'Tanggal tidak valid. Gunakan DD-MM-YYYY';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Prioritas
              DropdownButtonFormField<String>(
                value: _prioritas,
                decoration: const InputDecoration(
                  labelText: 'Prioritas',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Rendah', child: Text('Rendah')),
                  DropdownMenuItem(value: 'Sedang', child: Text('Sedang')),
                  DropdownMenuItem(value: 'Tinggi', child: Text('Tinggi')),
                ],
                onChanged: (value) {
                  setState(() {
                    _prioritas = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih prioritas';
                  }

                  return null;
                },
              ),

              // Status hanya tersedia saat edit
              if (_modeEdit) ...[
                const SizedBox(height: 12),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tugas sudah selesai'),
                  value: _selesai,
                  onChanged: (value) {
                    setState(() {
                      _selesai = value ?? false;
                    });
                  },
                ),
              ],

              const SizedBox(height: 24),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanTugas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(_modeEdit ? 'Simpan Perubahan' : 'Simpan Tugas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
