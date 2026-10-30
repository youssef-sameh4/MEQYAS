
import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';

class WhatIfSimulatorScreen extends StatefulWidget {
  const WhatIfSimulatorScreen({super.key});

  @override
  State<WhatIfSimulatorScreen> createState() =>
      _WhatIfSimulatorScreenState();
}

class _WhatIfSimulatorScreenState extends State<WhatIfSimulatorScreen> {
  double _energyReduction = 20;
  double _offPeakShift = 50;
  double _productionChange = 0;

  static const Color _cyan = Color(0xFF16D9F5);
  static const Color _blue = Color(0xFF087CFF);
  static const Color _panel = Color(0xFF0D477F);
  static const Color _card = Color(0xFF0C3768);
  static const Color _border = Color(0xFF1762A3);
  static const Color _white = Color(0xFFF3F7FF);
  static const Color _muted = Color(0xFF9AB6D5);
  static const Color _green = Color(0xFF40E6BC);

  static const double _baseConsumption = 1240000;
  static const double _baseCost = 1972000;
  static const double _baseProduction = 850.0;

  double get _newConsumption {
    final reduction = _energyReduction / 100;
    final productionFactor = 1 + (_productionChange / 100);
    return _baseConsumption * (1 - reduction) * productionFactor;
  }

  double get _newCost {
    final consumptionSaving =
        _energyReduction / 100 * _baseCost;

    final shiftSaving = _offPeakShift / 100 * _baseCost * 0.08;

    final productionEffect =
        _productionChange / 100 * _baseCost;

    return (_baseCost -
        consumptionSaving -
        shiftSaving +
        productionEffect)
        .clamp(0, double.infinity);
  }

  double get _newProduction {
    return _baseProduction * (1 + _productionChange / 100);
  }

  double get _savedEnergy {
    return _baseConsumption - _newConsumption;
  }

  double get _savedCost {
    return _baseCost - _newCost;
  }

