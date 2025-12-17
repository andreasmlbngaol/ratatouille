import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/recipes/presentation/provider/create_recipe_provider.dart';
import 'package:ratatouille/features/users/presentation/widgets/rounded_bold_outline.dart';

class CreateRecipeIngredientsPage extends StatefulWidget {
  const CreateRecipeIngredientsPage({super.key});

  @override
  State<CreateRecipeIngredientsPage> createState() => _CreateRecipeIngredientsPageState();
}

class _CreateRecipeIngredientsPageState extends State<CreateRecipeIngredientsPage> {
  late TextEditingController _searchController;
  late TextEditingController _amountController;
  late TextEditingController _unitController;
  late TextEditingController _alternativeController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _amountController = TextEditingController();
    _unitController = TextEditingController();
    _alternativeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CreateRecipeProvider>();
      provider.loadIngredients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _unitController.dispose();
    _alternativeController.dispose();
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

  void _resetIngredientForm(CreateRecipeProvider provider) {
    _searchController.clear();
    _amountController.clear();
    _unitController.clear();
    _alternativeController.clear();
    provider.cancelIngredientForm();
  }

  String _getSelectedIngredientTagName(CreateRecipeProvider provider) {
    return provider.selectedIngredientTag!.name;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: const Color(0xFFFFFDDE),
          backgroundColor: const Color(0xFFF3551E),
          title: Text(
            'Buat Resep',
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
        floatingActionButton: Consumer<CreateRecipeProvider>(
          builder: (context, provider, _) {
            return FloatingActionButton.extended(
              onPressed: provider.selectedIngredientTag == null &&
                  !provider.isLoading
                  ? () => context.push(AppRoutes.createRecipeSteps)
                  : null,
              backgroundColor: const Color(0xFF3F5242),
              label: Text(
                "Lanjut",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFFFFDDE),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              icon: const Iconify(
                Mdi.navigate_next,
                color: Color(0xFFFFFDDE),
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFFFFFDDE),
        body: Consumer<CreateRecipeProvider>(
          builder: (context, provider, _) {
            if (provider.errorMessage != null &&
                provider.errorMessage!.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showErrorSnackBar(provider.errorMessage!);
                provider.clearError();
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // Ingredients List
                  Text(
                    'Bahan yang ditambahkan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF5E2A25),
                      fontSize: 20,
                    ),
                  ),
                  if (provider.ingredients.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF5E2A25),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFFFFDFA),
                      ),
                      child: Center(
                        child: provider.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                          'Belum ada bahan yang ditambahkan',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.ingredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = provider.ingredients[index];
                          final name = ingredient.tag.name;

                          // Format angka agar 5.0 menjadi 5
                          String formatAmount(double? amount) {
                            if (amount == null) return "";
                            if (amount == amount.roundToDouble()) {
                              return amount.toInt().toString();
                            }
                            return amount.toString();
                          }

                          final amountText = ingredient.amount == null || ingredient.unit == null
                              ? "Secukupnya"
                              : "${formatAmount(ingredient.amount)} ${ingredient.unit}";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFDFA),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF5E2A25),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // LEFT SIDE -> Column(name + alternative)
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 2,
                                    children: [
                                      Text(
                                        name,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: const Color(0xFF5E2A25),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      if (ingredient.alternative != null &&
                                          ingredient.alternative!.trim().isNotEmpty)
                                        Text(
                                          "Alternatif: ${ingredient.alternative}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // RIGHT SIDE -> Row(amount + delete)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      amountText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.delete, size: 20, color: Color(0xFFB71C1C)),
                                      onPressed: () {
                                        // provider.removeIngredient(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }                    ),

                  // Ingredient Search/Form
                  Text(
                    'Masukkan bahan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF3F5242),
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  // Search State
                  if (provider.selectedIngredientTag == null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari bahan (min 3 karakter)',

                            fillColor: const Color(0xFFE1EDE1),
                            filled: true,
                            border: roundedBoldOutline(
                              color: Color(0xFF3F5242),
                              radius: 25
                            ),
                            enabledBorder: roundedBoldOutline(
                              color: Color(0xFF3F5242),
                              radius: 25
                            ),
                            focusedBorder: roundedBoldOutline(
                                color: Color(0xFF3F5242),
                                radius: 25
                            ),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: provider.isSearchingIngredient
                                ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                                : null,
                          ),
                          onChanged: (value) {
                            provider.searchIngredientTags(value);
                          },
                        ),
                        if (_searchController.text.length >= 3)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF3F5242),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFFFFDFA),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,   // ← ini yang hilangin padding bawah/atas
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.searchResults.length + 1,
                              separatorBuilder: (context, index) => const Divider(
                                height: 0.5,
                                thickness: 1,
                                color: Color(0xFF3F5242),
                              ),
                              itemBuilder: (context, index) {
                                if (index < provider.searchResults.length) {
                                  final tag = provider.searchResults[index];
                                  return ListTile(
                                    minVerticalPadding: 4,
                                    dense: true,
                                    title: Text(
                                      tag.name,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 15,
                                        color: Color(0xFF3F5242),
                                      ),
                                    ),
                                    onTap: () => provider.selectIngredientTag(tag),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  );
                                } else {
                                  // Buat baru
                                  return ListTile(
                                    title: Text(
                                      '+ Buat bahan baru "${_searchController.text}"',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xFF76342E),
                                      ),
                                    ),
                                    onTap: () =>
                                        provider.createNewIngredientTag(_searchController.text),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    )
                  else
                    Card(
                      color: const Color(0xFFFFFDFA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0xFF5E2A25),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12), // diperkecil
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10, // spacing diperkecil
                          children: [

                            // Selected tag
                            Text(
                              _getSelectedIngredientTagName(provider),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF3F5242),
                              ),
                            ),

                            // Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: provider.skipAmount,
                                  activeColor: const Color(0xFF3F5242),
                                  onChanged: (val)
                                  {
                                    _amountController.clear();
                                    _unitController.clear();
                                    return provider.setSkipAmount(val ?? false);
                                  },
                                ),
                                const Text(
                                  "Tidak membutuhkan jumlah & satuan",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),

                            // Amount + Unit (hilang jika centang)
                            if (!provider.skipAmount)
                              Row(
                                spacing: 8,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: _amountController,
                                      decoration: InputDecoration(
                                        labelText: 'Jumlah',
                                        hintText: '0',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: roundedBoldOutline(),
                                        enabledBorder: roundedBoldOutline(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        final amount = double.tryParse(value);
                                        if (amount != null) provider.setIngredientAmount(amount);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: _unitController,
                                      decoration: InputDecoration(
                                        labelText: 'Satuan',
                                        hintText: 'gr',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: roundedBoldOutline(),
                                        enabledBorder: roundedBoldOutline(),
                                      ),
                                      onChanged: provider.setIngredientUnit,
                                    ),
                                  ),
                                ],
                              ),

                            // Alternative
                            TextField(
                              controller: _alternativeController,
                              decoration: InputDecoration(
                                labelText: 'Bahan Alternatif (opsional)',
                                hintText: 'Masukkan bahan alternatif',
                                filled: true,
                                fillColor: Colors.white,
                                border: roundedBoldOutline(),
                                enabledBorder: roundedBoldOutline(),
                              ),
                              onChanged: provider.setIngredientAlternative,
                            ),

                            // Buttons
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _resetIngredientForm(provider),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFBA1813), // merah filled
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(0xFFB39245),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Text('Batal'),
                                  ),
                                ),

                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: provider.isLoading
                                        ? null
                                        : () async {
                                      await provider.saveIngredient();
                                      if (mounted) _resetIngredientForm(provider);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3F5242),
                                      foregroundColor: const Color(0xFFFFFDDE),
                                      side: const BorderSide(
                                        color: Color(0xFFB39245),
                                        width: 2,
                                      ),
                                    ),
                                    child: provider.isLoading
                                        ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                        AlwaysStoppedAnimation(Color(0xFFFFFDDE)),
                                      ),
                                    )
                                        : const Text(
                                      'Simpan',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 64),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
