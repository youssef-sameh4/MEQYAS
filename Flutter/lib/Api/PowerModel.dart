double _toDouble(dynamic v) =>
    v is num ? v.toDouble() : (double.tryParse('$v') ?? 0);

int _toInt(dynamic v) => v is num ? v.toInt() : (int.tryParse('$v') ?? 0);

enum RiskLevel { low, medium, high }

/// قراءة واحدة من results
class PowerFactorResult {
  final String prediction;
  final bool isLowPfRisk;
  final double riskProbability;
  final double riskPercentage;
  final double thresholdUsed;
  final double actualPowerFactor;
  final double computedQpRatio;
  final String message;

  const PowerFactorResult({
    required this.prediction,
    required this.isLowPfRisk,
    required this.riskProbability,
    required this.riskPercentage,
    required this.thresholdUsed,
    required this.actualPowerFactor,
    required this.computedQpRatio,
    required this.message,
  });

  factory PowerFactorResult.fromJson(Map<String, dynamic> json) {
    return PowerFactorResult(
      prediction: (json['prediction'] ?? '').toString(),
      isLowPfRisk: json['is_low_pf_risk'] == true,
      riskProbability: _toDouble(json['risk_probability']),
      riskPercentage: _toDouble(json['risk_percentage']),
      thresholdUsed: _toDouble(json['threshold_used']),
      actualPowerFactor: _toDouble(json['actual_power_factor']),
      computedQpRatio: _toDouble(json['computed_q_p_ratio']),
      message: (json['message'] ?? '').toString(),
    );
  }

  /// مستوى الخطر (بيتحسب من النسبة)
  RiskLevel get level {
    if (riskPercentage >= 70) return RiskLevel.high;
    if (riskPercentage >= 50) return RiskLevel.medium;
    return RiskLevel.low;
  }
}

/// الـ data اللي جوه الرد
class PowerFactorData {
  final int totalReadings;
  final int lowPfRiskCount;
  final int normalCount;
  final double riskRatePct;
  final List<PowerFactorResult> results;

  const PowerFactorData({
    required this.totalReadings,
    required this.lowPfRiskCount,
    required this.normalCount,
    required this.riskRatePct,
    required this.results,
  });

  factory PowerFactorData.fromJson(Map<String, dynamic> json) {
    final list = json['results'];
    return PowerFactorData(
      totalReadings: _toInt(json['totalReadings']),
      lowPfRiskCount: _toInt(json['lowPfRiskCount']),
      normalCount: _toInt(json['normalCount']),
      riskRatePct: _toDouble(json['riskRatePct']),
      results: list is List
          ? list
          .whereType<Map<String, dynamic>>()
          .map(PowerFactorResult.fromJson)
          .toList()
          : <PowerFactorResult>[],
    );
  }

  double get avgPowerFactor => results.isEmpty
      ? 0
      : results.fold<double>(0, (s, r) => s + r.actualPowerFactor) /
      results.length;

  double get avgQpRatio => results.isEmpty
      ? 0
      : results.fold<double>(0, (s, r) => s + r.computedQpRatio) /
      results.length;
}

/// الرد الكامل من الـ API
class PowerFactorResponse {
  final int statusCode;
  final bool succeeded;
  final String message;
  final PowerFactorData? data;

  const PowerFactorResponse({
    required this.statusCode,
    required this.succeeded,
    required this.message,
    required this.data,
  });

  factory PowerFactorResponse.fromJson(Map<String, dynamic> json) {
    final d = json['data'];
    return PowerFactorResponse(
      statusCode: _toInt(json['statusCode']),
      succeeded: json['succeeded'] == true,
      message: (json['message'] ?? '').toString(),
      data: d is Map<String, dynamic> ? PowerFactorData.fromJson(d) : null,
    );
  }
}