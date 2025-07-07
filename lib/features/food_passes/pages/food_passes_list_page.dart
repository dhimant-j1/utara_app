import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:utara_app/core/models/food_pass.dart';
import 'package:utara_app/features/food_passes/food_passes_store.dart';
import 'package:utara_app/features/food_passes/repository/food_pass_repository.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import 'package:utara_app/features/users/repository/user_repository.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class FoodPassesListPage extends StatefulWidget {
  final String? userId;

  const FoodPassesListPage({
    super.key,
    this.userId,
  });

  @override
  State<FoodPassesListPage> createState() => _FoodPassesListPageState();
}

class _FoodPassesListPageState extends State<FoodPassesListPage> {
  List<Map<String, dynamic>>? users;
  String? selectedUserId;
  bool isLoadingUsers = false;
  late final FoodPassesStore foodPassesStore;

  @override
  void initState() {
    super.initState();
    final authStore = getIt<AuthStore>();
    if (authStore.isAdmin || authStore.isStaff) {
      _loadUsers();
    }
    selectedUserId = widget.userId;
    foodPassesStore = FoodPassesStore(FoodPassRepository())
      ..fetchFoodPasses(selectedUserId);
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoadingUsers = true;
    });
    try {
      final userRepository = UserRepository(getIt());
      users = await userRepository.getUsers();
    } catch (e) {
      // Handle error
      print('Error loading users: $e');
    } finally {
      setState(() {
        isLoadingUsers = false;
      });
    }
  }

  IconData _getMealTypeIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStore = getIt<AuthStore>();

    return Provider<FoodPassesStore>.value(
      value: foodPassesStore,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              selectedUserId != null ? 'User Food Passes' : 'My Food Passes'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
          actions: [
            if (authStore.isAdmin || authStore.isStaff) ...[
              if (isLoadingUsers)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DropdownButton<String>(
                    value: selectedUserId,
                    hint: const Text('Select User'),
                    items: [
                      if (users != null)
                        ...users!.map((user) => DropdownMenuItem<String>(
                              value: user['id'] as String,
                              child: Text(user['name'] as String),
                            )),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        selectedUserId = value;
                      });
                      foodPassesStore.fetchFoodPasses(value);
                    },
                  ),
                ),
            ],
            Observer(
              builder: (context) {
                final store = Provider.of<FoodPassesStore>(context);
                return IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: store.selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      store.setSelectedDate(date);
                    }
                  },
                );
              },
            ),
            Observer(
              builder: (context) {
                final store = Provider.of<FoodPassesStore>(context);
                return PopupMenuButton<bool?>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: store.setShowUsedOnly,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All Passes'),
                    ),
                    const PopupMenuItem(
                      value: false,
                      child: Text('Unused Only'),
                    ),
                    const PopupMenuItem(
                      value: true,
                      child: Text('Used Only'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Observer(
          builder: (context) {
            final store = Provider.of<FoodPassesStore>(context);

            if (store.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (store.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      store.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => store.fetchFoodPasses(selectedUserId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (store.foodPasses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.no_meals, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      store.selectedDate != null || store.showUsedOnly != null
                          ? 'No food passes found with current filters'
                          : 'No food passes found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (store.selectedDate != null ||
                        store.showUsedOnly != null) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          store.setSelectedDate(null);
                          store.setShowUsedOnly(null);
                        },
                        child: const Text('Clear Filters'),
                      ),
                    ],
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: store.foodPasses.length,
              itemBuilder: (context, index) {
                final pass = store.foodPasses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(
                      _getMealTypeIcon(pass.mealType),
                      color: pass.isUsed ? Colors.grey : Colors.green,
                      size: 32,
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${pass.mealType.name.toUpperCase()} - ${pass.memberName}',
                          style: TextStyle(
                            decoration:
                                pass.isUsed ? TextDecoration.lineThrough : null,
                            color: pass.isUsed ? Colors.grey : null,
                          ),
                        ),
                        if (pass.isUsed)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.check_circle,
                                color: Colors.grey, size: 16),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('EEEE, MMMM d, y').format(pass.date)),
                        if (pass.isUsed && pass.usedAt != null)
                          Text(
                            'Used on ${DateFormat('MMM d, y h:mm a').format(pass.usedAt!)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                    trailing: !pass.isUsed
                        ? const Icon(Icons.qr_code, color: Colors.blue)
                        : null,
                    onTap: !pass.isUsed
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Food Pass QR Code'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: pass.qrCode.startsWith(
                                              'data:image/png;base64,')
                                          ? Image.memory(
                                              base64Decode(
                                                  pass.qrCode.split(',')[1]),
                                              fit: BoxFit.contain,
                                            )
                                          : Image.network(pass.qrCode),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '${pass.mealType.name.toUpperCase()} - ${pass.memberName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(DateFormat('EEEE, MMMM d, y')
                                        .format(pass.date)),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
