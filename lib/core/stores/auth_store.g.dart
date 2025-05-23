// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStoreBase, Store {
  Computed<bool>? _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated =>
      (_$isAuthenticatedComputed ??= Computed<bool>(() => super.isAuthenticated,
              name: '_AuthStoreBase.isAuthenticated'))
          .value;
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??=
          Computed<bool>(() => super.isAdmin, name: '_AuthStoreBase.isAdmin'))
      .value;
  Computed<bool>? _$isStaffComputed;

  @override
  bool get isStaff => (_$isStaffComputed ??=
          Computed<bool>(() => super.isStaff, name: '_AuthStoreBase.isStaff'))
      .value;
  Computed<bool>? _$canManageRoomsComputed;

  @override
  bool get canManageRooms =>
      (_$canManageRoomsComputed ??= Computed<bool>(() => super.canManageRooms,
              name: '_AuthStoreBase.canManageRooms'))
          .value;
  Computed<bool>? _$canManageFoodPassesComputed;

  @override
  bool get canManageFoodPasses => (_$canManageFoodPassesComputed ??=
          Computed<bool>(() => super.canManageFoodPasses,
              name: '_AuthStoreBase.canManageFoodPasses'))
      .value;
  Computed<bool>? _$canProcessRequestsComputed;

  @override
  bool get canProcessRequests => (_$canProcessRequestsComputed ??=
          Computed<bool>(() => super.canProcessRequests,
              name: '_AuthStoreBase.canProcessRequests'))
      .value;

  late final _$currentUserAtom =
      Atom(name: '_AuthStoreBase.currentUser', context: context);

  @override
  User? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(User? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AuthStoreBase.token', context: context);

  @override
  String? get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String? value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AuthStoreBase.isLoading', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_AuthStoreBase.errorMessage', context: context);

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

  late final _$_loadStoredAuthAsyncAction =
      AsyncAction('_AuthStoreBase._loadStoredAuth', context: context);

  @override
  Future<void> _loadStoredAuth() {
    return _$_loadStoredAuthAsyncAction.run(() => super._loadStoredAuth());
  }

  late final _$loginAsyncAction =
      AsyncAction('_AuthStoreBase.login', context: context);

  @override
  Future<bool> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$signupAsyncAction =
      AsyncAction('_AuthStoreBase.signup', context: context);

  @override
  Future<bool> signup(
      {required String email,
      required String password,
      required String name,
      required String phoneNumber,
      String? role}) {
    return _$signupAsyncAction.run(() => super.signup(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AuthStoreBase.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$_AuthStoreBaseActionController =
      ActionController(name: '_AuthStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
token: ${token},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isAuthenticated: ${isAuthenticated},
isAdmin: ${isAdmin},
isStaff: ${isStaff},
canManageRooms: ${canManageRooms},
canManageFoodPasses: ${canManageFoodPasses},
canProcessRequests: ${canProcessRequests}
    ''';
  }
}
