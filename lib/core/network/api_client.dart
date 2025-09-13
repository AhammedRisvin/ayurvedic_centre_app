import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/storage.dart';

class ServerClient {
  static const int _timeout = 90;

  /// Get request

  static Future<List> get(String url, {BuildContext? context}) async {
    String? token = Store.userToken;

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "country": "india",
    };
    if (token.trim().isNotEmpty) {
      headers.addAll({"authorization": "Bearer $token"});
    }
    log('token $token url $url');
    try {
      var response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: _timeout));
      debugPrint('response.body ${response.body} status code ${response.statusCode}');
      return _response(response, context);
    } on SocketException {
      return [600, "No internet"];
    } catch (e) {
      return [600, e.toString()];
    }
  }

  /// Post request

  static Future<List> post(String url, BuildContext context, {Map<String, dynamic>? data, bool post = true}) async {
    String? token = Store.userToken;
    // String? token =
    //     '5dac68d93137d6ff06b582736ac2029a66d0cc1a64a19dce1450b0149ada523cea1377c615cf44c3f521cb2f8748259cfb3baf203baf0778c3546baaea3387ff0ae553396d2485ddcaed769d5224989b4ca50e6e7d5dc1862842deb37dc66a14b027491ce13aca55ea09c8310dd057672f5a7f889e01959d1182fe8a87f77fd6e9cb977d4ec87755292bf12dc603ba7c0928b2b65da6fbfc20a36413875ff41c61ef20810f5558a39e79cf42fed9e0b9';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "country": "india",
    };
    log('token $token url $url data $data');
    if (token.trim().isNotEmpty) {
      headers.addAll({"authorization": "Bearer $token"});
    }
    try {
      var body = json.encode(data);
      var response = await http
          .post(Uri.parse(url), body: post ? body : null, headers: headers)
          .timeout(const Duration(seconds: _timeout));
      debugPrint('response.body ${response.body} status code ${response.statusCode}');
      return _response(response, context);
    } on SocketException {
      return [600, "No internet"];
    } catch (e) {
      return [600, e.toString()];
    }
  }

  /// Put request

  static Future<List> put(String url, BuildContext context, {Map<String, dynamic>? data, bool put = false}) async {
    String? token = Store.userToken;
    // String? token =
    //     '5dac68d93137d6ff06b582736ac2029a66d0cc1a64a19dce1450b0149ada523cea1377c615cf44c3f521cb2f8748259cfb3baf203baf0778c3546baaea3387ff0ae553396d2485ddcaed769d5224989b4ca50e6e7d5dc1862842deb37dc66a14b027491ce13aca55ea09c8310dd057672f5a7f889e01959d1182fe8a87f77fd6e9cb977d4ec87755292bf12dc603ba7c0928b2b65da6fbfc20a36413875ff41c61ef20810f5558a39e79cf42fed9e0b9';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "country": "india",
    };
    if (token.trim().isNotEmpty) {
      headers.addAll({"authorization": "Bearer $token"});
    }
    try {
      String? body = json.encode(data);
      var response = await http
          .put(Uri.parse(url), body: put == false ? null : body, headers: headers)
          .timeout(const Duration(seconds: _timeout));
      debugPrint('response.body ${response.body} status code ${response.statusCode}');
      return _response(response, context);
    } on SocketException {
      return [600, "No internet"];
    } catch (e) {
      return [600, e.toString()];
    }
  }

  /// Delete request

  static Future<List> delete(
    String url,
    BuildContext context, {
    bool delete = false,
    String? id,
    Map<String, dynamic>? data,
  }) async {
    String? token = Store.userToken;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "country": "india",
      "authorization": "Bearer $token",
    };
    String? jsonData = data != null ? json.encode(data) : null;

    var response = await http.delete(Uri.parse(url), headers: headers, body: delete == false ? null : jsonData);
    debugPrint('response.body ${response.body} status code ${response.statusCode}');
    return await _response(response, context);
  }

  // ------------------- ERROR HANDLING ------------------- \\

  static Future<List> _response(http.Response response, BuildContext? context) async {
    switch (response.statusCode) {
      case 200:
        return [response.statusCode, jsonDecode(response.body)];
      case 201:
        return [response.statusCode, jsonDecode(response.body)];
      case 400:
        return [response.statusCode, jsonDecode(response.body), jsonDecode(response.body)["message"]];
      case 401:
        return [response.statusCode, jsonDecode(response.body)["message"]];
      case 403:
        return [response.statusCode, jsonDecode(response.body)["message"]];
      case 404:
        return [response.statusCode, "You're using unregistered application"];
      case 500:
        return [response.statusCode, jsonDecode(response.body)["message"]];
      case 502:
        return [response.statusCode, "Server Crashed or under maintenance"];
      case 503:
        return [response.statusCode, jsonDecode(response.body)["message"]];
      case 504:
        return [
          response.statusCode,
          {"message": "Request timeout", "code": 504, "status": "Cancelled"},
        ];
      default:
        return [response.statusCode, jsonDecode(response.body)["message"]];
    }
  }
}