  String _formatNumber(double value) {
    return value.round().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );
  }

  void _resetParameters() {
    setState(() {
      _energyReduction = 20;
      _offPeakShift = 50;
      _productionChange = 0;
    });
  }

  void _saveScenario() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Scenario saved: ${_energyReduction.round()}% energy reduction',
        ),
        backgroundColor: _panel,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/photo_2026-10-17_13-24-57.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Adjust Parameters'),
                      const SizedBox(height: 8),

                      _buildSliderCard(
                        title: 'Reduce Energy Consumption',
                        value: _energyReduction,
                        min: 0,
                        max: 50,
                        suffix: '%',
                        minLabel: '0%',
                        maxLabel: '50%',
                        onChanged: (value) {
                          setState(() => _energyReduction = value);
                        },
                      ),

                      _buildSliderCard(
                        title: 'Shift Load to Off-Peak',
                        value: _offPeakShift,
                        min: 0,
                        max: 100,
                        suffix: '%',
                        minLabel: '0%',
                        maxLabel: '100%',
                        onChanged: (value) {
                          setState(() => _offPeakShift = value);
                        },
                      ),

                      _buildSliderCard(
                        title: 'Production Change',
                        value: _productionChange,
                        min: -20,
                        max: 20,
                        suffix: '%',
                        minLabel: '-20%',
                        maxLabel: '+20%',
                        onChanged: (value) {
                          setState(() => _productionChange = value);
                        },
                      ),

                      const SizedBox(height: 4),

                      _buildResultsCard(),

                      const SizedBox(height: 10),

                      _buildScenarioImpact(),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 37,
                        child: ElevatedButton(
                          onPressed: _saveScenario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'Save Scenario',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 7),

                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: OutlinedButton(
                          onPressed: _resetParameters,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _cyan,
                            side: const BorderSide(color: _border),
                            backgroundColor: const Color(0xFF082B4D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'Reset Parameters',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 80,)
            ],
          ),
        ),

      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'What-If Simulator',
                  style: TextStyle(
                    color: _white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              InkWell(
                onTap: _resetParameters,
                child: const Row(
                  children: [
                    Icon(Icons.refresh, color: _cyan, size: 15),
                    SizedBox(width: 2),
                    Text(
                      'Reset',
                      style: TextStyle(
                        color: _cyan,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 28, top: 2),
            child: Text(
              'Explore potential savings before taking action.',
              style: TextStyle(
                color: _muted,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _white,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required String suffix,
    required String minLabel,
    required String maxLabel,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF15599A),
            Color(0xFF0A315C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 0.6),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${value.round()}$suffix',
                style: const TextStyle(
                  color: _cyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SliderTheme(
            data: SliderThemeData(

              trackHeight: 5,
              activeTrackColor: _cyan,
              inactiveTrackColor: const Color(0xFF28517C),
              thumbColor: _cyan,
              overlayColor: _cyan.withOpacity(0.12),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 3.5,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 9,
              ),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minLabel,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 7,
                ),
              ),
              Text(
                maxLabel,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: _cyan, size: 12),
              SizedBox(width: 5),
              Text(
                'Simulation Results',
                style: TextStyle(
                  color: _white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            'Estimated savings and performance impact',
            style: TextStyle(color: _muted, fontSize: 7),
          ),

          const SizedBox(height: 8),

          _resultHeading('Energy Cost Savings'),
          const SizedBox(height: 3),
          Text(
            'EGP ${_formatNumber(_savedCost)}',
            style: const TextStyle(
              color: _green,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'Estimated reduction in energy cost',
            style: TextStyle(color: _muted, fontSize: 7),
          ),

          const SizedBox(height: 9),

          _resultHeading('Energy Consumption'),
          const SizedBox(height: 5),

          Row(
            children: [
              Expanded(
                child: _smallMetric(
                  'Current',
                  '${_formatNumber(_baseConsumption)} kWh',
                ),
              ),
              Expanded(
                child: _smallMetric(
                  'Scenario',
                  '${_formatNumber(_newConsumption)} kWh',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _resultHeading('Modeled Value Energy Cost'),
          const SizedBox(height: 5),

          Row(
            children: [
              Expanded(
                child: _smallMetric(
                  'Current',
                  'EGP ${_formatNumber(_baseCost)}',
                ),
              ),
              Expanded(
                child: _smallMetric(
                  'Scenario',
                  'EGP ${_formatNumber(_newCost)}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _resultHeading('Production'),
          const SizedBox(height: 5),

          Row(
            children: [
              Expanded(
                child: _smallMetric(
                  'Current',
                  '${_baseProduction.round()} Tons',
                ),
              ),
              Expanded(
                child: _smallMetric(
                  'Scenario',
                  '${_newProduction.toStringAsFixed(0)} Tons',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _smallMetric(
                  'Energy Intensity',
                  '${(_newConsumption / _newProduction).toStringAsFixed(0)} kWh/Ton',
                ),
              ),
              Expanded(
                child: _smallMetric(
                  'Energy Saved',
                  '${_formatNumber(_savedEnergy)} kWh',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultHeading(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _muted,
        fontSize: 8,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _smallMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 7,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: _white,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScenarioImpact() {
    return Container(

      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF145DA5),
            Color(0xFF0A315B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: _cyan, size: 12),
              SizedBox(width: 5),
              Text(
                'Scenario Impact',
                style: TextStyle(
                  color: _white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          const Text(
            'Estimated energy savings',
            style: TextStyle(color: _muted, fontSize: 7),
          ),
          const SizedBox(height: 2),

          Text(
            '${_formatNumber(_savedEnergy)} kWh',
            style: const TextStyle(
              color: _white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Estimated cost reduction',
            style: TextStyle(color: _muted, fontSize: 7),
          ),
          const SizedBox(height: 2),

          Text(
            'EGP ${_formatNumber(_savedCost)}',
            style: const TextStyle(
              color: _white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Production Impact',
            style: TextStyle(color: _muted, fontSize: 7),
          ),
          const SizedBox(height: 2),

          Text(
            '${_productionChange >= 0 ? '+' : ''}${_productionChange.round()}% / ${_newProduction.toStringAsFixed(0)} Tons',
            style: const TextStyle(
              color: _white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
