import 'package:mobx/mobx.dart';
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
}
