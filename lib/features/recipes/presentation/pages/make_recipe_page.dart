import 'package:flutter/material.dart';

class BuatResepPage extends StatefulWidget {
  const BuatResepPage({super.key});

  @override
  State<BuatResepPage> createState() => _BuatResepPageState();
}

class _BuatResepPageState extends State<BuatResepPage> {
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _waktuController = TextEditingController();

  int porsi = 1;
  String visibility = "Public";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5A1F),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Buat Resep",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Nama resep"),
            _textField(
              controller: _namaController,
              hint: "Maksimal 50 karakter",
              maxLength: 50,
            ),

            const SizedBox(height: 16),

            _label("Deskripsi"),
            _textField(
              controller: _deskripsiController,
              hint: "Maksimal 250 karakter",
              maxLength: 250,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            _label("Gambar"),
            _uploadBox(),

            const SizedBox(height: 6),
            const Text(
              "*Maksimal 50 MB Format: JPG, PNG\nOpsional",
              style: TextStyle(fontSize: 12, color: Colors.brown),
            ),

            const SizedBox(height: 16),

            _label("Public"),
            _dropdown(),

            const SizedBox(height: 16),

            _label("Perkiraan waktu (menit)"),
            _waktuField(),

            const SizedBox(height: 16),

            _label("Porsi"),
            _porsiCounter(),

            const SizedBox(height: 80),
          ],
        ),
      ),

      /// NEXT BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3F5242),
        onPressed: () {
          debugPrint("Next ditekan");
        },
        label: const Text("Next"),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }

  /// =========================
  /// WIDGET KECILAN
  /// =========================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6A2C1D),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6A2C1D)),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hint,
          counterText: "",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _uploadBox() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      width: 150,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6A2C1D)),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          debugPrint("Upload gambar");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined, size: 32),
            SizedBox(height: 6),
            Text(
              "Upload Gambar",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6A2C1D)),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: visibility,
          items: const [
            DropdownMenuItem(value: "Public", child: Text("Public")),
            DropdownMenuItem(value: "Private", child: Text("Private")),
          ],
          onChanged: (value) {
            setState(() {
              visibility = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _waktuField() {
    return Row(
      children: [
        Expanded(
          child: _textField(
            controller: _waktuController,
            hint: "mnt",
          ),
        ),
      ],
    );
  }

  Widget _porsiCounter() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (porsi > 1) {
              setState(() => porsi--);
            }
          },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          "$porsi",
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          onPressed: () {
            setState(() => porsi++);
          },
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
