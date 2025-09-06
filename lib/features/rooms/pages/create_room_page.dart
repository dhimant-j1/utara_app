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
  String _type = 'SHREEHARIPLUS';
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
      context.pop();
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

  Widget _buildFormContent(BoxConstraints constraints) {
    // Responsive: Use a Card with a max width on wide screens
    final isWide = constraints.maxWidth > 600;
    final form = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isWide ? 500 : double.infinity,
        ),
        child: Card(
          elevation: 4,
          margin:
              EdgeInsets.symmetric(vertical: 24, horizontal: isWide ? 0 : 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Room Number & Floor in a Row on wide screens
                  isWide
                      ? Row(
                          children: [
                            Expanded(child: _roomNumberField()),
                            const SizedBox(width: 16),
                            Expanded(child: _floorField()),
                          ],
                        )
                      : Column(
                          children: [
                            _roomNumberField(),
                            const SizedBox(height: 16),
                            _floorField(),
                          ],
                        ),
                  const SizedBox(height: 16),
                  _roomTypeField(),
                  const SizedBox(height: 16),
                  _bedsCard(),
                  const SizedBox(height: 16),
                  _amenitiesRow(isWide),
                  _sofaSetField(),
                  const SizedBox(height: 16),
                  _extraAmenitiesField(),
                  const SizedBox(height: 16),
                  _visibilityField(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(_isLoading ? 'Creating...' : 'Create Room'),
                      ),
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return form;
  }

  Widget _roomNumberField() {
    return TextFormField(
      controller: _roomNumberController,
      decoration: const InputDecoration(
        labelText: 'Room Number',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.meeting_room_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter room number';
        }
        return null;
      },
    );
  }

  Widget _floorField() {
    return TextFormField(
      controller: _floorController,
      decoration: const InputDecoration(
        labelText: 'Floor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.layers_outlined),
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
    );
  }

  Widget _roomTypeField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Room Type',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category_outlined),
      ),
      value: _type,
      items: const [
        DropdownMenuItem(
          value: 'SHREEHARIPLUS',
          child: Text('Shree Hari Plus'),
        ),
        DropdownMenuItem(
          value: 'SHREEHARI',
          child: Text('Shree Hari'),
        ),
        DropdownMenuItem(
          value: 'SARJUPLUS',
          child: Text('Sarju Plus'),
        ),
        DropdownMenuItem(
          value: 'SARJU',
          child: Text('Sarju'),
        ),
        DropdownMenuItem(
          value: 'NEELKANTHPLUS',
          child: Text('Neelkanth Plus'),
        ),
        DropdownMenuItem(
          value: 'NEELKANTH',
          child: Text('Neelkanth'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _type = value);
        }
      },
    );
  }

  Widget _bedsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beds',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        width: 90,
                        child: TextFormField(
                          initialValue: _beds[index]['quantity'].toString(),
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
                            _beds[index]['quantity'] = int.tryParse(value) ?? 1;
                          },
                        ),
                      ),
                      if (_beds.length > 1) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.redAccent),
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
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Bed'),
                onPressed: () {
                  setState(() {
                    _beds.add({'type': 'SINGLE', 'quantity': 1});
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amenitiesRow(bool isWide) {
    return isWide
        ? Row(
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
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
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
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Has Sofa Set'),
                  value: _hasSofaSet,
                  onChanged: (value) {
                    setState(() {
                      _hasSofaSet = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          )
        : Column(
            children: [
              CheckboxListTile(
                title: const Text('Has Geyser'),
                value: _hasGeyser,
                onChanged: (value) {
                  setState(() {
                    _hasGeyser = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Has AC'),
                value: _hasAc,
                onChanged: (value) {
                  setState(() {
                    _hasAc = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Has Sofa Set'),
                value: _hasSofaSet,
                onChanged: (value) {
                  setState(() {
                    _hasSofaSet = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          );
  }

  Widget _sofaSetField() {
    if (!_hasSofaSet) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _sofaSetQuantityController,
        decoration: const InputDecoration(
          labelText: 'Sofa Set Quantity',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.event_seat_outlined),
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
    );
  }

  Widget _extraAmenitiesField() {
    return TextFormField(
      controller: _extraAmenitiesController,
      decoration: const InputDecoration(
        labelText: 'Extra Amenities',
        border: OutlineInputBorder(),
        hintText: 'Enter comma separated amenities',
        prefixIcon: Icon(Icons.add_box_outlined),
      ),
      maxLines: 2,
    );
  }

  Widget _visibilityField() {
    return CheckboxListTile(
      title: const Text('Room is Visible'),
      subtitle: const Text('Visible rooms can be seen by regular users'),
      value: _isVisible,
      onChanged: (value) {
        setState(() {
          _isVisible = value ?? true;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: AppBar(
          title: const Text('Create Room'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: _buildFormContent(constraints),
        ),
      ),
    );
  }
}
