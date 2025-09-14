import 'package:mobx/mobx.dart';
import '../../../core/models/manage_user_model.dart';
import '../repository/user_repository.dart';

part 'user_store.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

abstract class _UserStoreBase with Store {
  final UserRepository _userRepository;

  _UserStoreBase(this._userRepository);

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<bool> createUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _userRepository.createUser(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @observable
  List<ManangeUser> userList = [];

  @action
  Future<List<Map<String, dynamic>>> getUsersList() async {
    isLoading = true;
    errorMessage = null;

    try {
      final users = await _userRepository.getUsers();
      userList = users.map((m) => ManangeUser.fromJson(m)).toList();

      return users;
    } catch (e) {
      errorMessage = e.toString();
      return [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteUser({required String userId, required int index}) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _userRepository.deleteUser(userId: userId);
      final updated = List<ManangeUser>.from(userList)..removeAt(index);
      userList = updated;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    required String userId,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _userRepository.updateUser(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
        userId: userId,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }
}
