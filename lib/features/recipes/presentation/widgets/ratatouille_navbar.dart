import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';

class RatatouilleNavbar extends StatelessWidget {
  const RatatouilleNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState
        .of(context)
        .matchedLocation;

    int selectedIndex = 0;
    if (location.contains(AppRoutes.favorite)) {
      selectedIndex = 1;
    } else if (location.contains(AppRoutes.myRecipe)) {
      selectedIndex = 2;
    } else if (location.contains(AppRoutes.profile)) {
      selectedIndex = 3;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Color(0xFFF3551E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFEF1BE),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                _NavItem(
                  index: 0,
                  isSelected: selectedIndex == 0,
                  assetName: "assets/icons/home_filled.svg",
                  label: 'Beranda',
                  onTap: () => context.go(AppRoutes.home),
                ),
                _NavItem(
                  index: 1,
                  isSelected: selectedIndex == 1,
                  assetName: "assets/icons/favorite.svg",
                  label: 'Favorit',
                  onTap: () => context.go(AppRoutes.favorite),
                ),
                _NavItem(
                  index: 2,
                  isSelected: selectedIndex == 2,
                  assetName: "assets/icons/my_recipe.svg",
                  label: 'Resepku',
                  onTap: () => context.go(AppRoutes.myRecipe),
                ),
                _NavItem(
                  index: 3,
                  isSelected: selectedIndex == 3,
                  assetName: "assets/icons/profile.svg",
                  label: 'Profil',
                  onTap: () => context.go(AppRoutes.profile),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final String assetName;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.isSelected,
    required this.assetName,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFF3551E) : Colors.transparent,
            borderRadius: isSelected
                ? BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            )
                : BorderRadius.zero,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                assetName,
                width: 34,
                height: 34,
                colorFilter: ColorFilter.mode(
                  isSelected ? Color(0xFFFEF1BE) : Color(0xFFF3551E),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Color(0xFFFEF1BE) : Color(0xFFF3551E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}