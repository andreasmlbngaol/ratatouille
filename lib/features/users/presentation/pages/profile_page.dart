import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF3551E), // Oranye
            Color(0xFFFFFDDE), // Kuning
          ],
          stops: [0.25, 0.25], // 0 = atas, 1 = bawah
        ),
      ),
      child: SafeArea(
          child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final user = authProvider.user;
                final coverPictureUrl = user?.coverPictureUrl;
                final profilePictureUrl = user?.profilePictureUrl;

                return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(32),
                                    bottomRight: Radius.circular(32),
                                  ),
                                  child: Container(
                                    color: Color(0xFFFF6B35),
                                    width: double.infinity,
                                    height: 190,
                                    child: coverPictureUrl == null ?
                                    Image.asset(
                                      "assets/images/default_cover_picture.png",
                                      fit: BoxFit.cover,
                                    )
                                        : CachedNetworkImage(
                                      imageUrl: coverPictureUrl.startsWith(
                                          "https")
                                          ? coverPictureUrl
                                          : "${AppConstant.baseUrl}$coverPictureUrl}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push(AppRoutes.settings);
                                  },
                                  child: ClipOval(
                                    child: Container(
                                      color: Color(0xFFFFFDDE).withValues(alpha: 0.2),
                                      padding: EdgeInsets.all(16),
                                      child: SvgPicture.asset(
                                        "assets/icons/settings.svg",
                                        height: 36,
                                        width: 36,
                                        colorFilter: ColorFilter.mode(
                                          Color(0xFFFFFDDE),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFFFF6B35),
                                      width: 4,
                                    )
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Color(0xFFFF6B35),
                                    child: ClipOval(
                                      child: profilePictureUrl == null ? Image.asset(
                                        "assets/images/default_profile_picture.png",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ) : CachedNetworkImage(
                                        imageUrl: profilePictureUrl.startsWith("https") ? profilePictureUrl : "${AppConstant.baseUrl}$profilePictureUrl",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  user?.name ?? 'User',
                                  style: Theme.of(context).textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFF5E2A25)
                                  )
                                ),
                                Text(
                                  user?.bio ?? "Belum ada bio.",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Color(0xFF5E2A25),
                                    fontSize: 15
                                  )
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Pengikut 100",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Mengikuti 1",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                        ),
                                      ),
                                    )
                                  ]
                                )
                              ],
                            ),
                          )
                        ]
                    )
                );
              }
          )
      ),
    );
  }
}