import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/features/users/presentation/provider/profile_provider.dart';
import 'package:ratatouille/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchUserDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Warna tema sesuai gambar
    const Color creamColor = Color(0xFFFFFDDE);
    const Color orangeColor = Color(0xFFF3551E);
    const Color orangeDarker = Color(0xFFFF6B35);
    const Color brownText = Color(0xFF5E2A25);

    return Scaffold(
      backgroundColor: creamColor,
      body: SafeArea(
        top: false,
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            if (profileProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (profileProvider.errorMessage != null) {
              return Center(
                child: Text('Error: ${profileProvider.errorMessage}'),
              );
            }

            final userDetail = profileProvider.detail;
            if (userDetail == null) {
              return const Center(child: Text('No user data'));
            }

            final user = userDetail.user;
            final coverPictureUrl = user.coverPictureUrl;
            final profilePictureUrl = user.profilePictureUrl;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ================= HEADER & PROFILE PIC =================
                  Stack(
                    alignment: Alignment.bottomLeft,
                    clipBehavior: Clip.none,
                    children: [
                      // 1. Cover Background Oranye
                      Container(
                        width: double.infinity,
                        height: 220,
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
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                  "assets/images/default_cover_picture.png",
                                  fit: BoxFit.cover,
                                ),
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
                        bottom: -60,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: creamColor,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(3),
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

                  const SizedBox(height: 70),

                  // ================= INFO USER =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama User
                        Text(
                          user.name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'Serif',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: brownText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Bio
                        Text(
                          user.bio ?? "Belum ada bio.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            color: brownText.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Statistik (Pengikut / Mengikuti)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildStatItem(
                              "Pengikut",
                              userDetail.followersCount.toString(),
                              brownText,
                            ),
                            const SizedBox(width: 40),
                            _buildStatItem(
                              "Mengikuti",
                              userDetail.followingCount.toString(),
                              brownText,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Tombol Edit Profile atau Follow
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              if (userDetail.isMe == true) {
                                context.push(AppRoutes.editProfile);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orangeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              userDetail.isMe == true ? "Edit Profile" : "Follow",
                              style: const TextStyle(
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
                        const Text(
                          "Resep",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: brownText,
                          ),
                        ),
                        Text(
                          "${userDetail.recipes.length}",
                          style: const TextStyle(
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
                  if (userDetail.recipes.isNotEmpty)
                    ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userDetail.recipes.length > 2 ? 2 : userDetail.recipes.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final recipe = userDetail.recipes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: RecipeCard(
                            imageUrl: recipe.recipe.images.firstOrNull?.url,
                            title: recipe.recipe.name,
                            subtitle: recipe.recipe.isPublic ? "Publik" : "Privat",
                            rating: recipe.rating.average,
                            date: recipe.recipe.updatedAt,
                            totalReviews: recipe.rating.count,
                            onTap: () {
                              context.push(
                                "${AppRoutes.recipeDetail}/${recipe.recipe.id}",
                              );
                            },
                          ),
                        );
                      },
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Belum ada resep",
                        style: TextStyle(
                          fontSize: 14,
                          color: brownText.withOpacity(0.6),
                        ),
                      ),
                    ),

                  // Tombol Lihat Resep Lainnya
                  if (userDetail.recipes.length > 2)
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(AppRoutes.myRecipe);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: orangeColor,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Lihat resep lainnya",
                          style: TextStyle(
                            color: orangeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),
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
}