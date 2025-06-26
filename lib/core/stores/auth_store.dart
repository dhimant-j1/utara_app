import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final storedToken = _prefs.getString('auth_token');
    if (storedToken != null) {
      token = storedToken;
      try {
        currentUser = await _authService.getProfile();
      } catch (e) {
        await logout();
      }
    }
  }

  @action
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      final result = await _authService.login(email, password);
      token = result['token'];
      currentUser = User.fromJson(result['user']);

      await _prefs.setString('auth_token', token!);
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

      await _prefs.setString('auth_token', token!);
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
    currentUser = null;
    token = null;
    await _prefs.remove('auth_token');
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
