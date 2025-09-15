import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/di/service_locator.dart';
import '../repository/room_request_repository.dart';

class CreateRoomRequestPage extends StatefulWidget {
  const CreateRoomRequestPage({super.key});

  @override
  State<CreateRoomRequestPage> createState() => _CreateRoomRequestPageState();
}

class _CreateRoomRequestPageState extends State<CreateRoomRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _roomRequestRepository = RoomRequestRepository(getIt());

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numberOfPeople = 1;
  String _preferredType = 'STANDARD';
  final _specialRequestsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? DateTime.now()
          : (_checkInDate?.add(const Duration(days: 1)) ??
              DateTime.now().add(const Duration(days: 1))),
      firstDate: isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
            _checkOutDate = _checkInDate!.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _roomRequestRepository.createRoomRequest(
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        numberOfPeople: _numberOfPeople,
        preferredType: _preferredType,
        specialRequests: _specialRequestsController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room request created successfully!')),
      );
      context.push('/room-requests');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create room request: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Check-in date picker
            ListTile(
              title: const Text('Check-in Date'),
              subtitle: Text(_checkInDate != null
                  ? DateFormat('MMM dd, yyyy').format(_checkInDate!)
                  : 'Not selected'),
              leading: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            if (_checkInDate == null)
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Please select a check-in date',
                    style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
            const SizedBox(height: 16),

            // Check-out date picker
            ListTile(
              title: const Text('Check-out Date'),
              subtitle: Text(_checkOutDate != null
                  ? DateFormat('MMM dd, yyyy').format(_checkOutDate!)
                  : 'Not selected'),
              leading: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            if (_checkOutDate == null)
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Please select a check-out date',
                    style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
            const SizedBox(height: 16),

            // Number of people
            Row(
              children: [
                const Text('Number of People'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _numberOfPeople > 1
                      ? () => setState(() => _numberOfPeople--)
                      : null,
                ),
                Text('$_numberOfPeople'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => _numberOfPeople++),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Room type dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Preferred Room Type',
                border: OutlineInputBorder(),
              ),
              value: _preferredType,
              items: const [
                DropdownMenuItem(
                  value: 'STANDARD',
                  child: Text('Standard Room'),
                ),
                DropdownMenuItem(
                  value: 'DELUXE',
                  child: Text('Deluxe Room'),
                ),
                DropdownMenuItem(
                  value: 'SUITE',
                  child: Text('Suite'),
                ),
                DropdownMenuItem(
                  value: 'FAMILY_ROOM',
                  child: Text('Family Room'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _preferredType = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Special requests
            TextField(
              controller: _specialRequestsController,
              decoration: const InputDecoration(
                labelText: 'Special Requests (Optional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed:
                  _isLoading || _checkInDate == null || _checkOutDate == null
                      ? null
                      : _submitForm,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Room Request'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }
}
