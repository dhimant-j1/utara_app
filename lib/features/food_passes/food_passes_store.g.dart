// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_passes_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FoodPassesStore on _FoodPassesStore, Store {
  Computed<ObservableList<FoodPass>>? _$foodPassesComputed;

  @override
  ObservableList<FoodPass> get foodPasses =>
      (_$foodPassesComputed ??= Computed<ObservableList<FoodPass>>(
        () => super.foodPasses,
        name: '_FoodPassesStore.foodPasses',
      )).value;

  late final _$isLoadingAtom = Atom(
    name: '_FoodPassesStore.isLoading',
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

  late final _$errorMessageAtom = Atom(
    name: '_FoodPassesStore.errorMessage',
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

  late final _$allFoodPassesAtom = Atom(
    name: '_FoodPassesStore.allFoodPasses',
    context: context,
  );

  @override
  ObservableList<FoodPass> get allFoodPasses {
    _$allFoodPassesAtom.reportRead();
    return super.allFoodPasses;
  }

  @override
  set allFoodPasses(ObservableList<FoodPass> value) {
    _$allFoodPassesAtom.reportWrite(value, super.allFoodPasses, () {
      super.allFoodPasses = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: '_FoodPassesStore.selectedDate',
    context: context,
  );

  @override
  DateTime? get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime? value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$showUsedOnlyAtom = Atom(
    name: '_FoodPassesStore.showUsedOnly',
    context: context,
  );

  @override
  bool? get showUsedOnly {
    _$showUsedOnlyAtom.reportRead();
    return super.showUsedOnly;
  }

  @override
  set showUsedOnly(bool? value) {
    _$showUsedOnlyAtom.reportWrite(value, super.showUsedOnly, () {
      super.showUsedOnly = value;
    });
  }

  late final _$fetchFoodPassesAsyncAction = AsyncAction(
    '_FoodPassesStore.fetchFoodPasses',
    context: context,
  );

  @override
  Future<void> fetchFoodPasses([String? userId]) {
    return _$fetchFoodPassesAsyncAction.run(
      () => super.fetchFoodPasses(userId),
    );
  }

  late final _$_FoodPassesStoreActionController = ActionController(
    name: '_FoodPassesStore',
    context: context,
  );

  @override
  void setSelectedDate(DateTime? date) {
    final _$actionInfo = _$_FoodPassesStoreActionController.startAction(
      name: '_FoodPassesStore.setSelectedDate',
    );
    try {
      return super.setSelectedDate(date);
    } finally {
      _$_FoodPassesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowUsedOnly(bool? value) {
    final _$actionInfo = _$_FoodPassesStoreActionController.startAction(
      name: '_FoodPassesStore.setShowUsedOnly',
    );
    try {
      return super.setShowUsedOnly(value);
    } finally {
      _$_FoodPassesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
allFoodPasses: ${allFoodPasses},
selectedDate: ${selectedDate},
showUsedOnly: ${showUsedOnly},
foodPasses: ${foodPasses}
    ''';
  }
}
