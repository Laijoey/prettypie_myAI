import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiDraftStore {
  AiDraftStore._();

  static final AiDraftStore instance = AiDraftStore._();

  AiOcrResult? lastOcrResult;
  AiChatResponse? lastChatResponse;
  List<AiRecommendation> lastRecommendations = const [];
}

class AiChatResponse {
  AiChatResponse({
    required this.reply,
    required this.toolsUsed,
    required this.actionLabel,
    required this.actionRoute,
    required this.workflow,
  });

  final String reply;
  final List<String> toolsUsed;
  final String? actionLabel;
  final String? actionRoute;
  final Map<String, dynamic> workflow;

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(
      reply: (json['reply'] ?? '').toString(),
      toolsUsed: List<String>.from(json['toolsUsed'] ?? const <String>[]),
      actionLabel: json['action_label']?.toString(),
      actionRoute: json['action_route']?.toString(),
      workflow: Map<String, dynamic>.from(json['workflow'] ?? const {}),
    );
  }
}

class AiRecommendation {
  AiRecommendation({
    required this.service,
    required this.reason,
    required this.route,
    required this.priority,
  });

  final String service;
  final String reason;
  final String route;
  final String priority;

  factory AiRecommendation.fromJson(Map<String, dynamic> json) {
    return AiRecommendation(
      service: (json['service'] ?? '').toString(),
      reason: (json['reason'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      priority: (json['priority'] ?? 'low').toString(),
    );
  }
}

class AiOcrResult {
  AiOcrResult({
    required this.provider,
    required this.extracted,
    required this.fullName,
    required this.icNumber,
    required this.address,
    required this.income,
    required this.dob,
    required this.phone,
    required this.email,
    required this.gender,
    required this.nationality,
    required this.taxId,
    required this.employerName,
    required this.documentNumber,
    required this.autoFill,
  });

  final String provider;
  final Map<String, dynamic> extracted;
  final String? fullName;
  final String? icNumber;
  final String? address;
  final String? income;
  final String? dob;
  final String? phone;
  final String? email;
  final String? gender;
  final String? nationality;
  final String? taxId;
  final String? employerName;
  final String? documentNumber;
  final Map<String, dynamic> autoFill;

  factory AiOcrResult.fromJson(Map<String, dynamic> json) {
    final extracted = Map<String, dynamic>.from(json['extracted'] ?? const {});
    return AiOcrResult(
      provider: (json['provider'] ?? 'unknown').toString(),
      extracted: extracted,
      fullName: extracted['full_name']?.toString(),
      icNumber: extracted['ic_number']?.toString(),
      address: extracted['address']?.toString(),
      income: extracted['income']?.toString(),
      dob: extracted['dob']?.toString(),
      phone: extracted['phone']?.toString(),
      email: extracted['email']?.toString(),
      gender: extracted['gender']?.toString(),
      nationality: extracted['nationality']?.toString(),
      taxId: extracted['tax_id']?.toString(),
      employerName: extracted['employer_name']?.toString(),
      documentNumber: extracted['document_number']?.toString(),
      autoFill: Map<String, dynamic>.from(json['autoFill'] ?? const {}),
    );
  }
}

class AiService {
  AiService._();

  static final AiService instance = AiService._();

  static const String _configuredBaseUrl = String.fromEnvironment(
    'AI_API_BASE_URL',
    defaultValue: '',
  );

  List<String> _baseUrlCandidates() {
    final values = <String>[];
    final configured = _configuredBaseUrl.trim();
    if (configured.isNotEmpty) {
      values.add(configured);
    }

    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.isNotEmpty) {
        final scheme = Uri.base.scheme.isEmpty ? 'http' : Uri.base.scheme;
        values.add('$scheme://$host:5001');
        if (scheme != 'http') {
          values.add('http://$host:5001');
        }
      }
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          values.add('http://10.0.2.2:5001');
          break;
        default:
          break;
      }
      values.add('http://127.0.0.1:5001');
    }

    final deduped = <String>[];
    for (final value in values) {
      if (!deduped.contains(value)) {
        deduped.add(value);
      }
    }
    return deduped;
  }

  Uri _uri(String baseUrl, String path) => Uri.parse('$baseUrl$path');

  Map<String, dynamic> _sanitizeMap(Map<String, dynamic> value) {
    final sanitized = <String, dynamic>{};

    value.forEach((key, item) {
      sanitized[key] = _sanitizeValue(item);
    });

    return sanitized;
  }

  List<dynamic> _sanitizeList(List<dynamic> value) {
    return value.map(_sanitizeValue).toList();
  }

  dynamic _sanitizeValue(dynamic value) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }

    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }

    if (value is Map) {
      return _sanitizeMap(value.cast<String, dynamic>());
    }

    if (value is Iterable) {
      return _sanitizeList(value.toList());
    }

    try {
      return value.toString();
    } catch (_) {
      return null;
    }
  }

  Future<http.Response> _postJson(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final candidates = _baseUrlCandidates();
    Object? lastError;

    for (final baseUrl in candidates) {
      try {
        final response = await http
            .post(
              _uri(baseUrl, path),
              headers: const {'Content-Type': 'application/json'},
              body: jsonEncode(_sanitizeMap(payload)),
            )
            .timeout(const Duration(seconds: 20));

        if (response.statusCode == 404) {
          continue;
        }

        return response;
      } catch (error) {
        lastError = error;
      }
    }

    throw Exception(
      'Unable to reach AI service. Checked: ${candidates.join(', ')}. '
      'Set AI_API_BASE_URL to your running AI server endpoint. '
      'Last error: ${lastError ?? 'unknown'}',
    );
  }

  Future<AiChatResponse> chat({
    required String message,
    Map<String, dynamic>? userProfile,
  }) async {
    final response = await _postJson(
      '/chat',
      {
        'message': message,
        'userProfile': _sanitizeMap(userProfile ?? const {}),
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Chat request failed (${response.statusCode})');
    }

    return AiChatResponse.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }

  Future<List<AiRecommendation>> recommend({
    required int income,
    required int age,
    bool hasVehicle = false,
    String employmentStatus = 'unknown',
  }) async {
    final response = await _postJson(
      '/recommend',
      {
        'income': income,
        'age': age,
        'has_vehicle': hasVehicle,
        'employment_status': employmentStatus,
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Recommendation request failed (${response.statusCode})',
      );
    }

    final body = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    final recommendations =
        (body['recommendations'] as List<dynamic>? ?? const [])
            .map(
              (item) => AiRecommendation.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();

    return recommendations;
  }

  Future<AiOcrResult> extractDocument({
    required Uint8List bytes,
    required String mimeType,
  }) async {
    final response = await _postJson(
      '/ocr',
      {
        'imageBase64': base64Encode(bytes),
        'mimeType': mimeType,
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('OCR request failed (${response.statusCode})');
    }

    return AiOcrResult.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }
}