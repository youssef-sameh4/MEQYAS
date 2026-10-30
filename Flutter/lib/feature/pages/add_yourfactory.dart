import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/feature/pages/Your_factories.dart';
import 'package:meqyas/feature/pages/energy_configuration.dart';

class AddFactoryScreen extends StatefulWidget {
  const AddFactoryScreen({super.key});

  @override
  State<AddFactoryScreen> createState() => _AddFactoryScreenState();
}

class _AddFactoryScreenState extends State<AddFactoryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _factoryCodeController = TextEditingController();
  final _factoryNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _linesController = TextEditingController();

  bool _isSubmitting = false;

  String? _industry;
  String? _country = 'Egypt';
  String? _city;

  final List<String> _industries = [
    'Food & Beverage',
    'Textile',
    'Chemical',
    'Cement',
    'Pharmaceutical',
    'Other',
  ];

  final List<String> _cities = [
    'Cairo',
    'Alexandria',
    'Mansoura',
    'Giza',
    'Tanta',
    'Other',
  ];

  @override
  void dispose() {
    _factoryCodeController.dispose();
    _factoryNameController.dispose();
    _addressController.dispose();
    _linesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Appcolor.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: Container(
                  width: double.infinity,
                  color: Appcolor.backgroundColor,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/MEQYAS_logo_transparent 1.png",  height: 36,
                          width: 135,),
                        // Header
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Add Your Factory',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const YourFactories(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0878F9),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'Set up your factory to start monitoring energy performance.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Factory information card
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight * 0.72,
                          ),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Appcolor.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Appcolor.blueColor.withOpacity(0.25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.factory_outlined,
                                    color: Appcolor.greenColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Factory Information',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              _label('Code *'),
                              _textField(
                                controller: _factoryCodeController,
                                hint: 'Enter your code',
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Factory code is required'
                                    : null,
                              ),

                              const SizedBox(height: 13),

                              _label('Factory Name *'),
                              _textField(
                                controller: _factoryNameController,
                                hint: 'Enter factory name',
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Factory name is required'
                                    : null,
                              ),

                              const SizedBox(height: 13),

                              _label('Industry Type *'),
                              _dropdown(
                                value: _industry,
                                hint: 'Select industry type',
                                items: _industries,
                                onChanged: (value) {
                                  setState(() => _industry = value);
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Industry type is required'
                                    : null,
                              ),

                              const SizedBox(height: 13),

                              _label('Country *'),
                              _dropdown(
                                value: _country,
                                hint: 'Select country',
                                items: const [
                                  'Egypt',
                                  'Saudi Arabia',
                                  'United Arab Emirates',
                                  'Other',
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _country = value;
                                    _city = null;
                                  });
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Country is required'
                                    : null,
                              ),

                              const SizedBox(height: 13),

                              _label('City *'),
                              _dropdown(
                                value: _city,
                                hint: 'Select city',
                                items: _cities,
                                onChanged: (value) {
                                  setState(() => _city = value);
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'City is required'
                                    : null,
                              ),

                              const SizedBox(height: 13),

                              _label('Factory Address *'),
                              _textField(
                                controller: _addressController,
                                hint: 'Enter factory address',
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Factory address is required'
                                    : null,
                              ),

                              const SizedBox(height: 13),

                              _label('Number of Production Lines'),
                              _textField(
                                controller: _linesController,
                                hint: 'Enter number of lines',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value != null &&
                                      value.trim().isNotEmpty) {
                                    final number = int.tryParse(value.trim());

                                    if (number == null || number < 1) {
                                      return 'Enter a valid number';
                                    }
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Next button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF168BFF), Color(0xFF0861E8)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _onNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isSubmitting ? 'Saving...' : 'Next',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 11),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 10),
        filled: true,
        fillColor: Appcolor.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 12,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF24517A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF24517A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Appcolor.blueColor),
        ),
        errorStyle: const TextStyle(fontSize: 9),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      validator: validator,
      onChanged: onChanged,
      dropdownColor: Appcolor.cardColor,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white60,
        size: 18,
      ),
      style: const TextStyle(color: Colors.white, fontSize: 11),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 10),
        filled: true,
        fillColor: Appcolor.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF24517A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF24517A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Appcolor.blueColor),
        ),
        errorStyle: const TextStyle(fontSize: 9),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
    );
  }

  Future<void> _onNext() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await http
          .post(
            Uri.parse('https://meqyas-api.runasp.net/api/Factories'),
            headers: {'accept': '*/*', 'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': _factoryNameController.text.trim(),
              'code': _factoryCodeController.text.trim(),
              'address': _addressController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 25));

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic>? result;

        if (response.body.isNotEmpty) {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            result = decoded;
          }
        }

        if (result != null && result['succeeded'] == false) {
          throw Exception(
            result['message']?.toString() ?? 'Could not save factory.',
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Factory saved successfully.')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EnergyConfiguration()),
        );
      } else {
        String message = 'Failed to save factory (${response.statusCode}).';

        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic> && decoded['message'] != null) {
            message = decoded['message'].toString();
          }
        } catch (_) {

        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not connect or save factory: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
