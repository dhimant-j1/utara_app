import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/models/food_pass.dart';
import 'package:utara_app/core/stores/auth_store.dart';

part 'food_pass_store.g.dart';

class FoodPassStore = _FoodPassStore with _$FoodPassStore;

abstract class _FoodPassStore with Store {
  final Dio _dio;

  _FoodPassStore(this._dio);

  @observable
  ObservableFuture<void>? _scanFoodPassFuture;

  @observable
  String? errorMessage;

  @observable
  FoodPass? scannedPass;

  @computed
  bool get isLoading => _scanFoodPassFuture?.status == FutureStatus.pending;

  @action
  Future<void> scanFoodPass(String passId) async {
    AuthStore authStore = getIt<AuthStore>();
    try {
      errorMessage = null;
      scannedPass = null;
      final url = '/food-passes/scan';
      _scanFoodPassFuture = ObservableFuture(_dio.post(
        url,
        data: {
          'pass_id': passId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      ));
      await _scanFoodPassFuture;
    } on DioException catch (e) {
      errorMessage = e.response?.data['error'] ?? e.toString();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
