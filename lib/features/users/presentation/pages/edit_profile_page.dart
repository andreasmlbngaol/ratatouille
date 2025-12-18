import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller untuk menangani input teks
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // Mengambil data awal dari Provider (jika ada) atau string kosong
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: authProvider.user?.name ?? "");
    _bioController = TextEditingController(text: authProvider.user?.bio ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna (Sama dengan referensi)
    const Color creamColor = Color(0xFFFFFDDE);
    const Color orangeColor = Color(0xFFF3551E);
    const Color orangeDarker = Color(0xFFFF6B35);
    const Color brownText = Color(0xFF5E2A25);

    // Mengakses data user untuk foto
    final user = Provider.of<AuthProvider>(context).user;
    final profilePictureUrl = user?.profilePictureUrl;
    final coverPictureUrl = user?.coverPictureUrl;

    return Scaffold(
      backgroundColor: creamColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER & AVATAR =================
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // 1. Cover Background Oranye
                Container(
                  width: double.infinity,
                  height: 220, // Tinggi header oranye
                  decoration: const BoxDecoration(
                    color: orangeColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: coverPictureUrl != null
                        ? CachedNetworkImage(
                            imageUrl: coverPictureUrl.startsWith("https")
                                ? coverPictureUrl
                                : "${AppConstant.baseUrl}$coverPictureUrl",
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/default_cover_picture.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                // Tombol Back di Kiri Atas
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                  ),
                ),

                // Tombol Edit Cover (Pojok Kanan Bawah Background Oranye)
                Positioned(
                  bottom: 15, // Jarak dari bawah container header (220) relative
                  right: 20,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: creamColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(7),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: orangeColor,
                    ),
                    // Jika ingin menggunakan SVG, uncomment kode di bawah ini dan pastikan aset ada
                    // child: SvgPicture.asset(
                    //   "assets/icons/edit.svg",
                    //   width: 20,
                    //   height: 20,
                    //   colorFilter: const ColorFilter.mode(orangeColor, BlendMode.srcIn),
                    // ),
                  ),
                ),

                // 2. Foto Profil dengan Badge Edit
                Positioned(
                  bottom: -60, // Menarik foto ke bawah batas header
                  left: 20, // Posisikan di kiri dengan margin 20
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Lingkaran Foto
                      Container(
                        padding: const EdgeInsets.all(5), // Border Cream tebal
                        decoration: const BoxDecoration(
                          color: creamColor,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(3), // Border Oranye tipis
                          decoration: const BoxDecoration(
                            color: orangeDarker,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: profilePictureUrl != null
                                ? CachedNetworkImageProvider(
                                    profilePictureUrl.startsWith("https")
                                        ? profilePictureUrl
                                        : "${AppConstant.baseUrl}$profilePictureUrl",
                                  )
                                : const AssetImage("assets/images/default_profile_picture.png")
                                    as ImageProvider,
                          ),
                        ),
                      ),

                      // Ikon Pensil Kecil
                      Container(
                        margin: const EdgeInsets.only(right: 5, bottom: 5),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: creamColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              )
                            ]),
                        child: const Icon(Icons.edit, size: 16, color: orangeColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60), // Spasi kompensasi avatar

            // ================= FORM SECTION =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Halaman
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: brownText,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Input Nama
                  _buildLabel("Nama", brownText),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: _nameController, brownText: brownText),

                  const SizedBox(height: 20),

                  // Input Bio
                  _buildLabel("Bio", brownText),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _bioController,
                    brownText: brownText,
                    maxLines: 5, // Input bio lebih tinggi
                  ),

                  const SizedBox(height: 40),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Tambahkan logika simpan ke provider/API di sini
                        print("Simpan: ${_nameController.text}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hiasan Bawah (Opsional - jika punya aset SVG alat masak)
            const SizedBox(height: 40),
            Opacity(
              opacity: 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ganti dengan Image.asset atau SvgPicture.asset Anda jika ada
                  Icon(Icons.soup_kitchen,
                      size: 80, color: orangeColor.withOpacity(0.3)),
                  Icon(Icons.kitchen, size: 80, color: orangeColor.withOpacity(0.3)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Label
  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  // Widget Helper untuk TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required Color brownText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brownText, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 5,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: brownText, fontSize: 16),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
