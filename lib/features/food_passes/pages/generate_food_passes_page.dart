import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../repository/food_pass_repository.dart';
import '../repository/food_pass_category_repository.dart';
import '../../../core/stores/auth_store.dart';
import '../../../core/models/food_pass_category.dart';
import '../../users/repository/user_repository.dart';

class GenerateFoodPassesPage extends StatefulWidget {
  const GenerateFoodPassesPage({super.key});

  @override
  State<GenerateFoodPassesPage> createState() => _GenerateFoodPassesPageState();
}

class _GenerateFoodPassesPageState extends State<GenerateFoodPassesPage> {
  final _formKey = GlobalKey<FormState>();
  final _memberNamesController = TextEditingController();
  final _authStore = GetIt.instance<AuthStore>();
  final _foodPassRepository = FoodPassRepository();
  final _userRepository = GetIt.instance<UserRepository>();
  final _foodPassCategoryRepository = FoodPassCategoryRepository();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  bool _isLoadingUsers = false;
  bool _isLoadingCategories = false;
  String? _errorMessage;
  String? _successMessage;
  String? _selectedUserId;
  String? _selectedCategoryId;
  List<Map<String, dynamic>> _users = [];
  List<FoodPassCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadCategories();
  }

  @override
  void dispose() {
    _memberNamesController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoadingUsers = true);
    try {
      final users = await _userRepository.getUsers();
      setState(() => _users = users);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load users: ${e.toString()}');
    } finally {
      setState(() => _isLoadingUsers = false);
    }
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoadingCategories = true);
    try {
      final categories = await _foodPassCategoryRepository.getAllCategories();
      setState(() => _categories = categories);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load categories: ${e.toString()}');
    } finally {
      setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _generateFoodPasses() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUserId == null) {
      setState(() => _errorMessage = 'Please select a user');
      return;
    }
    if (_selectedCategoryId == null) {
      setState(() => _errorMessage = 'Please select a food pass category');
      return;
    }
    if (_startDate == null || _endDate == null) {
      setState(() => _errorMessage = 'Please select both start and end dates');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final memberNames =
          _memberNamesController.text.split(',').map((name) => name.trim()).where((name) => name.isNotEmpty).toList();

      final selectedCategory = _categories.firstWhere((cat) => cat.id == _selectedCategoryId!);

      await _foodPassRepository.generateFoodPasses(
        userId: _selectedUserId!,
        memberNames: memberNames,
        startDate: _startDate!,
        endDate: _endDate!,
        diningHall: selectedCategory.buildingName,
        colorCode: selectedCategory.colorCode,
      );

      setState(() {
        _successMessage = 'Food passes generated successfully!';
        _selectedUserId = null;
        _selectedCategoryId = null;
        _memberNamesController.clear();
        _startDate = null;
        _endDate = null;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Food Passes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      const Row(
                        children: [
                          Icon(Icons.qr_code, size: 32, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            'Generate Food Passes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Success Message
                      if (_successMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _successMessage!,
                                  style: TextStyle(color: Colors.green.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Error Message
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // User Selection Dropdown
                      _isLoadingUsers
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButtonFormField<String>(
                              value: _selectedUserId,
                              decoration: const InputDecoration(
                                labelText: 'Select User',
                                prefixIcon: Icon(Icons.person),
                              ),
                              hint: const Text('Choose a user'),
                              items: _users.map((user) {
                                return DropdownMenuItem<String>(
                                  value: user['id'],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        user['name'] ?? 'Unknown',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        user['email'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedUserId = value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a user';
                                }
                                return null;
                              },
                            ),
                      const SizedBox(height: 16),

                      // Food Pass Category Selection Dropdown
                      _isLoadingCategories
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButtonFormField<String>(
                              value: _selectedCategoryId,
                              decoration: const InputDecoration(
                                labelText: 'Select Food Pass Category',
                                prefixIcon: Icon(Icons.category),
                              ),
                              hint: const Text('Choose a category'),
                              items: _categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category.id,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Color(
                                              int.parse('0xFF${category.colorCode.replaceAll('#', '')}') & 0xFFFFFFFF),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(category.buildingName),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedCategoryId = value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a food pass category';
                                }
                                return null;
                              },
                            ),
                      const SizedBox(height: 16),

                      // Member Names Field
                      TextFormField(
                        controller: _memberNamesController,
                        decoration: const InputDecoration(
                          labelText: 'Member Names',
                          hintText: 'Enter names separated by commas',
                          prefixIcon: Icon(Icons.group),
                          helperText: 'Example: John Doe, Jane Smith, Bob Wilson',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter at least one member name';
                          }
                          final names = value.split(',').map((name) => name.trim()).where((name) => name.isNotEmpty);
                          if (names.isEmpty) {
                            return 'Please enter valid member names';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Start Date Field
                      InkWell(
                        onTap: _selectStartDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _startDate != null
                                ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                : 'Select start date',
                            style: TextStyle(
                              color: _startDate != null ? null : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // End Date Field
                      InkWell(
                        onTap: _selectEndDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _endDate != null
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'Select end date',
                            style: TextStyle(
                              color: _endDate != null ? null : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Generate Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _generateFoodPasses,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Generate Food Passes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
