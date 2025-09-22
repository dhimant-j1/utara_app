// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStoreBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_UserStoreBase.isLoading',
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
    name: '_UserStoreBase.errorMessage',
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

  late final _$userListAtom = Atom(
    name: '_UserStoreBase.userList',
    context: context,
  );

  @override
  List<ManangeUser> get userList {
    _$userListAtom.reportRead();
    return super.userList;
  }

  @override
  set userList(List<ManangeUser> value) {
    _$userListAtom.reportWrite(value, super.userList, () {
      super.userList = value;
    });
  }

  late final _$createUserAsyncAction = AsyncAction(
    '_UserStoreBase.createUser',
    context: context,
  );

  @override
  Future<bool> createUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
  }) {
    return _$createUserAsyncAction.run(
      () => super.createUser(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
      ),
    );
  }

  late final _$getUsersListAsyncAction = AsyncAction(
    '_UserStoreBase.getUsersList',
    context: context,
  );

  @override
  Future<List<Map<String, dynamic>>> getUsersList() {
    return _$getUsersListAsyncAction.run(() => super.getUsersList());
  }

  late final _$deleteUserAsyncAction = AsyncAction(
    '_UserStoreBase.deleteUser',
    context: context,
  );

  @override
  Future<bool> deleteUser({required String userId, required int index}) {
    return _$deleteUserAsyncAction.run(
      () => super.deleteUser(userId: userId, index: index),
    );
  }

  late final _$updateUserAsyncAction = AsyncAction(
    '_UserStoreBase.updateUser',
    context: context,
  );

  @override
  Future<bool> updateUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    required String userId,
  }) {
    return _$updateUserAsyncAction.run(
      () => super.updateUser(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
        userId: userId,
      ),
    );
  }

  late final _$_UserStoreBaseActionController = ActionController(
    name: '_UserStoreBase',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
      name: '_UserStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
userList: ${userList}
    ''';
  }
}
