import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/service_controller.dart';
import '../../models/service_model.dart';

class AddServiceModal extends StatefulWidget {
  final ServiceModel? service;
  const AddServiceModal({super.key, this.service});

  @override
  _AddServiceModalState createState() => _AddServiceModalState();
}

class _AddServiceModalState extends State<AddServiceModal> {
  final _formKey = GlobalKey<FormState>();
  final ServiceController controller = Get.find<ServiceController>();

  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _availabilityController;
  late TextEditingController _imageUrlController;
  late TextEditingController _ratingController;
  late TextEditingController _durationController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _categoryController =
        TextEditingController(text: widget.service?.category ?? '');
    _priceController =
        TextEditingController(text: widget.service?.price.toString() ?? '');
    _availabilityController =
        TextEditingController(text: widget.service?.availability ?? '');
    _imageUrlController =
        TextEditingController(text: widget.service?.imageUrl ?? '');
    _ratingController =
        TextEditingController(text: widget.service?.rating.toString() ?? '');
    _durationController =
        TextEditingController(text: widget.service?.duration.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _availabilityController.dispose();
    _imageUrlController.dispose();
    _ratingController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.service == null ? 'Add New Service' : 'Edit Service',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                  _nameController, 'Service Name', Icons.text_fields),
              const SizedBox(height: 16),
              _buildTextField(_categoryController, 'Category', Icons.category),
              const SizedBox(height: 16),
              _buildTextField(_priceController, 'Price', Icons.attach_money,
                  isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_ratingController, 'Rating', Icons.star,
                  isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(
                  _availabilityController, 'Availability', Icons.access_time),
              const SizedBox(height: 16),
              _buildTextField(_imageUrlController, 'Image URL', Icons.image),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                    widget.service == null ? 'Add Service' : 'Update Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: TextEditingController(
          text: _selectedDate != null
              ? _selectedDate!.toLocal().toString().split(' ')[0]
              : ''),
      decoration: InputDecoration(
        labelText: 'Duration',
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      readOnly: true,
      onTap: () => _showDatePicker(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  void _showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                  _durationController.text = date.toString();
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false, bool isRating = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (isNumber && double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (isRating &&
            (double.tryParse(value) == null || double.tryParse(value)! > 100)) {
          return 'Please enter a valid rating';
        }
        return null;
      },
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> service = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'price': _priceController.text,
        'availability': _availabilityController.text,
        'imageUrl': _imageUrlController.text,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'duration': double.parse(_durationController.text),
        'rating': double.parse(_ratingController.text),
      };
      print(service);

      if (widget.service == null) {
        // Add new service logic
        // controller.addService(service);
      } else {
        // Update existing service logic
        // controller.updateService(service);
      }

      controller.fetchServices(); // Refresh the list
      Navigator.of(context).pop(); // Close the modal
    }
  }
}
