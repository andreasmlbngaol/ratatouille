import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';

import '../provider/fridge_filter_provider.dart';

class FridgeFilterPage extends StatefulWidget {
  const FridgeFilterPage({super.key});

  @override
  State<FridgeFilterPage> createState() => _FridgeFilterPageState();
}

class _FridgeFilterPageState extends State<FridgeFilterPage> {
  late TextEditingController includeController;
  late TextEditingController excludeController;
  late TextEditingController minTimeController;
  late TextEditingController maxTimeController;

  @override
  void initState() {
    super.initState();
    includeController = TextEditingController();
    excludeController = TextEditingController();
    minTimeController = TextEditingController();
    maxTimeController = TextEditingController();
  }

  @override
  void dispose() {
    includeController.dispose();
    excludeController.dispose();
    minTimeController.dispose();
    maxTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7CC),
      body: Consumer<FridgeFilterProvider>(
        builder: (context, provider, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF5A1F), // Oranye
                  Color(0xFFFFFDDE), // Kuning
                ],
                stops: [0.1, 0.1], // 0 = atas, 1 = bawah
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5A1F),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Filter Kulkas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cari resep berdasarkan bahan kulkas-mu!',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 16),

                          _sectionTitle('Include bahan'),
                          _ingredientBox(provider.includeIngredients, true, provider),
                          _inputField(
                            includeController,
                            provider.isSearchingInclude,
                                (value) => provider.searchIncludeIngredients(value),
                          ),

                          if (provider.includeSearchResults.isNotEmpty)
                            _searchResultsListInline(provider.includeSearchResults, true, provider),

                          const SizedBox(height: 20),

                          _sectionTitle('Exclude bahan'),
                          _ingredientBox(provider.excludeIngredients, false, provider),
                          _inputField(
                            excludeController,
                            provider.isSearchingExclude,
                                (value) => provider.searchExcludeIngredients(value),
                          ),

                          if (provider.excludeSearchResults.isNotEmpty)
                            _searchResultsListInline(provider.excludeSearchResults, false, provider),

                          const SizedBox(height: 20),

                          _sectionTitle('Rating'),
                          _ratingBox(provider),

                          const SizedBox(height: 20),

                          _sectionTitle('Perkiraan waktu'),
                          Row(
                            children: [
                              Expanded(
                                child: _timeField('MIN', minTimeController, (value) {
                                  if (value.isNotEmpty) {
                                    provider.setMinTime(int.parse(value));
                                  }
                                }),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _timeField('MAX', maxTimeController, (value) {
                                  if (value.isNotEmpty) {
                                    provider.setMaxTime(int.parse(value));
                                  }
                                }),
                              ),
                            ],
                          ),

                          if (provider.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                provider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                          const SizedBox(height: 30),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFBA1813),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Batalkan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3F5242),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: provider.isLoading
                                      ? null
                                      : () => _handleApplyFilter(context, provider),
                                  child: provider.isLoading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                      : const Text(
                                    'Terapkan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleApplyFilter(BuildContext context, FridgeFilterProvider provider) async {
    await provider.applyFilter();

    if (context.mounted) {
      if (provider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
      } else {
        context.push(AppRoutes.fridgeFilterResult);
      }
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _ingredientBox(List ingredients, bool isInclude, FridgeFilterProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown, width: 1.5),
      ),
      child: ingredients.isEmpty
          ? const Text('Belum ada tampilan')
          : Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(ingredients.length, (index) {
          final ingredient = ingredients[index];
          return Chip(
            label: Text(ingredient.name),
            onDeleted: () {
              if (isInclude) {
                provider.removeIncludeIngredient(ingredient.id);
              } else {
                provider.removeExcludeIngredient(ingredient.id);
              }
            },
          );
        }),
      ),
    );
  }

  Widget _inputField(
      TextEditingController controller,
      bool isSearching,
      Function(String) onChanged,
      ) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Tambahkan bahan...',
        filled: true,
        fillColor: const Color(0xFFE7F1E7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isSearching
            ? const SizedBox(
          width: 20,
          height: 20,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        )
            : null,
      ),
    );
  }

  Widget _searchResultsListInline(List results, bool isInclude, FridgeFilterProvider provider) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown, width: 1.5),
      ),
      child: Column(
        children: List.generate(results.length, (index) {
          final result = results[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text(result.name),
            onTap: () {
              if (isInclude) {
                provider.selectIncludeIngredient(result);
                includeController.clear();
              } else {
                provider.selectExcludeIngredient(result);
                excludeController.clear();
              }
            },
          );
        }),
      ),
    );
  }

  Widget _ratingBox(FridgeFilterProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          return IconButton(
            onPressed: () => provider.setRating(starIndex),
            icon: Icon(
              Icons.star,
              size: 36,
              color: starIndex <= provider.selectedRating
                  ? Colors.orange
                  : Colors.grey,
            ),
          );
        }),
      ),
    );
  }

  Widget _timeField(
      String label,
      TextEditingController controller,
      Function(String) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}