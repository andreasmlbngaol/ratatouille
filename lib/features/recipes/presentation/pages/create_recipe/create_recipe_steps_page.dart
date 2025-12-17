import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/recipes/presentation/provider/create_recipe_provider.dart';

class CreateRecipeStepsPage extends StatefulWidget {
  const CreateRecipeStepsPage({super.key});

  @override
  State<CreateRecipeStepsPage> createState() => _CreateRecipeStepsPageState();
}

class _CreateRecipeStepsPageState extends State<CreateRecipeStepsPage> {
  late TextEditingController _contentController;
  final ImagePicker _imagePicker = ImagePicker();

  OutlineInputBorder roundedBoldOutline({
    Color borderColor = const Color(0xFF5E2A25),
    double radius = 12,
    double width = 2,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateRecipeProvider>().loadSteps();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImageForStep(int stepId, CreateRecipeProvider provider) async {
    try {
      final XFile? image =
      await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        await provider.uploadStepImage(image, stepId);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,

      child: Consumer<CreateRecipeProvider>(
        builder: (context, provider, _) {
          final bool isEditing = provider.currentEditingStepId != null;

          // FILTER: Jangan tampilkan step terakhir kalau sedang editing
          final stepsToShow = isEditing
              ? provider.steps.sublist(0, provider.steps.length - 1)
              : provider.steps;

          return Scaffold(
            backgroundColor: const Color(0xFFFFFDDE),

            //---------------- APP BAR
            appBar: AppBar(
              backgroundColor: const Color(0xFFF3551E),
              foregroundColor: const Color(0xFFFFFDDE),
              title: Text(
                'Langkah-langkah',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 25,
                  color: const Color(0xFFFFFDDE),
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),

            //---------------- FAB (disable kalau editing)
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor:
              isEditing ? Colors.grey : const Color(0xFF3F5242),
              onPressed: isEditing
                  ? null
                  : () => context.push(AppRoutes.createRecipePreview),
              icon: Icon(
                Icons.navigate_next,
                color: isEditing ? Colors.black26 : const Color(0xFFFFFDDE),
              ),
              label: Text(
                "Lanjut",
                style: TextStyle(
                  color: isEditing ? Colors.black38 : const Color(0xFFFFFDDE),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            //---------------- BODY
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Langkah yang ditambahkan',
                    style: TextStyle(
                      color: Color(0xFF5E2A25),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  //---------------- LIST OF STEPS (tanpa step terakhir saat editing)
                  ...stepsToShow.map((step) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${step.stepNumber}. ${step.content}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),

                          if (step.images.isNotEmpty)
                            SizedBox(
                              height: 130,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: step.images.map((img) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        "${AppConstant.baseUrl}${img.url}",
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  //---------------- TOMBOL TAMBAH (kalau tidak editing)
                  if (!isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F5242),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          provider.addNewStep();
                          _contentController.clear();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Tambah Langkah",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  //---------------- EDITOR MODE
                  if (isEditing) ...[
                    TextField(
                      controller: _contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Masukkan langkah resep',
                        filled: true,
                        fillColor: Colors.white,
                        border: roundedBoldOutline(),
                        enabledBorder: roundedBoldOutline(),
                        focusedBorder: roundedBoldOutline(
                          borderColor: const Color(0xFF3F5242),
                        ),
                      ),
                      onChanged: provider.setCurrentStepContent,
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 130,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: provider.isLoading
                                ? null
                                : () => _pickImageForStep(
                              provider.currentEditingStepId!,
                              provider,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFF5E2A25), width: 2),
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFFFFFDFA),
                              ),
                              height: 120,
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt,
                                      color: Color(0xFF5E2A25), size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    provider.isLoading
                                        ? 'Mengunggah...'
                                        : 'Upload\nGambar',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF3F5242),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: provider.steps.last.images.isEmpty
                                ? Center(
                              child: Text(
                                'Belum ada gambar',
                                style:
                                TextStyle(color: Colors.grey[600]),
                              ),
                            )
                                : ListView(
                              scrollDirection: Axis.horizontal,
                              children: provider.steps.last.images
                                  .map((img) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      "${AppConstant.baseUrl}${img.url}",
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F5242),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          provider.updateCurrentStep();
                          _contentController.clear();
                        },
                        child: const Text(
                          "Simpan Langkah",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
