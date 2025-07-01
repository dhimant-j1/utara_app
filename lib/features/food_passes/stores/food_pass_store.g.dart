// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_pass_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FoodPassStore on _FoodPassStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_FoodPassStore.isLoading'))
          .value;

  late final _$_scanFoodPassFutureAtom =
      Atom(name: '_FoodPassStore._scanFoodPassFuture', context: context);

  @override
  ObservableFuture<void>? get _scanFoodPassFuture {
    _$_scanFoodPassFutureAtom.reportRead();
    return super._scanFoodPassFuture;
  }

  @override
  set _scanFoodPassFuture(ObservableFuture<void>? value) {
    _$_scanFoodPassFutureAtom.reportWrite(value, super._scanFoodPassFuture, () {
      super._scanFoodPassFuture = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_FoodPassStore.errorMessage', context: context);

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

  late final _$scannedPassAtom =
      Atom(name: '_FoodPassStore.scannedPass', context: context);

  @override
  FoodPass? get scannedPass {
    _$scannedPassAtom.reportRead();
    return super.scannedPass;
  }

  @override
  set scannedPass(FoodPass? value) {
    _$scannedPassAtom.reportWrite(value, super.scannedPass, () {
      super.scannedPass = value;
    });
  }

  late final _$scanFoodPassAsyncAction =
      AsyncAction('_FoodPassStore.scanFoodPass', context: context);

  @override
  Future<void> scanFoodPass(String passId) {
    return _$scanFoodPassAsyncAction.run(() => super.scanFoodPass(passId));
  }

  @override
  String toString() {
    return '''
errorMessage: ${errorMessage},
scannedPass: ${scannedPass},
isLoading: ${isLoading}
    ''';
  }
}
