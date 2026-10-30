import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meqyas/Widgets/home_navigation.dart';
import 'package:meqyas/feature/pages/Homepage.dart';
import 'dart:async';
const _bg = Color(0xFF04172D);
const _card = Color(0xFF0A2947);
const _cyan = Color(0xFF00D9E9);
const _blue = Color(0xFF1688FF);
const _white = Color(0xFFF2F7FF);
const _muted = Color(0xFF829DB9);
const _green = Color(0xFF27D9A0);

class FactoryInfo {
  final String name;
  final String location;
  final String? id;
  final String? code;
  final bool isFromApi;
  final String industry;
  final String energy;
  final String production;
  final String cost;
  final String status;
  final IconData icon;
  final List<Color> colors;

  const FactoryInfo({
    required this.name,
    required this.location,
    this.id,
    this.code,
    this.isFromApi = false,
    required this.industry,
    required this.energy,
    required this.production,
    required this.cost,
    required this.status,
    required this.icon,
    required this.colors,
  });
}


const _demoTemplate = FactoryInfo(
  name: '',
  location: '',
  industry: 'Food & Beverages',
  energy: '1,240 kWh',
  production: '850',
  cost: '72,150 EGP',
  status: 'Connected',
  icon: Icons.factory_outlined,
  colors: [Color(0xFF315F75), Color(0xFF102B42)],
);

class YourFactories extends StatefulWidget {
  const YourFactories({super.key});

  @override
  State<YourFactories> createState() => _YourFactoriesState();
}

class _YourFactoriesState extends State<YourFactories> {
  int selectedIndex = 0;
  String query = '';
  bool isLoading = true;
  String? loadError;
  List<FactoryInfo> factories = [];

  @override
  void initState() {
    super.initState();
    _loadFactories();
  }

  Future<void> _loadFactories() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });

    try {
      final response = await http
          .get(
        Uri.parse('https://meqyas-api.runasp.net/api/Factories'),
        headers: {'accept': '*/*'},
      )
          .timeout(const Duration(seconds: 45));

      debugPrint('Factories status: ${response.statusCode}');
      debugPrint('Factories body: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Server returned ${response.statusCode}');
      }

      final body =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (body['succeeded'] != true) {
        throw Exception(body['message']?.toString() ?? 'Request failed');
      }

      final items = body['data'] as List<dynamic>? ?? [];
      final apiFactories = items
          .map((item) => item as Map<String, dynamic>)
          .where((item) =>
      (item['name']?.toString().trim().toLowerCase() ?? '') != 'test')
          .toList();

      final loaded = <FactoryInfo>[];
      for (final item in apiFactories) {
        final template = _demoTemplate;
        loaded.add(FactoryInfo(
          id: item['id']?.toString(),
          code: item['code']?.toString(),
          isFromApi: true,
          name: item['name']?.toString() ?? '',
          location: item['address']?.toString() ?? '',
          industry: template.industry,
          energy: template.energy,
          production: template.production,
          cost: template.cost,
          status: template.status,
          icon: template.icon,
          colors: template.colors,
        ));
      }

      if (!mounted) return;
      setState(() {
        factories = loaded;
        selectedIndex = 0;
        isLoading = false;
      });
    } on TimeoutException {
      _setError('The server is taking too long to respond. Tap Retry.');
    } catch (e, st) {
      debugPrint('Factories error: $e\n$st');
      _setError('Could not load factories.\n$e');
    }
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      loadError = message;
      isLoading = false;
    });
  }

  List<FactoryInfo> get visibleFactories {
    return factories.where((factory) {
      return factory.name.toLowerCase().contains(query.toLowerCase()) ||
          factory.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF061B33), Color(0xFF031329), Color(0xFF061B31)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 7),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF168EFF), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/MEQYAS_logo_transparent 1.png",height: 36,
                      width: 135,),
                    const SizedBox(height: 12),
                    const SizedBox(height: 15),

                    const Text(
                      'Select Your Factory',
                      style: TextStyle(
                        color: _white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Choose the factory you want to monitor and analyze its '
                          'energy performance.',
                      style: TextStyle(color: _muted, fontSize: 9, height: 1.4),
                    ),

                    const SizedBox(height: 11),


                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF071D34),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF294762),
                              ),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() => query = value);
                              },
                              style: const TextStyle(
                                color: _white,
                                fontSize: 10,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search factories...',
                                hintStyle: TextStyle(
                                  color: _muted,
                                  fontSize: 9,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: _muted,
                                  size: 15,
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 29,
                                  minHeight: 30,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 7,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _card,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF294762)),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() => query = '');
                            },
                            icon: const Icon(
                              Icons.tune,
                              color: _cyan,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 11),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your factories',
                          style: TextStyle(
                            color: _white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${visibleFactories.length} factories',
                          style: const TextStyle(color: _muted, fontSize: 7),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),


                    Expanded(
                      child: isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: _cyan,
                          strokeWidth: 2,
                        ),
                      )
                          : visibleFactories.isEmpty
                          ? Center(
                        child: Text(
                          loadError ?? 'No factories found',
                          style: const TextStyle(color: _muted, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 5),
                        itemCount: visibleFactories.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final factory = visibleFactories[index];
                          final originalIndex = factories.indexOf(factory);

                          return _FactoryCard(
                            factory: factory,
                            selected: selectedIndex == originalIndex,
                            onTap: () {
                              setState(() {
                                selectedIndex = originalIndex;
                              });
                            },
                          );
                        },
                      ),
                    ),

                    if (loadError != null) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _loadFactories,
                          child: const Text('Retry'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 5),

                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: _cyan, size: 11),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'You can change your selected factory later from '
                                'the dashboard.',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 7,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: isLoading || factories.isEmpty ? null : () {
                          final factory = factories[selectedIndex];

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HomeNavigation(
                                factoryName: factory.name,
                                factoryAddress: factory.location,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Spacer(),
                            Text(
                              'Continue to Dashboard',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios, size: 11),
                            Spacer(),
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
      ),
    );
  }
}

