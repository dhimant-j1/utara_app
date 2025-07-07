import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utara_app/utils/const.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final AuthService _authService;
  late SharedPreferences _prefs;

  _AuthStoreBase(this._authService);

  @observable
  User? currentUser;

  @observable
  String? token;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get isAuthenticated => token != null && currentUser != null;

  @computed
  bool get isAdmin => currentUser?.isAdmin ?? false;

  @computed
  bool get isStaff => currentUser?.isStaff ?? false;

  @computed
  bool get canManageRooms => currentUser?.canManageRooms ?? false;

  @computed
  bool get canManageFoodPasses => currentUser?.canManageFoodPasses ?? false;

  @computed
  bool get canProcessRequests => currentUser?.canProcessRequests ?? false;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadStoredAuth();
  }

  @action
  Future<void> _loadStoredAuth() async {
    final storedToken = _prefs.getString(Const.token);
    print('Stored token: $storedToken'); // Debug log
    if (storedToken != null) {
      token = storedToken;
      _authService.setAuthToken(storedToken);
      // Load stored user data
      currentUser = _loadUserFromStorage();
    } else {
      print('No stored token found'); // Debug log
    }
  }

  @action
  Future<void> _saveUserToStorage(User user) async {
    await _prefs.setString(Const.userData, jsonEncode(user.toJson()));
  }

  @action
  User? _loadUserFromStorage() {
    final userJson = _prefs.getString(Const.userData);
    if (userJson != null) {
      try {
        return User.fromJson(jsonDecode(userJson));
      } catch (e) {
        print('Error loading user data: $e');
        return null;
      }
    }
    return null;
  }

  @action
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      final result = await _authService.login(email, password);
      token = result['token'];
      _authService.setAuthToken(token);
      currentUser = User.fromJson(result['user']);

      // Save both token and user data
      await _prefs.setString(Const.token, token!);
      await _saveUserToStorage(currentUser!);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    String? role,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final result = await _authService.signup(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
      );
      token = result['token'];
      currentUser = User.fromJson(result['user']);

      // Save both token and user data
      await _prefs.setString(Const.token, token!);
      await _saveUserToStorage(currentUser!);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    _authService.setAuthToken(null);
    currentUser = null;
    token = null;
    // Clear both token and user data
    await _prefs.remove(Const.token);
    await _prefs.remove(Const.userData);
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
