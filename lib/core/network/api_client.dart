import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/storage.dart';

class ServerClient {
  static const int _timeout = 90;

  static Map<String, String> _buildHeaders({bool includeToken = true, bool useForm = false}) {
    final token = Store.userToken.trim();
    final headers = {
      "Content-Type": useForm ? "application/x-www-form-urlencoded" : "application/json",
      "Accept": "application/json",
      "country": "india",
    };
    if (includeToken && token.isNotEmpty) {
      headers["authorization"] = "Bearer $token";
    }
    return headers;
  }

  static Future<List> get(String url) async {
    final headers = _buildHeaders();
    log('GET → $url');
    try {
      final response = await http.get(Uri.parse(url), headers: headers).timeout(Duration(seconds: _timeout));
      debugPrint('GET response: ${response.statusCode} → ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      return [600, "No internet"];
    } catch (e) {
      return [600, e.toString()];
    }
  }

  static Future<List> post(String url, {Map<String, dynamic>? data, bool useForm = false}) async {
    final headers = _buildHeaders(useForm: useForm);
    final body = useForm ? data?.map((key, value) => MapEntry(key, value.toString())) : json.encode(data);

    log('POST → $url\nPayload: $data\nForm: $useForm');
    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(Duration(seconds: _timeout));
      debugPrint('POST response: ${response.statusCode} → ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      return [600, "No internet"];
    } catch (e) {
      return [600, e.toString()];
    }
  }

  static Future<List> put(String url, {Map<String, dynamic>? data, bool put = false}) async {
    final headers = _buildHeaders();
    final body = put ? json.encode(data) : null;
    log('PUT → $url\nPayload: $data');
    try {
      final response = await http
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(Duration(seconds: _timeout));
      debugPrint('PUT response: ${response.statusCode} → ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      return [600, "No internet"];
    } catch (e) {
      return [600, e.toString()];
    }
  }

  static Future<List> delete(String url, {bool delete = false, Map<String, dynamic>? data}) async {
    final headers = _buildHeaders();
    final body = delete ? json.encode(data) : null;
    log('DELETE → $url\nPayload: $data');
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers, body: body)
          .timeout(Duration(seconds: _timeout));
      debugPrint('DELETE response: ${response.statusCode} → ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      return [600, "No internet"];
    } catch (e) {
      return [600, e.toString()];
    }
  }

  static Future<List> _handleResponse(http.Response response) async {
    final statusCode = response.statusCode;
    dynamic body;

    try {
      // Always try decoding JSON if body is not empty
      body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (e) {
      log('JSON decode error: $e');
      body = null;
    }

    // Log the decoded body type for debugging
    log('Decoded body type: ${body.runtimeType}');

    switch (statusCode) {
      case 200:
      case 201:
        if (body == null || body is! Map<String, dynamic>) {
          log('Warning: Expected JSON object but got ${body.runtimeType}');
          return [statusCode, {}]; // safe fallback
        }
        return [statusCode, body];

      case 400:
        return [statusCode, body, body is Map ? body["message"] : body];

      case 401:
      case 403:
      case 500:
      case 503:
        return [statusCode, body is Map ? body["message"] : body];

      case 404:
        return [statusCode, "You're using unregistered application"];

      case 502:
        return [statusCode, "Server Crashed or under maintenance"];

      case 504:
        return [
          statusCode,
          {"message": "Request timeout", "code": 504, "status": "Cancelled"},
        ];

      default:
        return [statusCode, body is Map ? body["message"] : body];
    }
  }
}
