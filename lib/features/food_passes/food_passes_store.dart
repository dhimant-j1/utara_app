import 'package:mobx/mobx.dart';
import 'package:utara_app/features/food_passes/repository/food_pass_repository.dart';
import 'package:utara_app/core/models/food_pass.dart';

part 'food_passes_store.g.dart';

class FoodPassesStore = _FoodPassesStore with _$FoodPassesStore;

abstract class _FoodPassesStore with Store {
  final FoodPassRepository repository;

  _FoodPassesStore(this.repository);

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<FoodPass> foodPasses = ObservableList<FoodPass>();

  @observable
  DateTime? selectedDate;

  @observable
  bool? showUsedOnly;

  @action
  void setSelectedDate(DateTime? date) {
    selectedDate = date;
    fetchFoodPasses();
  }

  @action
  void setShowUsedOnly(bool? value) {
    showUsedOnly = value;
    fetchFoodPasses();
  }

  @action
  Future<void> fetchFoodPasses([String? userId]) async {
    isLoading = true;
    errorMessage = null;

    try {
      final passes = await repository.getUserFoodPasses(
        userId: userId,
        date: selectedDate,
        isUsed: showUsedOnly,
      );
      foodPasses = ObservableList.of(passes);
    } catch (e) {
      errorMessage = 'Failed to load food passes: $e';
    } finally {
      isLoading = false;
    }
  }
}
