import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utara_app/core/models/room_request.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';

import '../../../core/di/service_locator.dart';

class EditRoomRequestDialog extends StatefulWidget {
  final RoomRequest roomRequest;

  const EditRoomRequestDialog({super.key, required this.roomRequest});

  @override
  State<EditRoomRequestDialog> createState() => _EditRoomRequestDialogState();
}

class _EditRoomRequestDialogState extends State<EditRoomRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _repository = RoomRequestRepository(getIt());

  late DateTime _checkInDate;
  late DateTime _checkOutDate;

  late TextEditingController _maleController;
  late TextEditingController _femaleController;
  late TextEditingController _childrenController;

  late TextEditingController _placeController;
  late TextEditingController _purposeController;
  late TextEditingController _referenceController;
  late TextEditingController _specialRequestsController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkInDate = widget.roomRequest.checkInDate;
    _checkOutDate = widget.roomRequest.checkOutDate;

    _maleController = TextEditingController(
      text: widget.roomRequest.numberOfPeople.male.toString(),
    );
    _femaleController = TextEditingController(
      text: widget.roomRequest.numberOfPeople.female.toString(),
    );
    _childrenController = TextEditingController(
      text: widget.roomRequest.numberOfPeople.children.toString(),
    );

    _placeController = TextEditingController(text: widget.roomRequest.place);
    _purposeController = TextEditingController(
      text: widget.roomRequest.purpose,
    );
    _referenceController = TextEditingController(
      text: widget.roomRequest.reference,
    );
    _specialRequestsController = TextEditingController(
      text: widget.roomRequest.specialRequests,
    );
  }

  @override
  void dispose() {
    _maleController.dispose();
    _femaleController.dispose();
    _childrenController.dispose();
    _placeController.dispose();
    _purposeController.dispose();
    _referenceController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate.isBefore(_checkInDate)) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
          if (_checkOutDate.isBefore(_checkInDate)) {
            _checkInDate = _checkOutDate.subtract(const Duration(days: 1));
          }
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
      final male = int.tryParse(_maleController.text) ?? 0;
      final female = int.tryParse(_femaleController.text) ?? 0;
      final children = int.tryParse(_childrenController.text) ?? 0;

      final updatedRequest = await _repository.adminUpdateRoomRequest(
        requestId: widget.roomRequest.id,
        checkInDate: _checkInDate,
        checkOutDate: _checkOutDate,
        numberOfPeople: {
          'male': male,
          'female': female,
          'children': children,
          'total': male + female + children,
        },
        place: _placeController.text.trim(),
        purpose: _purposeController.text.trim(),
        reference: _referenceController.text.trim(),
        specialRequests: _specialRequestsController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop(updatedRequest);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update room request: $e')),
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
    return AlertDialog(
      title: const Text('Edit Room Request'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Check-in date
                ListTile(
                  title: const Text('Check-in Date'),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(_checkInDate),
                  ),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),

                // Check-out date
                ListTile(
                  title: const Text('Check-out Date'),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(_checkOutDate),
                  ),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),

                // Number of People
                const Text(
                  'Number of People',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _maleController,
                        decoration: const InputDecoration(
                          labelText: 'Male',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _femaleController,
                        decoration: const InputDecoration(
                          labelText: 'Female',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _childrenController,
                        decoration: const InputDecoration(
                          labelText: 'Children',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Place
                TextFormField(
                  controller: _placeController,
                  decoration: const InputDecoration(
                    labelText: 'Place',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Purpose
                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: 'Purpose',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Reference
                TextFormField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Special Requests
                TextFormField(
                  controller: _specialRequestsController,
                  decoration: const InputDecoration(
                    labelText: 'Special Requests',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
