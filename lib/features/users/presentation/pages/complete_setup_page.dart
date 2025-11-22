import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';

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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Atur Profil',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF5E2A25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ===== Profile Picture Section =====
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE8845C),
                            width: 3,
                          ),
                          color: Colors.grey[200],
                        ),
                        child: authProvider.user?.profilePictureUrl != null
                            ? CachedNetworkImage(
                          imageUrl: AppConstant.baseUrl + authProvider.user!.profilePictureUrl!,
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.person, size: 80),
                        )
                            : Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                      ),
                      GestureDetector(
                        onTap: _isUploadingImage ? null : _pickAndUploadImage,
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
                  Text(
                    'Nama',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5E2A25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
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
                      onPressed: authProvider.isLoading ? null : _updateName,
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
          );
        },
      ),
    );
  }
}