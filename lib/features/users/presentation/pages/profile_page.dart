import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna tema sesuai gambar
    const Color creamColor = Color(0xFFFFFDDE);
    const Color orangeColor = Color(0xFFF3551E);
    const Color orangeDarker = Color(0xFFFF6B35);
    const Color brownText = Color(0xFF5E2A25);

    return Scaffold(
      backgroundColor: creamColor, // Dasar warna Cream
      body: SafeArea(
        top: false, // Agar header oranye mentok ke atas (status bar)
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final user = authProvider.user;
            final coverPictureUrl = user?.coverPictureUrl;
            final profilePictureUrl = user?.profilePictureUrl;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ================= HEADER & PROFILE PIC =================
                  Stack(
                    alignment: Alignment.bottomLeft, // Ubah alignment ke kiri bawah
                    clipBehavior: Clip.none, // Penting agar avatar bisa keluar dari batas container
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

                      // 2. Tombol Settings (Pojok Kanan Atas)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.settings);
                          },
                          child: Container(
                            color: const Color(0xFFFFFDDE).withOpacity(0.2),
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              "assets/icons/settings.svg",
                              height: 28,
                              width: 28,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFFFFDDE),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 3. Foto Profil (Posisi menjorok ke bawah - Overlap)
                      Positioned(
                        bottom: -60, // Menarik foto ke bawah batas header
                        left: 20, // Posisikan di kiri dengan margin 20
                        child: Container(
                          padding: const EdgeInsets.all(4), // Border putih tipis
                          decoration: BoxDecoration(
                            color: creamColor,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(3), // Border oranye
                            decoration: BoxDecoration(
                              color: orangeDarker,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: profilePictureUrl != null
                                  ? CachedNetworkImageProvider(
                                      profilePictureUrl.startsWith("https")
                                          ? profilePictureUrl
                                          : "${AppConstant.baseUrl}$profilePictureUrl",
                                    )
                                  : const AssetImage(
                                          "assets/images/default_profile_picture.png")
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Spacer untuk kompensasi foto profil yang turun (-60 overlap + margin)
                  const SizedBox(height: 70),

                  // ================= INFO USER =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
                      children: [
                        // Nama User
                        Text(
                          user?.name ?? 'Chef Vinsmoke Sanji',
                          textAlign: TextAlign.left, // Rata kiri
                          style: TextStyle(
                            fontFamily: 'Serif', // Sesuaikan font jika ada
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: brownText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Bio
                        Text(
                          user?.bio ?? "Koki kesayangan Nami-Swan & Robin-Cwan",
                          textAlign: TextAlign.left, // Rata kiri
                          style: TextStyle(
                            fontSize: 14,
                            color: brownText.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Statistik (Pengikut / Mengikuti)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, // Rata kiri
                          children: [
                            _buildStatItem("Pengikut", "100", brownText),
                            const SizedBox(width: 40),
                            _buildStatItem("Mengikuti", "1", brownText),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Tombol Edit Profile
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orangeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= SECTION RESEP =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Resep",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: brownText,
                          ),
                        ),
                        Text(
                          "10",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: brownText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),


                  // List Resep
                  ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    physics: const NeverScrollableScrollPhysics(), // Scroll ikut parent
                    shrinkWrap: true,
                    itemCount: 2,
                    separatorBuilder: (c, i) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RecipeCard(
                          imageUrl:
                          "/uploads/images/3y9t1ASFHQR9HzUmhtB27lWWLDV2/recipe-4/1765958994764.webp",
                          title: "Ronaldo Juna",
                          subtitle: "izin",
                          rating: 1.0,
                          date: 123,
                          totalReviews: 1,
                        ),
                      );
                    },
                  ),

                  // Tombol Lihat Resep Lainnya
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: orangeColor, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: Text(
                        "Lihat resep lainnya",
                        style: TextStyle(
                            color: orangeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30), // Bottom padding
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget kecil untuk Angka Statistik
  Widget _buildStatItem(String label, String count, Color color) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: color, fontSize: 15),
        children: [
          TextSpan(text: "$label "),
          TextSpan(
            text: count,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget Card Resep
  Widget _buildRecipeCard(String title, String status, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Gambar Resep (Kiri)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              // Ganti NetworkImage jika ada URL
              "assets/images/food_placeholder.png", // Pastikan ada placeholder
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: Icon(Icons.food_bank)),
            ),
          ),
          const SizedBox(width: 12),
          // Info Resep (Kanan)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                    fontFamily: 'Serif',
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                // Bintang
                Row(
                  children: List.generate(
                      5,
                      (index) => const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20,
                          )),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "23 Oktober 2025",
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    Text(
                      "10 nilai",
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
