import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meqyas/feature/pages/Your_factories.dart';

const Color _bg = Color(0xFF071F3A);
const Color _panel = Color(0xFF071F3A);
const Color _field = Color(0xFF0A2948);
const Color _border = Color(0xFF174773);
const Color _blue = Color(0xFF087CFF);
const Color _cyan = Color(0xFF00D9EA);
const Color _white = Color(0xFFF1F6FF);
const Color _muted = Color(0xFF8CA6C0);

enum DataSource { excel, manual, smartMeters }

class ProductionInformation extends StatefulWidget {
  const ProductionInformation({super.key});

  @override
  State<ProductionInformation> createState() =>
      _ProductionInformationState();
}

class _ProductionInformationState extends State<ProductionInformation> {
  final _formKey = GlobalKey<FormState>();

  final _productController = TextEditingController();
  final _monthlyController = TextEditingController();
  final _hoursController = TextEditingController();
  final _daysController = TextEditingController();

  String? _selectedUnit;
  DataSource _dataSource = DataSource.excel;
  String? _fileName;

  final List<String> _units = [
    'Units',
    'Tons',
    'Kilograms',
    'Liters',
    'Packages',
    'Pieces',
  ];

  @override
  void dispose() {
    _productController.dispose();
    _monthlyController.dispose();
    _hoursController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFC0D0E0),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? suffix,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            inputFormatters: formatters,
            validator: _required,
            style: const TextStyle(
              color: _white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: _muted,
                fontSize: 13,
              ),
              suffixText: suffix,
              suffixStyle: const TextStyle(
                color: _muted,
                fontSize: 12,
              ),
              filled: true,
              fillColor: _field,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _cyan),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Production Unit *'),
          DropdownButtonFormField<String>(
            value: _selectedUnit,
            validator: (value) =>
            value == null ? 'Please select a unit' : null,
            dropdownColor: _panel,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: _muted,
            ),
            style: const TextStyle(
              color: _white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Select production unit',
              hintStyle: const TextStyle(
                color: _muted,
                fontSize: 13,
              ),
              filled: true,
              fillColor: _field,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _cyan),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Colors.redAccent),
              ),
            ),
            items: _units.map((unit) {
              return DropdownMenuItem<String>(
                value: unit,
                child: Text(unit),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedUnit = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _sourceOption({
    required DataSource value,
    required IconData icon,
    required String title,
    required String subtitle,
    bool comingSoon = false,
  }) {
    final selected = _dataSource == value;

    return InkWell(
      onTap: comingSoon
          ? null
          : () => setState(() => _dataSource = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF073A54)
              : const Color(0xFF09233D),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? _cyan : const Color(0xFF153858),
            width: selected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: comingSoon
                  ? _muted
                  : (selected ? _cyan : _white),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: comingSoon ? _muted : _white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                  if (comingSoon) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'Coming Soon',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (selected)
              const Icon(
                Icons.check_box,
                color: _cyan,
                size: 20,
              )
            else if (!comingSoon)
              const Icon(
                Icons.check_box_outline_blank,
                color: _muted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final FilePickerResult? result =
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
      );

      if (!mounted || result == null || result.files.isEmpty) {
        return;
      }

      setState(() {
        _fileName = result.files.first.name;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not select file: $e'),
        ),
      );
    }
  }

  void _save() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dataSource == DataSource.excel && _fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an Excel or CSV file'),
        ),
      );
      return;
    }

    if (_dataSource == DataSource.smartMeters) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => YourFactories(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              sliver: SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _panel,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _border,
                      width: 1,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.precision_manufacturing_outlined,
                              color: _cyan,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Production Information',
                                style: TextStyle(
                                  color: _white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(
                          color: _border,
                          height: 1,
                        ),
                        const SizedBox(height: 18),

                        _input(
                          label: 'Main Product *',
                          controller: _productController,
                          hint: 'Enter main product',
                        ),

                        _unitDropdown(),

                        _input(
                          label: 'Average Monthly Production',
                          controller: _monthlyController,
                          hint: 'Enter monthly production',
                          keyboard:
                          const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          formatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                        ),

                        _input(
                          label: 'Operating Hours per Day',
                          controller: _hoursController,
                          hint: 'Enter daily operating hours',
                          suffix: 'hours',
                          keyboard: TextInputType.number,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),

                        _input(
                          label: 'Operating Days per Month',
                          controller: _daysController,
                          hint: 'Enter working days',
                          suffix: 'days',
                          keyboard: TextInputType.number,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),

                        const SizedBox(height: 4),

                        const Row(
                          children: [
                            Icon(
                              Icons.table_chart_outlined,
                              color: _cyan,
                              size: 20,
                            ),
                            SizedBox(width: 9),
                            Text(
                              'Energy Data Source',
                              style: TextStyle(
                                color: _white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _sourceOption(
                          value: DataSource.excel,
                          icon: Icons.table_chart_outlined,
                          title: 'Excel / CSV Files',
                          subtitle:
                          'Upload historical energy data',
                        ),

                        _sourceOption(
                          value: DataSource.manual,
                          icon: Icons.edit_note,
                          title: 'Manual Entry',
                          subtitle:
                          'Enter energy readings manually.',
                        ),

                        _sourceOption(
                          value: DataSource.smartMeters,
                          icon: Icons.sensors,
                          title: 'Smart Meters / IoT',
                          subtitle:
                          'Connect compatible devices for live data.',
                          comingSoon: true,
                        ),

                        if (_dataSource == DataSource.excel) ...[
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: _pickFile,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 22,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF082642),
                                borderRadius:
                                BorderRadius.circular(8),
                                border: Border.all(color: _border),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    color: _cyan,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _fileName ?? 'Upload Energy Data',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: _white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Supported formats: XLSX, XLS, CSV',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _muted,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _field,
                                      borderRadius:
                                      BorderRadius.circular(6),
                                      border:
                                      Border.all(color: _border),
                                    ),
                                    child: const Text(
                                      'Choose File',
                                      style: TextStyle(
                                        color: _white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Save Factory & Continue',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
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
            ),
          ],
        ),
      ),
    );
  }
}