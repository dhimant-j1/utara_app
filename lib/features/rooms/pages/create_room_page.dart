import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utara_app/core/di/service_locator.dart';
import '../repository/room_repository.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _roomRepository = getIt<RoomRepository>();
  bool _isLoading = false;

  final _roomNumberController = TextEditingController();
  final _floorController = TextEditingController();
  String _type = 'STANDARD';
  final List<Map<String, dynamic>> _beds = [
    {'type': 'SINGLE', 'quantity': 1}
  ];
  bool _hasGeyser = false;
  bool _hasAc = false;
  bool _hasSofaSet = false;
  final _sofaSetQuantityController = TextEditingController();
  final _extraAmenitiesController = TextEditingController();
  bool _isVisible = true;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _roomRepository.createRoom(
        roomNumber: _roomNumberController.text,
        floor: int.parse(_floorController.text),
        type: _type,
        beds: _beds,
        hasGeyser: _hasGeyser,
        hasAc: _hasAc,
        hasSofaSet: _hasSofaSet,
        sofaSetQuantity:
            _hasSofaSet && _sofaSetQuantityController.text.isNotEmpty
                ? int.parse(_sofaSetQuantityController.text)
                : null,
        extraAmenities: _extraAmenitiesController.text.isNotEmpty
            ? _extraAmenitiesController.text
            : null,
        isVisible: _isVisible,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room created successfully!')),
      );
      context.go('/rooms');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create room: $e')),
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
  void dispose() {
    _roomNumberController.dispose();
    _floorController.dispose();
    _sofaSetQuantityController.dispose();
    _extraAmenitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/rooms'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _roomNumberController,
              decoration: const InputDecoration(
                labelText: 'Room Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter room number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _floorController,
              decoration: const InputDecoration(
                labelText: 'Floor',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter floor number';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Room Type',
                border: OutlineInputBorder(),
              ),
              value: _type,
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
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Beds',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _beds.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _beds[index]['type'] as String,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'SINGLE',
                                      child: Text('Single Bed'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'DOUBLE',
                                      child: Text('Double Bed'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'EXTRA_BED',
                                      child: Text('Extra Bed'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _beds[index]['type'] = value;
                                      });
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Bed Type',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  initialValue:
                                      _beds[index]['quantity'].toString(),
                                  decoration: const InputDecoration(
                                    labelText: 'Qty',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (int.tryParse(value) == null ||
                                        int.parse(value) < 1) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _beds[index]['quantity'] =
                                        int.tryParse(value) ?? 1;
                                  },
                                ),
                              ),
                              if (_beds.length > 1) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      _beds.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Bed'),
                      onPressed: () {
                        setState(() {
                          _beds.add({'type': 'SINGLE', 'quantity': 1});
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Has Geyser'),
                    value: _hasGeyser,
                    onChanged: (value) {
                      setState(() {
                        _hasGeyser = value ?? false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Has AC'),
                    value: _hasAc,
                    onChanged: (value) {
                      setState(() {
                        _hasAc = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text('Has Sofa Set'),
              value: _hasSofaSet,
              onChanged: (value) {
                setState(() {
                  _hasSofaSet = value ?? false;
                });
              },
            ),
            if (_hasSofaSet) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _sofaSetQuantityController,
                decoration: const InputDecoration(
                  labelText: 'Sofa Set Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sofa set quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _extraAmenitiesController,
              decoration: const InputDecoration(
                labelText: 'Extra Amenities',
                border: OutlineInputBorder(),
                hintText: 'Enter comma separated amenities',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Room is Visible'),
              subtitle:
                  const Text('Visible rooms can be seen by regular users'),
              value: _isVisible,
              onChanged: (value) {
                setState(() {
                  _isVisible = value ?? true;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Room'),
            ),
          ],
        ),
      ),
    );
  }
}
