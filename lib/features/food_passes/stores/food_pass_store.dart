
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:utara_app/core/models/food_pass.dart';

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
    try {
      errorMessage = null;
      scannedPass = null;
      final url = '/food-passes/scan';
      _scanFoodPassFuture = ObservableFuture(_dio.post(
        url,
        data: {'pass_id': passId},
      ));
      await _scanFoodPassFuture;
    } on DioException catch (e) {
      errorMessage = e.response?.data['error'] ?? e.toString();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
