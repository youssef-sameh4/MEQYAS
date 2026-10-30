
import 'package:flutter/material.dart';
import 'package:meqyas/feature/pages/production_information.dart';

const Color _background = Color(0xFF071F3A);
const Color _panel = Color(0xFF071F3A);
const Color _field = Color(0xFF0A2948);
const Color _border = Color(0xFF174773);
const Color _blue = Color(0xFF087CFF);
const Color _cyan = Color(0xFF00D9EA);
const Color _text = Color(0xFFF1F6FF);
const Color _muted = Color(0xFF8CA6C0);

class EnergyConfiguration extends StatefulWidget {
  const EnergyConfiguration({super.key});

  @override
  State<EnergyConfiguration> createState() =>
      _EnergyConfigurationState();
}

class _EnergyConfigurationState extends State<EnergyConfiguration> {
  final _formKey = GlobalKey<FormState>();

  final _tariffController = TextEditingController();
  final _currencyController = TextEditingController(text: 'EGP');
  final _unitController = TextEditingController(text: 'EGP / kWh');
  final _consumptionController = TextEditingController();
  final _costController = TextEditingController();

  String? _selectedSource;

  final List<String> _energySources = [
    'Electricity',
    'Solar Energy',
    'Natural Gas',
    'Diesel',
    'Other',
  ];

  @override
  void dispose() {
    _tariffController.dispose();
    _currencyController.dispose();
    _unitController.dispose();
    _consumptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFC0D0E0),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          SizedBox(
            height: 35,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: required ? _requiredValidator : null,
              style: const TextStyle(
                color: _text,
                fontSize: 10,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                ),
                suffixText: suffix,
                suffixStyle: const TextStyle(
                  color: _muted,
                  fontSize: 9,
                ),
                filled: true,
                fillColor: _field,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 8,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: _border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: _cyan,
                    width: 1,
                  ),
                ),
                errorStyle: const TextStyle(
                  fontSize: 8,
                  height: 0.8,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourceDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Main Energy Source *'),
          SizedBox(
            height: 35,
            child: DropdownButtonFormField<String>(
              value: _selectedSource,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an energy source';
                }
                return null;
              },
              dropdownColor: _panel,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: _muted,
                size: 16,
              ),
              style: const TextStyle(
                color: _text,
                fontSize: 10,
              ),
              decoration: InputDecoration(
                hintText: 'Select energy source',
                hintStyle: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                ),
                filled: true,
                fillColor: _field,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: _border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: _cyan),
                ),
                errorStyle: const TextStyle(
                  fontSize: 8,
                  height: 0.8,
                ),
              ),
              items: _energySources.map((source) {
                return DropdownMenuItem<String>(
                  value: source,
                  child: Text(source),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedSource = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    width: double.infinity,
                    color: _background,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Energy Configuration',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _panel,
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: _border,
                                width: 0.8,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.bolt,
                                        color: _cyan,
                                        size: 15,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Energy Configuration',
                                        style: TextStyle(
                                          color: _text,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),
                                  const Divider(
                                    color: _border,
                                    height: 1,
                                  ),
                                  const SizedBox(height: 12),

                                  _sourceDropdown(),

                                  _textField(
                                    label: 'Electricity Tariff *',
                                    controller: _tariffController,
                                    hint: 'Enter electricity tariff',
                                    keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                  ),

                                  _textField(
                                    label: 'Currency',
                                    controller: _currencyController,
                                  ),

                                  _textField(
                                    label: 'Tariff Unit',
                                    controller: _unitController,
                                  ),

                                  _textField(
                                    label:
                                    'Monthly Average Energy Consumption',
                                    controller: _consumptionController,
                                    hint: 'Enter consumption',
                                    suffix: 'kWh',
                                    keyboardType: TextInputType.number,
                                  ),

                                  _textField(
                                    label:
                                    'Monthly Average Electricity Cost',
                                    controller: _costController,
                                    hint: 'Enter electricity cost',
                                    suffix: 'EGP',
                                    keyboardType: TextInputType.number,
                                  ),

                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0B3550),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: const Color(0xFF15516C),
                                      ),
                                    ),
                                    child: const Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: _cyan,
                                          size: 13,
                                        ),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Your electricity tariff is used to '
                                                'estimate financial impact of energy '
                                                'consumption.',
                                            style: TextStyle(
                                              color: _muted,
                                              fontSize: 9,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                SizedBox(height: 30,),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 36,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();

                                        if (_formKey.currentState!
                                            .validate()) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              const ProductionInformation(),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _blue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Next',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
}
