import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/features/users/presentation/provider/edit_profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  bool _isUploadingProfilePic = false;
  bool _isUploadingCoverPic = false;

  @override
  void initState() {
    super.initState();
    final editProvider = Provider.of<EditProfileProvider>(context, listen: false);
    _nameController = TextEditingController(text: editProvider.user?.name ?? "");
    _bioController = TextEditingController(text: editProvider.user?.bio ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadProfilePicture() async {
    debugPrint("_pickAndUploadProfilePicture");
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => _isUploadingProfilePic = true);

    try {
      final imageBytes = await image.readAsBytes();
      final editProfileProvider = context.read<EditProfileProvider>();

      await editProfileProvider.uploadProfilePicture(
        imageBytes,
        image.name,
      );

      if (!context.mounted) return;

      if (editProfileProvider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diupload')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(editProfileProvider.errorMessage ?? 'Gagal upload foto'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isUploadingProfilePic = false);
    }
  }

  Future<void> _pickAndUploadCoverPicture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => _isUploadingCoverPic = true);

    try {
      final imageBytes = await image.readAsBytes();
      final editProfileProvider = context.read<EditProfileProvider>();

      await editProfileProvider.uploadCoverPicture(
        imageBytes,
        image.name,
      );

      if (!context.mounted) return;

      if (editProfileProvider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cover berhasil diupload')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(editProfileProvider.errorMessage ?? 'Gagal upload cover'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isUploadingCoverPic = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    final editProfileProvider = context.read<EditProfileProvider>();
    await editProfileProvider.updateProfile(
      name: _nameController.text,
      bio: _bioController.text,
    );

    if (!context.mounted) return;

    if (editProfileProvider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diupdate')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(editProfileProvider.errorMessage ?? 'Gagal update profil'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color creamColor = Color(0xFFFFFDDE);
    const Color orangeColor = Color(0xFFF3551E);
    const Color orangeDarker = Color(0xFFFF6B35);
    const Color brownText = Color(0xFF5E2A25);

    return Scaffold(
      backgroundColor: creamColor,
      body: Consumer2<AuthProvider, EditProfileProvider>(
        builder: (context, authProvider, editProfileProvider, _) {
          final user = authProvider.user;
          final profilePictureUrl = user?.profilePictureUrl;
          final coverPictureUrl = user?.coverPictureUrl;

          return SingleChildScrollView(
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

                    // Tombol Back di Kiri Atas
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SafeArea(
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                    // Tombol Edit Cover
                    Positioned(
                      bottom: 15,
                      right: 20,
                      child: GestureDetector(
                        onTap: _isUploadingCoverPic
                            ? null
                            : _pickAndUploadCoverPicture,
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
                          child: _isUploadingCoverPic
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : const Icon(
                            Icons.edit,
                            size: 18,
                            color: orangeColor,
                          ),
                        ),
                      ),
                    ),

                    // 2. Foto Profil dengan Badge Edit
                    Positioned(
                      bottom: 0,
                      left: 20,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: creamColor,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(3),
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
                                    : const AssetImage(
                                    "assets/images/default_profile_picture.png")
                                as ImageProvider,
                              ),
                            ),
                          ),

                          // Ikon Pensil Kecil
                          GestureDetector(
                            onTap: _isUploadingProfilePic
                                ? null
                                : _pickAndUploadProfilePicture,
                            child: Container(
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
                                ],
                              ),
                              child: _isUploadingProfilePic
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Icon(
                                Icons.edit,
                                size: 16,
                                color: orangeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ================= FORM SECTION =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      _buildLabel("Nama", brownText),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nameController,
                        brownText: brownText,
                      ),

                      const SizedBox(height: 20),

                      _buildLabel("Bio", brownText),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _bioController,
                        brownText: brownText,
                        maxLines: 5,
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: editProfileProvider.isLoading
                              ? null
                              : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orangeColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          child: editProfileProvider.isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ),
                          )
                              : const Text(
                            "Simpan Perubahan",
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

                const SizedBox(height: 40),
                Opacity(
                  opacity: 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.soup_kitchen,
                        size: 80,
                        color: orangeColor.withOpacity(0.3),
                      ),
                      Icon(
                        Icons.kitchen,
                        size: 80,
                        color: orangeColor.withOpacity(0.3),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

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