import 'package:get_it/get_it.dart';
import 'package:utara_app/features/food_passes/stores/food_pass_store.dart';
import 'package:utara_app/features/rooms/repository/room_repository.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../stores/auth_store.dart';
import '../../features/users/stores/user_store.dart';
import '../../features/users/repository/user_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<ApiService>()));

  // Repositories
  getIt.registerLazySingleton(() => RoomRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => UserRepository(getIt<ApiService>()));

  // Register AuthStore first without initialization
  getIt.registerSingleton<AuthStore>(AuthStore(getIt<AuthService>()));

  // Initialize AuthStore after registration
  await getIt<AuthStore>().init();

  // Other stores
  getIt.registerLazySingleton<UserStore>(() => UserStore(getIt<UserRepository>()));
  getIt.registerLazySingleton<FoodPassStore>(() => FoodPassStore(getIt<ApiService>().dio));

  // Set up auth token interceptor
  // Note: This is a simplified version without MobX reaction
  // In a real app, you would set up proper reactive token management
  if (getIt<AuthStore>().token != null) {
    getIt<ApiService>().setAuthToken(getIt<AuthStore>().token);
  }
}
