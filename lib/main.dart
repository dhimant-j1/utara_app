import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:utara_app/features/food_passes/stores/food_pass_store.dart';
import 'core/stores/auth_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await setupServiceLocator();

  runApp(const UtaraApp());
}

class UtaraApp extends StatelessWidget {
  const UtaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthStore>(create: (_) => GetIt.instance<AuthStore>()),
        Provider<FoodPassStore>(create: (_) => GetIt.instance<FoodPassStore>()),
      ],
      child: Consumer<AuthStore>(
        builder: (context, authStore, _) {
          return MaterialApp.router(
            title: 'Utara App',
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
