# Utara App - Flutter Frontend

A comprehensive Flutter application for managing rooms, room requests, and food passes, built according to the provided requirements and API specification.

## Features

### Authentication
- **Login Page**: Secure user authentication with email and password
- **Signup Page**: User registration with role-based access control
- **Profile Page**: Display user information and account management

### Dashboard
- **Role-based Navigation**: Different menu items based on user roles (SUPER_ADMIN, STAFF, USER)
- **Quick Actions**: Easy access to frequently used features
- **Management Section**: Admin/Staff only features
- **Administration Section**: Super Admin only features

### Room Management
- **Room List**: Browse available rooms with filtering capabilities
- **Room Details**: Detailed view of individual rooms
- **Create Room**: Add new rooms (Admin/Staff only)
- **Edit Room**: Modify existing room details (Admin/Staff only)
- **Room Statistics**: Analytics and statistics (Admin/Staff only)

### Room Requests
- **View Requests**: List of room requests with filtering
- **Create Request**: Submit new room requests
- **Process Requests**: Approve/reject requests (Admin/Staff only)

### Food Pass Management
- **View Food Passes**: List of food passes with filtering
- **Generate Passes**: Create food passes for users (Admin/Staff only)
- **Scan Passes**: Validate and mark passes as used (Admin/Staff only)

## Architecture

### Project Structure
```
lib/
├── core/
│   ├── di/                 # Dependency Injection
│   ├── models/             # Data Models
│   ├── routing/            # App Routing
│   ├── services/           # API Services
│   ├── stores/             # State Management (MobX)
│   └── theme/              # App Theme
├── features/
│   ├── auth/               # Authentication Pages
│   ├── dashboard/          # Dashboard Page
│   ├── profile/            # Profile Page
│   ├── rooms/              # Room Management Pages
│   ├── room_requests/      # Room Request Pages
│   └── food_passes/        # Food Pass Pages
└── main.dart               # App Entry Point
```

### Key Technologies
- **Flutter**: Cross-platform UI framework
- **MobX**: State management for reactive programming
- **GoRouter**: Declarative routing with authentication guards
- **GetIt**: Dependency injection container
- **Dio**: HTTP client for API communication
- **JSON Annotation**: Code generation for JSON serialization
- **Flutter Form Builder**: Advanced form handling and validation

### State Management
- **AuthStore**: Manages authentication state, user data, and permissions
- **Reactive UI**: Uses MobX observers for automatic UI updates
- **Persistent Storage**: Stores authentication tokens using SharedPreferences

### API Integration
- **Base URL**: Configurable API endpoint (default: http://localhost:61554)
- **Authentication**: Bearer token-based authentication
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Request Interceptors**: Automatic token attachment and logging

## User Roles & Permissions

### SUPER_ADMIN
- Full access to all features
- Can create accounts for any role
- Can manage rooms, requests, and food passes
- Access to analytics and statistics

### STAFF
- Can manage rooms and food passes
- Can process room requests
- Cannot create new user accounts
- Access to management features

### USER
- Can view available rooms
- Can create room requests
- Can view their own food passes
- Limited to user-specific features

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code (for JSON serialization and MobX):
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Configuration
- Update the API base URL in `lib/core/services/api_service.dart`
- Modify theme colors in `lib/core/theme/app_theme.dart`

## API Endpoints

The app integrates with the following API endpoints:

### Authentication
- `POST /auth/login` - User login
- `POST /auth/signup` - User registration
- `GET /profile` - Get user profile

### Rooms
- `GET /rooms` - List rooms with filtering
- `POST /rooms` - Create new room
- `GET /rooms/{id}` - Get room details
- `PUT /rooms/{id}` - Update room
- `GET /rooms/stats` - Room statistics

### Room Requests
- `GET /room-requests` - List room requests
- `POST /room-requests` - Create room request
- `PUT /room-requests/{id}/process` - Process request

### Food Passes
- `GET /food-passes/user/{userId}` - Get user's food passes
- `POST /food-passes/generate` - Generate food passes
- `POST /food-passes/scan` - Scan food pass

## Security Features

- **Route Guards**: Authentication-based navigation protection
- **Role-based Access**: UI elements shown/hidden based on user permissions
- **Token Management**: Secure storage and automatic token refresh
- **Input Validation**: Client-side form validation with server-side error handling

## UI/UX Features

- **Material Design 3**: Modern, consistent design language
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Layout**: Adapts to different screen sizes
- **Loading States**: Visual feedback during API calls
- **Error Handling**: User-friendly error messages and recovery options
- **Form Validation**: Real-time validation with helpful error messages

## Development Notes

### Code Generation
The app uses code generation for:
- JSON serialization (`*.g.dart` files)
- MobX store generation (`*.g.dart` files)

Run the following command when models or stores are modified:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing
Basic widget tests are included. For comprehensive testing, consider:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete user flows
- Mock services for API testing

### Future Enhancements
- Offline support with local database
- Push notifications for request updates
- QR code scanning for food passes
- Advanced filtering and search
- File upload for room images
- Real-time updates using WebSockets

## Contributing

1. Follow Flutter/Dart style guidelines
2. Add tests for new features
3. Update documentation for API changes
4. Use conventional commit messages

## License

This project is part of the Utara App ecosystem and follows the same licensing terms.
