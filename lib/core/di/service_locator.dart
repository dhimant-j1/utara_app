import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../stores/auth_store.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<ApiService>()));

  // Stores
  final authStore = AuthStore(getIt<AuthService>());
  await authStore.init();
  getIt.registerSingleton<AuthStore>(authStore);

  // Set up auth token interceptor
  // Note: This is a simplified version without MobX reaction
  // In a real app, you would set up proper reactive token management
  if (authStore.token != null) {
    getIt<ApiService>().setAuthToken(authStore.token);
  }
} 