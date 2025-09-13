import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../stores/auth_store.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/signup_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/rooms/pages/room_list_page.dart';
import '../../features/rooms/pages/room_details_page.dart';
import '../../features/rooms/pages/create_room_page.dart';
import '../../features/rooms/pages/edit_room_page.dart';
import '../../features/rooms/pages/room_stats_page.dart';
import '../../features/room_requests/pages/room_requests_list_page.dart';
import '../../features/room_requests/pages/create_room_request_page.dart';
import '../../features/room_requests/pages/process_room_request_page.dart';
import '../../features/food_passes/pages/food_passes_list_page.dart';
import '../../features/food_passes/pages/generate_food_passes_page.dart';
import '../../features/food_passes/pages/scan_food_pass_page.dart';
import '../../features/food_passes/pages/food_pass_categories_page.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/users/pages/create_user_page.dart';
import '../../features/rooms/pages/bulk_upload_rooms_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final authStore = GetIt.instance<AuthStore>();
      final isAuthenticated = authStore.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login';
      }
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupPage(),
      ),

      // Dashboard route
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      // Profile route
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // Room routes
      GoRoute(
        path: '/rooms',
        builder: (context, state) => const RoomListPage(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreateRoomPage(),
          ),
          GoRoute(
            path: 'bulk-upload',
            builder: (context, state) => const BulkUploadRoomsPage(),
          ),
          GoRoute(
            path: 'stats',
            builder: (context, state) => const RoomStatsPage(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final roomId = state.pathParameters['id']!;
              return RoomDetailsPage(roomId: roomId);
            },
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final roomId = state.pathParameters['id']!;
                  return EditRoomPage(roomId: roomId);
                },
              ),
            ],
          ),
        ],
      ),

      // Room request routes
      GoRoute(
        path: '/room-requests',
        builder: (context, state) => const RoomRequestsListPage(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreateRoomRequestPage(),
          ),
          GoRoute(
            path: ':id/process',
            builder: (context, state) {
              final requestId = state.pathParameters['id']!;
              return ProcessRoomRequestPage(requestId: requestId);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/users/create',
        builder: (context, state) => const CreateUserPage(),
      ),

      // Food pass routes
      GoRoute(
        path: '/food-passes',
        builder: (context, state) {
          final authStore = GetIt.instance<AuthStore>();
          return FoodPassesListPage(userId: authStore.currentUser?.id);
        },
        routes: [
          GoRoute(
            path: 'generate',
            builder: (context, state) => const GenerateFoodPassesPage(),
          ),
          GoRoute(
            path: 'scan',
            builder: (context, state) => const ScanFoodPassPage(),
          ),
          GoRoute(
            path: 'categories',
            builder: (context, state) => const FoodPassCategoriesPage(),
          ),
          GoRoute(
            path: 'user/:userId',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return FoodPassesListPage(userId: userId);
            },
          ),
        ],
      ),
    ],
  );
}
