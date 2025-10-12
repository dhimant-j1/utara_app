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
  ObservableList<FoodPass> allFoodPasses = ObservableList<FoodPass>();

  @observable
  DateTime? selectedDate;

  @observable
  bool? showUsedOnly;

  @computed
  ObservableList<FoodPass> get foodPasses {
    return ObservableList.of(
      allFoodPasses.where((pass) {
        // Filter by date if selected
        if (selectedDate != null) {
          final passDate = DateTime(
            pass.date.year,
            pass.date.month,
            pass.date.day,
          );
          final filterDate = DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
          );
          if (passDate != filterDate) return false;
        }

        // Filter by used status if selected
        if (showUsedOnly != null) {
          if (pass.isUsed != showUsedOnly) return false;
        }

        return true;
      }).toList(),
    );
  }

  @action
  void setSelectedDate(DateTime? date) {
    selectedDate = date;
  }

  @action
  void setShowUsedOnly(bool? value) {
    showUsedOnly = value;
  }

  @action
  Future<void> fetchFoodPasses([String? userId]) async {
    isLoading = true;
    errorMessage = null;

    try {
      final passes = await repository.getUserFoodPasses(userId: userId);
      allFoodPasses = ObservableList.of(passes);
    } catch (e) {
      errorMessage = 'Failed to load food passes: $e';
    } finally {
      isLoading = false;
    }
  }
}
