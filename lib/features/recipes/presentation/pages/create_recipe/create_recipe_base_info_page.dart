import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/recipes/presentation/provider/create_recipe_provider.dart';
import 'package:ratatouille/features/users/presentation/widgets/rounded_bold_outline.dart';

class CreateRecipeBaseInfoPage extends StatefulWidget {
  const CreateRecipeBaseInfoPage({super.key});

  @override
  State<CreateRecipeBaseInfoPage> createState() => _CreateRecipeBaseInfoPageState();
}

class _CreateRecipeBaseInfoPageState extends State<CreateRecipeBaseInfoPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _estTimeController;
  late TextEditingController _portionController;
  late bool _isPublic = true;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _estTimeController = TextEditingController();
    _portionController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CreateRecipeProvider>();
      if (provider.recipe == null) {
        provider.initializeDraftRecipe();
      } else {
        _initializeControllers(provider);
      }
    });
  }

  void _initializeControllers(CreateRecipeProvider provider) {
    _nameController.text = provider.recipe?.name ?? '';
    _descriptionController.text = provider.recipe?.description ?? '';
    _estTimeController.text =
        provider.recipe?.estTimeInMinutes.toString() ?? '';
    _portionController.text = provider.recipe?.portion.toString() ?? '';
    _isPublic = provider.recipe?.isPublic ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estTimeController.dispose();
    _portionController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery);
      if (image != null && mounted) {
        await context.read<CreateRecipeProvider>().uploadRecipeImage(image);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _handleNextButtonPressed(CreateRecipeProvider provider) async {
    // Validasi input
    if (_nameController.text
        .trim()
        .isEmpty) {
      _showErrorSnackBar('Nama resep tidak boleh kosong');
      return;
    }

    final estTime = int.tryParse(_estTimeController.text);
    if (estTime == null || estTime <= 0) {
      _showErrorSnackBar('Waktu perkiraan harus berupa angka lebih dari 0');
      return;
    }

    final portion = int.tryParse(_portionController.text);
    if (portion == null || portion <= 0) {
      _showErrorSnackBar('Porsi harus berupa angka lebih dari 0');
      return;
    }

    // Update all data sekaligus
    await provider.updateRecipeBaseInfo(
      name: _nameController.text,
      description: _descriptionController.text,
      isPublic: _isPublic,
      estTimeInMinutes: estTime,
      portion: portion,
    );

    // Jika berhasil, navigate ke halaman berikutnya
    if (mounted && provider.errorMessage == null) {
      context.push(AppRoutes.createRecipeIngredients);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateRecipeProvider>(
        builder: (context, provider, _) {
          if (provider.recipe != null &&
              _nameController.text.isEmpty &&
              _estTimeController.text.isEmpty &&
              _portionController.text.isEmpty) {
            _initializeControllers(provider);
          }

          if (provider.isLoading && provider.recipe == null) {
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Color(0xFFFFFDDE),
                backgroundColor: Color(0xFFF3551E),
                title: Text(
                    'Buat Resep',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                        fontSize: 25,
                        color: Color(0xFFFFFDDE),
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
              backgroundColor: Color(0xFFFFFDDE),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          if (provider.recipe == null) {
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Color(0xFFFFFDDE),
                backgroundColor: Color(0xFFF3551E),
                title: Text(
                    'Buat Resep',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                        fontSize: 25,
                        color: Color(0xFFFFFDDE),
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
              backgroundColor: Color(0xFFFFFDDE),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Gagal memuat resep'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.initializeDraftRecipe(),
                      child: const Text('Muat ulang'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
              appBar: AppBar(
                foregroundColor: Color(0xFFFFFDDE),
                backgroundColor: Color(0xFFF3551E),
                title: Text(
                    'Buat Resep',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                        fontSize: 25,
                        color: Color(0xFFFFFDDE),
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: provider.isLoading
                    ? null
                    : () => _handleNextButtonPressed(provider),
                backgroundColor: Color(0xFF3F5242),
                label: Text(
                    "Lanjut",
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                        color: Color(0xFFFFFDDE),
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    )
                ),
                icon: Iconify(
                  Mdi.navigate_next,
                  color: Color(0xFFFFFDDE),
                ),
              ),
              backgroundColor: Color(0xFFFFFDDE),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFFFFDFA),
                        filled: true,
                        labelStyle: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            color: Color(0xFF5E2A25)
                        ),
                        labelText: "Nama Resep",
                        hintText: 'Masukkan nama resep',
                        border: roundedBoldOutline(),
                        enabledBorder: roundedBoldOutline(),
                      ),
                    ),

                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFFFFDFA),
                        filled: true,
                        labelStyle: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            color: Color(0xFF5E2A25)
                        ),
                        labelText: "Deskripsi",
                        hintText: 'Masukkan deskripsi resep',
                        border: roundedBoldOutline(),
                        enabledBorder: roundedBoldOutline(),
                      ),
                      maxLines: 4,
                    ),

                    Text(
                      'Gambar',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color: Color(0xFF5E2A25),
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        // Upload Button
                        GestureDetector(
                          onTap: provider.isLoading ? null : _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF5E2A25), width: 2),
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xFFFFFDFA),
                            ),
                            height: 120,
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Iconify(
                                  Mdi.camera_plus_outline,
                                  color: Color(0xFF5E2A25),
                                  size: 32,
                                ),
                                Text(
                                  provider.isLoading
                                      ? 'Mengunggah...'
                                      : 'Upload Gambar',
                                  textAlign: TextAlign.center,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                      color: Color(0xFF3F5242),
                                      fontSize: 11
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: provider.recipe!.images.isEmpty
                              ? Container(
                            height: 120,
                            decoration: BoxDecoration(
                              // border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: Text('Belum ada gambar'),
                            ),
                          )
                              : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: provider.recipe!.images.reversed
                                  .map((image) =>
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: "${AppConstant.baseUrl}${image
                                            .url}",
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: Text(
                        'Publikasikan resep',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            color: Color(0xFF5E2A25),
                            fontSize: 18
                        ),
                      ),
                      subtitle: Text(
                        _isPublic
                            ? 'Resep akan terlihat oleh pengguna lain'
                            : 'Resep hanya akan terlihat oleh Anda',
                      ),
                      value: _isPublic,
                      onChanged: (value) => {
                        setState(() {
                          _isPublic = value;
                        })
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    TextField(
                      controller: _estTimeController,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFFFFDFA),
                        filled: true,
                        labelStyle: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            color: Color(0xFF5E2A25)
                        ),
                        labelText: "Perkiraan Waktu",
                        hintText: 'Masukkan waktu dalam menit',
                        suffixText: "menit",
                        border: roundedBoldOutline(),
                        enabledBorder: roundedBoldOutline(),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    // Portion

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Porsi',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                color: Color(0xFF5E2A25)
                            ),
                          ),
                        ),

                        Expanded(
                          child: TextField(
                            controller: _portionController,
                            readOnly: true,
                            decoration: InputDecoration(
                              fillColor: Color(0xFFFFFDFA),
                              filled: true,
                              border: roundedBoldOutline(),
                              enabledBorder: roundedBoldOutline(),
                              prefixIcon: IconButton(
                                onPressed: () {
                                  final val = int.tryParse(_portionController.text) ?? 0;
                                  if (val > 1) {
                                    final newPortion = val - 1;
                                    _portionController.text = newPortion.toString();
                                  } else {
                                    debugPrint(val.toString());
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  final current = int.tryParse(
                                      _portionController.text) ?? 0;
                                  final newPortion = current + 1;
                                  _portionController.text =
                                      newPortion.toString();
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    // Error Message
                    if (provider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  provider.errorMessage!,
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ),
                              GestureDetector(
                                onTap: provider.clearError,
                                child: Icon(
                                    Icons.close, color: Colors.red[700]),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              )
          );
        }
    );
  }
}