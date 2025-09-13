import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import 'package:utara_app/core/models/food_pass_category.dart';
import 'package:utara_app/features/food_passes/repository/food_pass_category_repository.dart';
import 'package:utara_app/features/food_passes/stores/food_pass_category_store.dart';

class FoodPassCategoriesPage extends StatefulWidget {
  const FoodPassCategoriesPage({super.key});

  @override
  State<FoodPassCategoriesPage> createState() => _FoodPassCategoriesPageState();
}

class _FoodPassCategoriesPageState extends State<FoodPassCategoriesPage> {
  late final FoodPassCategoryStore _store;
  final _formKey = GlobalKey<FormState>();
  final _buildingNameController = TextEditingController();
  final _colorCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authStore = getIt<AuthStore>();

    // Check if user has admin privileges
    if (!authStore.isAdmin && !authStore.isStaff) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/dashboard');
      });
      return;
    }

    _store = FoodPassCategoryStore(FoodPassCategoryRepository());
    _store.fetchCategories();
  }

  @override
  void dispose() {
    _buildingNameController.dispose();
    _colorCodeController.dispose();
    super.dispose();
  }

  void _showCreateDialog() {
    _buildingNameController.clear();
    _colorCodeController.text = '#FF5722';
    _store.clearMessages();

    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        title: 'Create Food Pass Category',
        buildingNameController: _buildingNameController,
        colorCodeController: _colorCodeController,
        formKey: _formKey,
        onSubmit: () async {
          if (_formKey.currentState!.validate()) {
            await _store.createCategory(
              buildingName: _buildingNameController.text.trim(),
              colorCode: _colorCodeController.text.trim(),
            );
            if (_store.successMessage != null) {
              Navigator.of(context).pop();
            }
          }
        },
        store: _store,
      ),
    );
  }

  void _showEditDialog(FoodPassCategory category) {
    _buildingNameController.text = category.buildingName;
    _colorCodeController.text = category.colorCode;
    _store.clearMessages();
    _store.setSelectedCategory(category);

    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        title: 'Edit Food Pass Category',
        buildingNameController: _buildingNameController,
        colorCodeController: _colorCodeController,
        formKey: _formKey,
        onSubmit: () async {
          if (_formKey.currentState!.validate()) {
            await _store.updateCategory(
              id: category.id,
              buildingName: _buildingNameController.text.trim(),
              colorCode: _colorCodeController.text.trim(),
            );
            if (_store.successMessage != null) {
              Navigator.of(context).pop();
            }
          }
        },
        store: _store,
      ),
    );
  }

  void _showDeleteDialog(FoodPassCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete the category "${category.buildingName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Observer(
            builder: (context) => ElevatedButton(
              onPressed: _store.isDeleting
                  ? null
                  : () async {
                      await _store.deleteCategory(category.id);
                      Navigator.of(context).pop();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: _store.isDeleting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Delete'),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorCode) {
    try {
      return Color(int.parse(colorCode.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<FoodPassCategoryStore>.value(
      value: _store,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Pass Categories'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _store.fetchCategories(),
            ),
          ],
        ),
        body: Observer(
          builder: (context) {
            if (_store.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_store.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _store.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _store.fetchCategories(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (!_store.hasCategories) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.category, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No food pass categories found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _showCreateDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Create First Category'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                if (_store.successMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade100,
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _store.successMessage!,
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.green),
                          onPressed: () => _store.clearMessages(),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _store.categories.length,
                    itemBuilder: (context, index) {
                      final category = _store.categories[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _parseColor(category.colorCode),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                          ),
                          title: Text(
                            category.buildingName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Color: ${category.colorCode}'),
                              Text(
                                'Created: ${category.createdAt.day}/${category.createdAt.month}/${category.createdAt.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditDialog(category),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteDialog(category),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCreateDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _CategoryDialog extends StatelessWidget {
  final String title;
  final TextEditingController buildingNameController;
  final TextEditingController colorCodeController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final FoodPassCategoryStore store;

  const _CategoryDialog({
    required this.title,
    required this.buildingNameController,
    required this.colorCodeController,
    required this.formKey,
    required this.onSubmit,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: buildingNameController,
              decoration: const InputDecoration(
                labelText: 'Building Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a building name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: colorCodeController,
              decoration: const InputDecoration(
                labelText: 'Color Code (e.g., #FF5722)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a color code';
                }
                if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value.trim())) {
                  return 'Please enter a valid hex color code (e.g., #FF5722)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (context) {
                if (store.errorMessage != null) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            store.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        Observer(
          builder: (context) => ElevatedButton(
            onPressed: store.isPerformingAction ? null : onSubmit,
            child: store.isPerformingAction
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(title.contains('Create') ? 'Create' : 'Update'),
          ),
        ),
      ],
    );
  }
}
