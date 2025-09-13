import 'package:mobx/mobx.dart';
import 'package:utara_app/features/food_passes/repository/food_pass_category_repository.dart';
import 'package:utara_app/core/models/food_pass_category.dart';

part 'food_pass_category_store.g.dart';

class FoodPassCategoryStore = _FoodPassCategoryStore with _$FoodPassCategoryStore;

abstract class _FoodPassCategoryStore with Store {
  final FoodPassCategoryRepository repository;

  _FoodPassCategoryStore(this.repository);

  @observable
  bool isLoading = false;

  @observable
  bool isCreating = false;

  @observable
  bool isUpdating = false;

  @observable
  bool isDeleting = false;

  @observable
  String? errorMessage;

  @observable
  String? successMessage;

  @observable
  ObservableList<FoodPassCategory> categories = ObservableList<FoodPassCategory>();

  @observable
  FoodPassCategory? selectedCategory;

  @action
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
  }

  @action
  void setSelectedCategory(FoodPassCategory? category) {
    selectedCategory = category;
  }

  @action
  Future<void> fetchCategories() async {
    isLoading = true;
    errorMessage = null;

    try {
      final fetchedCategories = await repository.getAllCategories();
      categories = ObservableList.of(fetchedCategories);
    } catch (e) {
      errorMessage = 'Failed to load food pass categories: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createCategory({
    required String buildingName,
    required String colorCode,
  }) async {
    isCreating = true;
    errorMessage = null;
    successMessage = null;

    try {
      final newCategory = await repository.createCategory(
        buildingName: buildingName,
        colorCode: colorCode,
      );
      categories.add(newCategory);
      successMessage = 'Food pass category created successfully!';
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isCreating = false;
    }
  }

  @action
  Future<void> updateCategory({
    required String id,
    required String buildingName,
    required String colorCode,
  }) async {
    isUpdating = true;
    errorMessage = null;
    successMessage = null;

    try {
      await repository.updateCategory(
        id: id,
        buildingName: buildingName,
        colorCode: colorCode,
      );

      // Refresh the categories list to get updated data
      await fetchCategories();

      successMessage = 'Food pass category updated successfully!';
      selectedCategory = null;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> deleteCategory(String id) async {
    isDeleting = true;
    errorMessage = null;
    successMessage = null;

    try {
      await repository.deleteCategory(id);
      categories.removeWhere((cat) => cat.id == id);
      successMessage = 'Food pass category deleted successfully!';
      if (selectedCategory?.id == id) {
        selectedCategory = null;
      }
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isDeleting = false;
    }
  }

  @computed
  bool get hasCategories => categories.isNotEmpty;

  @computed
  bool get isPerformingAction => isCreating || isUpdating || isDeleting;
}
