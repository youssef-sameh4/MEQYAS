import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meqyas/Api/PowerModel.dart';


class PowerFactorService {
  static const String _url =
      'https://meqyas-api.runasp.net/api/PowerFactor/run-analysis';

  /// POST بدون body (زي الـ curl: -d '')
  static Future<PowerFactorData> runAnalysis() async {
    final response = await http
        .post(
      Uri.parse(_url),
      headers: {'accept': '*/*'},
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      throw Exception('Server error (${response.statusCode})');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic>) {
      throw Exception('Unexpected response format');
    }

    final parsed = PowerFactorResponse.fromJson(json);
    if (!parsed.succeeded || parsed.data == null) {
      throw Exception(
        parsed.message.isEmpty ? 'Analysis failed' : parsed.message,
      );
    }
    return parsed.data!;
  }
}