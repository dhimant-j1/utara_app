import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

  static DateTime now = DateTime.now();
  DateTime? _checkInDate = now;
  final _checkInDateString = TextEditingController(
    text: DateFormat('MMM dd, yyyy').format(now),
  );

  DateTime? _checkOutDate = now.add(const Duration(days: 1));
  final _checkOutDateString = TextEditingController(
    text: DateFormat(
      'MMM dd, yyyy h:mm a',
    ).format(now.add(const Duration(days: 1))),
  );

  int _numberOfMale = 0;
  int _numberOfFemale = 0;
  int _numberOfChild = 0;
  int _numberOfPeople = 0;

  final _specialRequestsController = TextEditingController();
  final _referenceController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;

  static const List<String> places = ["Gondal Mandir, Akshar Deri"];
  String _selectedPlace = places.first;

  static const List<String> purposes = [
    "Asthi-Visharjan",
    "Darshan Only",
    "General Visit",
    "Mahapuja & Pradakshina",
    "Mahapuja",
    "Other",
    "Padyatra",
    "Pradakshina",
    "Satsang Pravrutti",
  ];
  String _selectedPurpose = purposes.first;

  File? _chitthiImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (_checkInDate ?? DateTime.now())
          : (_checkOutDate ??
                (_checkInDate?.add(const Duration(days: 1)) ??
                    DateTime.now().add(const Duration(days: 1)))),
      firstDate: isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (!isCheckIn) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_checkOutDate ?? DateTime.now()),
        );

        if (pickedTime != null) {
          setState(() {
            _checkOutDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            _checkOutDateString.text = DateFormat(
              'MMM dd, yyyy h:mm a',
            ).format(_checkOutDate!);
          });
        }
      } else {
        setState(() {
          _checkInDate = pickedDate;
          _checkInDateString.text = DateFormat(
            'MMM dd, yyyy',
          ).format(_checkInDate!);

          if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
            _checkOutDate = _checkInDate!.add(const Duration(days: 1));
            _checkOutDateString.text = DateFormat(
              'MMM dd, yyyy h:mm a',
            ).format(_checkOutDate!);
          }
        });
      }
    }
  }

  Future<void> _pickChitthiImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (picked != null) {
                  setState(() {
                    _chitthiImage = File(picked.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (picked != null) {
                  setState(() {
                    _chitthiImage = File(picked.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_numberOfPeople == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one person.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _roomRequestRepository.createRoomRequest(
        place: _selectedPlace,
        purpose: _selectedPurpose,
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        numberOfPeople: {
          "male": _numberOfMale,
          "female": _numberOfFemale,
          "children": _numberOfChild,
          "total": _numberOfPeople,
        },
        formName: _nameController.text.trim(),
        specialRequests: _specialRequestsController.text.trim(),
        reference: _referenceController.text.trim(),
        chitthiImagePath: _chitthiImage?.path,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room request created successfully!')),
      );
      context.pop(); // Go back to dashboard or list
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
        title: const Text('New Room Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              "Mandir / Place:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: places
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              value: _selectedPlace,
              onChanged: (value) => setState(() => _selectedPlace = value!),
            ),
            const SizedBox(height: 20),

            const Text(
              "Purpose of Visit:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: purposes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              value: _selectedPurpose,
              onChanged: (value) => setState(() => _selectedPurpose = value!),
            ),
            const SizedBox(height: 20),

            const Text(
              "Guest Name / Mandir Type:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter guest name or form name",
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter guest name'
                  : null,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Check-in Date:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _checkInDateString,
                        readOnly: true,
                        onTap: () => _selectDate(context, true),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Check-out Date:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _checkOutDateString,
                        readOnly: true,
                        onTap: () => _selectDate(context, false),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Number of People:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPeopleCounter("Male", _numberOfMale, (val) {
              setState(() {
                _numberOfMale = val;
                _numberOfPeople =
                    _numberOfMale + _numberOfFemale + _numberOfChild;
              });
            }),
            _buildPeopleCounter("Female", _numberOfFemale, (val) {
              setState(() {
                _numberOfFemale = val;
                _numberOfPeople =
                    _numberOfMale + _numberOfFemale + _numberOfChild;
              });
            }),
            _buildPeopleCounter("Children", _numberOfChild, (val) {
              setState(() {
                _numberOfChild = val;
                _numberOfPeople =
                    _numberOfMale + _numberOfFemale + _numberOfChild;
              });
            }),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total People:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "$_numberOfPeople",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Reference:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _referenceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Reference (Optional)",
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Special Requests:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _specialRequestsController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Special requests (Optional)",
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Chitthi Upload:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_chitthiImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _chitthiImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => setState(() => _chitthiImage = null),
                    ),
                  ),
                ],
              )
            else
              InkWell(
                onTap: _pickChitthiImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        "Upload Chitthi",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Submit Room Request",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleCounter(String label, int value, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                "$value",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    _referenceController.dispose();
    _nameController.dispose();
    _checkInDateString.dispose();
    _checkOutDateString.dispose();
    super.dispose();
  }
}
