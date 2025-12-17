import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_subtitle.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_title.dart';

class CompleteSetupPage extends StatefulWidget {
  const CompleteSetupPage({super.key});

  @override
  State<CompleteSetupPage> createState() => _CompleteSetupPageState();
}

class _CompleteSetupPageState extends State<CompleteSetupPage> {
  late TextEditingController _nameController;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => _isUploadingImage = true);

    try {
      debugPrint('📸 Image selected: ${image.name}');

      // Read bytes immediately saat image masih ada
      final imageBytes = await image.readAsBytes();
      debugPrint('📸 Image bytes read: ${imageBytes.length} bytes');

      // Upload langsung
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.uploadProfilePicture(
        imageBytes,
        image.name,
      );

      if (!context.mounted) return;

      if (success) {
        debugPrint('✅ Image upload success');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diupload')),
        );
      } else {
        debugPrint('❌ Image upload failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Gagal upload foto'),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error uploading image: $e');
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _updateName() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updateName(_nameController.text);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama berhasil diupdate')),
      );
      // Router akan auto-redirect ke home karena user.name tidak lagi empty
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Gagal update nama'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Stack(
            children: [
              /// 🍴 FOOD TOP LEFT
              Positioned(
                top: 24,
                left: -5,
                child: Image.asset(
                  'assets/images/top_left.png',
                  width: 180,
                ),
              ),

              /// 🍴 FOOD TOP RIGHT
              Positioned(
                top: 40,
                right: 10,
                child: Image.asset(
                  'assets/images/top_right.png',
                  width: 120,
                ),
              ),

              /// 🍴 FOOD TOP LEFT
              Positioned(
                top: 24,
                left: -5,
                child: Image.asset(
                  'assets/images/top_left.png',
                  width: 180,
                ),
              ),

              /// 🍴 FOOD TOP RIGHT
              Positioned(
                top: 40,
                right: 10,
                child: Image.asset(
                  'assets/images/top_right.png',
                  width: 120,
                ),
              ),

              /// 🧾 CONTENT
              Center(
                child:SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 2),

                        const RatatouilleTitle(),

                        const SizedBox(height: 6),

                        const RatatouilleSubtitle("Atur Profil"),

                        const SizedBox(height: 32),

                        // ===== Profile Picture Section =====
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE8845C),
                                  width: 3,
                                ),
                                color: Colors.grey[200],
                              ),
                              child: ClipOval(
                                child: authProvider.user?.profilePictureUrl != null &&
                                    authProvider.user!.profilePictureUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                  imageUrl: AppConstant.baseUrl +
                                      authProvider.user!.profilePictureUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                  const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/images/default_profile.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : Image.asset(
                                  'assets/images/default_profile.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: _isUploadingImage
                                  ? null
                                  : _pickAndUploadImage,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFE8845C),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: _isUploadingImage
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                    : const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ===== Name Section =====
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Nama",
                            hintText: 'Masukkan nama Anda',
                            hintStyle: const TextStyle(color: Color(0xFFBBB5B0)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF5E2A25),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF5E2A25),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF3F5242),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(color: Color(0xFF5E2A25)),
                        ),
                        const SizedBox(height: 24),

                        // ===== Submit Button =====
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : _updateName,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F5242),
                              foregroundColor: const Color(0xFFFFFDDE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Color(0xFFFFFDDE),
                                ),
                              ),
                            )
                                : const Text(
                              'Lanjutkan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                )
              ),


              /// 🍴 FOOD BOTTOM LEFT
              Positioned(
                bottom: 50, // ⬅ tepat di atas bg-bottom
                left: 10,
                child: Image.asset(
                  'assets/images/food_pattern_bot.png',
                  width: 200,
                ),
              ),

              /// 🍴 FOOD BOTTOM RIGHT
              Positioned(
                bottom: 50,
                right: -35,
                child: Image.asset(
                  'assets/images/food_pattern.png',
                  width: 200,
                ),
              ),

              /// 🎨 GRADIENT OVERLAY BOTTOM
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFFFF3D00).withOpacity(0.4),
                        const Color(0xFFFFFDDE).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),

              /// 🎨 GRADIENT OVERLAY TOP
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFFF3D00).withOpacity(0.4),
                        const Color(0xFFFFFDDE).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),

              /// 🔶 BACKGROUND TOP
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6A2A),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
              ),

              /// 🔶 BACKGROUND BOTTOM
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6A2A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(0),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}