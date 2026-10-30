import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Alerts_Page extends StatefulWidget {
  const Alerts_Page({super.key });

  @override
  State<Alerts_Page> createState() => _AlertsPageState();
}




class _AlertsPageState extends State<Alerts_Page> {
  @override
  void initState() {
    super.initState();
    getAlerts();
  }
  List Posts=[];
  Future<void> getAlerts() async {

    const String apiUrl =
        'https://meqyas-api.runasp.net/api/EnergyAlerts/ai-anomalies';

    final url = Uri.parse(apiUrl);

    final response = await http.get(
      url,
    );


    final json = jsonDecode(response.body) as Map;

    if (json['data'] == null) {
      print("NO data FOUND");
      return;
    }

    final data = json['data'] as List;

    setState(() {
      Posts = data;
    });


  }

  String selectedFilter = 'All';
  String? selectedSort = 'Newest First';

  void changeFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061A32),
      body: SafeArea(
        
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 10, 13, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),

                    Text(
                      "Alerts",
                      style: TextStyle(
                        color: Color(0xFFF4F7FF),
                        fontSize: 24,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Stay informed about unusual energy patterns\ndetected by AI.',
                  style: TextStyle(
                    color: Color(0xFFA9BEDD),
                    fontSize: 16,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: AlertSummaryCard(
                        title: 'Active Alerts',
                        count: 1,
                        icon: Icons.notifications_none_rounded,

                        ContainersColor: const Color(0xFFFF315B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AlertSummaryCard(
                        title: 'Active Alerts',
                        count: 1,
                        icon: Icons.format_list_bulleted_rounded,

                        ContainersColor: const Color(0xFF9BC8F5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AlertSummaryCard(
                        title: 'Active Alerts',
                        count: 0,
                        icon: Icons.check_circle_outline_rounded,

                        ContainersColor: const Color(0xFF25E5C1),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF032440),
                        border: Border.all(color: const Color(0xFF075078)),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        children: [
                          Filterbutton(
                            txt: 'All',
                            onTap: () => changeFilter('All'),
                            selectedFilter: selectedFilter,
                            count: 1,
                          ),
                          Filterbutton(
                            txt: 'Active',
                            onTap: () => changeFilter('Active'),
                            selectedFilter: selectedFilter,
                            count: 1,
                          ),
                          Filterbutton(
                            txt: 'Resolved',
                            onTap: () => changeFilter('Resolved'),
                            selectedFilter: selectedFilter,
                            count: 0,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF032440),
                          border: Border.all(color: const Color(0xFF075078)),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSort,
                            dropdownColor: const Color(0xFF082B49),
                            icon: Expanded(
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFFA9BEDD),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Newest First',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      size: 17,
                                      color: Color(0xFFA9BEDD),
                                    ),
                                    SizedBox(width: 6),
                                    Text('Newest First'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Oldest First',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.history_rounded,
                                      size: 17,
                                      color: Color(0xFFA9BEDD),
                                    ),
                                    SizedBox(width: 6),
                                    Text('Oldest First'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => selectedSort = value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text(
                  'Alert History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Review and manage your energy alerts.',
                  style: TextStyle(color: Color(0xFF9EB4CC), fontSize: 12),
                ),

                SizedBox(height: 20),

                SizedBox(
                  height: 370,
                  child: ListView(
                    children: [
                      Material(
                        color: const Color(0xFF0E4778),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Color(0xFF0D3155),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                              ),
                              builder: (_) {
                                return AlertDetailsSheet();
                              },
                            );
                          },

                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border(
                                left: BorderSide(color: Colors.red, width: 3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.icecream_outlined,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        Posts.isNotEmpty ? Posts[0]['title'].toString() : 'Loading...',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFFB6C9DD),
                                      size: 19,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'kjfjjefkwjhfkhfw',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFD1E0EF),
                                    fontSize: 10,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 5,
                                  children: [
                                    StatusBadge(text: '', color: Colors.white),
                                    StatusBadge(
                                      text: 'kjddc',
                                      color: const Color(0xFFFF435B),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.analytics_outlined,
                                      color: Color(0xFFFFAD25),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'khjhh',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      child: Text(
                                        'fhgfhgfhf',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: Color(0xFFD1E0EF),
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Material(
                        color: const Color(0xFF0E4778),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Color(0xFF0D3155),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                              ),
                              builder: (_) {
                                return AlertDetailsSheet();
                              },
                            );
                          },

                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border(
                                left: BorderSide(color: Colors.red, width: 3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.icecream_outlined,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "ljlkj",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFFB6C9DD),
                                      size: 19,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'kjfjjefkwjhfkhfw',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFD1E0EF),
                                    fontSize: 10,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 5,
                                  children: [
                                    StatusBadge(text: '', color: Colors.white),
                                    StatusBadge(
                                      text: 'kjddc',
                                      color: const Color(0xFFFF435B),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.analytics_outlined,
                                      color: Color(0xFFFFAD25),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'khjhh',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      child: Text(
                                        'fhgfhgfhf',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: Color(0xFFD1E0EF),
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),   SizedBox(height: 20),

                      Material(
                        color: const Color(0xFF0E4778),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Color(0xFF0D3155),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                              ),
                              builder: (_) {
                                return AlertDetailsSheet();
                              },
                            );
                          },

                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border(
                                left: BorderSide(color: Colors.red, width: 3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.icecream_outlined,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "ljlkj",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFFB6C9DD),
                                      size: 19,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'kjfjjefkwjhfkhfw',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFD1E0EF),
                                    fontSize: 10,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 5,
                                  children: [
                                    StatusBadge(text: '', color: Colors.white),
                                    StatusBadge(
                                      text: 'kjddc',
                                      color: const Color(0xFFFF435B),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.analytics_outlined,
                                      color: Color(0xFFFFAD25),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'khjhh',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      child: Text(
                                        'fhgfhgfhf',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: Color(0xFFD1E0EF),
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),   SizedBox(height: 20),

                      Material(
                        color: const Color(0xFF0E4778),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Color(0xFF0D3155),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                              ),
                              builder: (_) {
                                return AlertDetailsSheet();
                              },
                            );
                          },

                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border(
                                left: BorderSide(color: Colors.red, width: 3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.icecream_outlined,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "ljlkj",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFFB6C9DD),
                                      size: 19,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'kjfjjefkwjhfkhfw',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFD1E0EF),
                                    fontSize: 10,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 5,
                                  children: [
                                    StatusBadge(text: '', color: Colors.white),
                                    StatusBadge(
                                      text: 'kjddc',
                                      color: const Color(0xFFFF435B),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.analytics_outlined,
                                      color: Color(0xFFFFAD25),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'khjhh',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      child: Text(
                                        'fhgfhgfhf',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: Color(0xFFD1E0EF),
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

      ),
    );
  }
}

class Filterbutton extends StatelessWidget {
  const Filterbutton({
    super.key,
    required this.txt,
    this.onTap,
    required this.selectedFilter,
    required this.count,
  });

  final String txt;
  final Function()? onTap;
  final String selectedFilter;
  final int count;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: selectedFilter == txt
            ? const Color(0xFF087CFF)
            : Colors.transparent,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 38,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  txt,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(width: 7),
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF245987),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "$count",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlertSummaryCard extends StatelessWidget {
  const AlertSummaryCard({
    super.key,
    required this.ContainersColor,
    required this.icon,
    required this.count,
    required this.title,
  });

  final Color ContainersColor;
  final IconData icon;
  final int count;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,

      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
      decoration: BoxDecoration(
        color: ContainersColor.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ContainersColor.withValues(alpha: 0.75)),
      ),

      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: ContainersColor.withValues(alpha: .16),
            child: Icon(
              Icons.import_contacts_sharp,
              color: Colors.white,
              size: 16,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFE1EAF8),
                  fontSize: 9,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$count',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  height: 0.95,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AlertDetailsSheet extends StatelessWidget {
  const AlertDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.65)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
//https://meqyas-api.runasp.net/swagger/index.html