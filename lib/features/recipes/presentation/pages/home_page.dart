import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/features/users/presentation/widgets/rounded_bold_outline.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getGreeting() {
    final hour = DateTime
        .now()
        .hour;
    if (hour < 12) {
      return 'Selamat pagi,';
    } else if (hour < 15) {
      return 'Selamat siang,';
    } else if (hour < 18) {
      return 'Selamat sore,';
    } else {
      return 'Selamat malam,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF3551E),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned(
                  right: -20,
                  child: Image.asset(
                    'assets/images/home_background_1.png',
                    width: 204,
                    height: 204,
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFDDE),
                                fontSize: 38
                            ),
                          ),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              return Text(
                                authProvider.user?.name.split(" ").first ?? 'User',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFDDE),
                                    fontSize: 38
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ingin masak apa hari ini?',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                color: Color(0xFFFFFDDE),
                                fontSize: 18
                            ),
                          ),
                          SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              context.push(AppRoutes.searchRecipe);
                            },
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: 'Cari resep...',
                                prefixIcon: Icon(Icons.search),
                                labelStyle: const TextStyle(
                                    color: Color(0xFF5E2A25)),
                                border: roundedBoldOutline(),
                                enabledBorder: roundedBoldOutline(),
                                disabledBorder: roundedBoldOutline(),
                                filled: true,
                                fillColor: Color(0xFFFFFDDE),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ActionButtonRounded(
                                iconName: "user_round_search.svg",
                                label: 'Cari Pengguna',
                                onTap: () {
                                  context.push(AppRoutes.searchUser);
                                },
                              ),
                              _ActionButtonCircle(
                                iconName: "add_recipe.svg",
                                label: 'Buat Resep',
                                onTap: () {
                                  context.push(AppRoutes.createRecipeBaseInfo);
                                },
                              ),
                              _ActionButtonRounded(
                                iconName: "fridge.svg",
                                label: 'Filter Kulkas',
                                onTap: () {
                                  context.push(AppRoutes.fridgeFilter);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFDDE),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(500),
                                  topRight: Radius.circular(500),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(500),
                                    topRight: Radius.circular(500),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFFF3551E),
                                      width: 6,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Image.asset(
                              "assets/images/home_background_2.png",
                              // width: MediaQuery.of(context).size.width
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActionButtonRounded extends StatelessWidget {
  final String iconName;
  final String label;
  final VoidCallback onTap;

  const _ActionButtonRounded({
    required this.iconName,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 93,
            height: 93,
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/$iconName",
                      width: 50,
                      height: 50,
                      colorFilter: ColorFilter.mode(
                        Color(0xFF76342E),
                        BlendMode.srcIn,
                      ),
                    ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB39245),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonCircle extends StatelessWidget {
  final String iconName;
  final String label;
  final VoidCallback onTap;

  const _ActionButtonCircle({
    required this.iconName,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 111,
            height: 111,
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/$iconName",
                      width: 50,
                      height: 50,
                      colorFilter: ColorFilter.mode(
                        Color(0xFF3F5242),
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB39245),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}