class _PhoneStatusBar extends StatelessWidget {
  const _PhoneStatusBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '9:41',
          style: TextStyle(
            color: _white,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Icon(Icons.signal_cellular_alt, color: _white, size: 10),
            SizedBox(width: 3),
            Icon(Icons.wifi, color: _white, size: 10),
            SizedBox(width: 3),
            Icon(Icons.battery_full, color: _white, size: 12),
          ],
        ),
      ],
    );
  }
}

class _FactoryCard extends StatelessWidget {
  final FactoryInfo factory;
  final bool selected;
  final VoidCallback onTap;

  const _FactoryCard({
    required this.factory,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final warning = factory.status == 'Needs Attention';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF103652) : const Color(0xFF092541),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? _cyan : const Color(0xFF25435E),
              width: selected ? 1.1 : 0.7,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail placeholder
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: factory.colors,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      factory.icon,
                      color: const Color(0xFFC3E6F5),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          factory.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          factory.location,
                          style: const TextStyle(color: _muted, fontSize: 7),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          factory.industry,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _muted, fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selected ? _cyan : _muted,
                    size: 15,
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Row(
                children: [
                  Icon(
                    warning ? Icons.warning_amber : Icons.circle,
                    color: warning ? Colors.orangeAccent : _green,
                    size: 7,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    factory.status,
                    style: TextStyle(
                      color: warning ? Colors.orangeAccent : _green,
                      fontSize: 7,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.bolt, color: _cyan, size: 10),
                  const SizedBox(width: 2),
                  const Text(
                    'Energy data',
                    style: TextStyle(color: _muted, fontSize: 7),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              const Divider(
                color: Color(0xFF24435E),
                height: 1,
                thickness: 0.6,
              ),

              const SizedBox(height: 7),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _FactoryMetric(
                      title: 'Energy',
                      value: factory.energy,
                    ),
                  ),
                  Expanded(
                    child: _FactoryMetric(
                      title: 'Production',
                      value: factory.production,
                    ),
                  ),
                  Expanded(
                    child: _FactoryMetric(
                      title: 'Energy cost',
                      value: factory.cost,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FactoryMetric extends StatelessWidget {
  final String title;
  final String value;

  const _FactoryMetric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 7),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _white,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

