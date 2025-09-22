// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_pass_category_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FoodPassCategoryStore on _FoodPassCategoryStore, Store {
  Computed<bool>? _$hasCategoriesComputed;

  @override
  bool get hasCategories => (_$hasCategoriesComputed ??= Computed<bool>(
    () => super.hasCategories,
    name: '_FoodPassCategoryStore.hasCategories',
  )).value;
  Computed<bool>? _$isPerformingActionComputed;

  @override
  bool get isPerformingAction =>
      (_$isPerformingActionComputed ??= Computed<bool>(
        () => super.isPerformingAction,
        name: '_FoodPassCategoryStore.isPerformingAction',
      )).value;

  late final _$isLoadingAtom = Atom(
    name: '_FoodPassCategoryStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isCreatingAtom = Atom(
    name: '_FoodPassCategoryStore.isCreating',
    context: context,
  );

  @override
  bool get isCreating {
    _$isCreatingAtom.reportRead();
    return super.isCreating;
  }

  @override
  set isCreating(bool value) {
    _$isCreatingAtom.reportWrite(value, super.isCreating, () {
      super.isCreating = value;
    });
  }

  late final _$isUpdatingAtom = Atom(
    name: '_FoodPassCategoryStore.isUpdating',
    context: context,
  );

  @override
  bool get isUpdating {
    _$isUpdatingAtom.reportRead();
    return super.isUpdating;
  }

  @override
  set isUpdating(bool value) {
    _$isUpdatingAtom.reportWrite(value, super.isUpdating, () {
      super.isUpdating = value;
    });
  }

  late final _$isDeletingAtom = Atom(
    name: '_FoodPassCategoryStore.isDeleting',
    context: context,
  );

  @override
  bool get isDeleting {
    _$isDeletingAtom.reportRead();
    return super.isDeleting;
  }

  @override
  set isDeleting(bool value) {
    _$isDeletingAtom.reportWrite(value, super.isDeleting, () {
      super.isDeleting = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_FoodPassCategoryStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$successMessageAtom = Atom(
    name: '_FoodPassCategoryStore.successMessage',
    context: context,
  );

  @override
  String? get successMessage {
    _$successMessageAtom.reportRead();
    return super.successMessage;
  }

  @override
  set successMessage(String? value) {
    _$successMessageAtom.reportWrite(value, super.successMessage, () {
      super.successMessage = value;
    });
  }

  late final _$categoriesAtom = Atom(
    name: '_FoodPassCategoryStore.categories',
    context: context,
  );

  @override
  ObservableList<FoodPassCategory> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableList<FoodPassCategory> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$selectedCategoryAtom = Atom(
    name: '_FoodPassCategoryStore.selectedCategory',
    context: context,
  );

  @override
  FoodPassCategory? get selectedCategory {
    _$selectedCategoryAtom.reportRead();
    return super.selectedCategory;
  }

  @override
  set selectedCategory(FoodPassCategory? value) {
    _$selectedCategoryAtom.reportWrite(value, super.selectedCategory, () {
      super.selectedCategory = value;
    });
  }

  late final _$fetchCategoriesAsyncAction = AsyncAction(
    '_FoodPassCategoryStore.fetchCategories',
    context: context,
  );

  @override
  Future<void> fetchCategories() {
    return _$fetchCategoriesAsyncAction.run(() => super.fetchCategories());
  }

  late final _$createCategoryAsyncAction = AsyncAction(
    '_FoodPassCategoryStore.createCategory',
    context: context,
  );

  @override
  Future<void> createCategory({
    required String buildingName,
    required String colorCode,
  }) {
    return _$createCategoryAsyncAction.run(
      () => super.createCategory(
        buildingName: buildingName,
        colorCode: colorCode,
      ),
    );
  }

  late final _$updateCategoryAsyncAction = AsyncAction(
    '_FoodPassCategoryStore.updateCategory',
    context: context,
  );

  @override
  Future<void> updateCategory({
    required String id,
    required String buildingName,
    required String colorCode,
  }) {
    return _$updateCategoryAsyncAction.run(
      () => super.updateCategory(
        id: id,
        buildingName: buildingName,
        colorCode: colorCode,
      ),
    );
  }

  late final _$deleteCategoryAsyncAction = AsyncAction(
    '_FoodPassCategoryStore.deleteCategory',
    context: context,
  );

  @override
  Future<void> deleteCategory(String id) {
    return _$deleteCategoryAsyncAction.run(() => super.deleteCategory(id));
  }

  late final _$_FoodPassCategoryStoreActionController = ActionController(
    name: '_FoodPassCategoryStore',
    context: context,
  );

  @override
  void clearMessages() {
    final _$actionInfo = _$_FoodPassCategoryStoreActionController.startAction(
      name: '_FoodPassCategoryStore.clearMessages',
    );
    try {
      return super.clearMessages();
    } finally {
      _$_FoodPassCategoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedCategory(FoodPassCategory? category) {
    final _$actionInfo = _$_FoodPassCategoryStoreActionController.startAction(
      name: '_FoodPassCategoryStore.setSelectedCategory',
    );
    try {
      return super.setSelectedCategory(category);
    } finally {
      _$_FoodPassCategoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isCreating: ${isCreating},
isUpdating: ${isUpdating},
isDeleting: ${isDeleting},
errorMessage: ${errorMessage},
successMessage: ${successMessage},
categories: ${categories},
selectedCategory: ${selectedCategory},
hasCategories: ${hasCategories},
isPerformingAction: ${isPerformingAction}
    ''';
  }
}
