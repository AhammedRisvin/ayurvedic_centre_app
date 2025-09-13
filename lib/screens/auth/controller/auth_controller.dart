import 'package:ayurvedic_centre_app/core/network/api_client.dart';
import 'package:ayurvedic_centre_app/core/network/api_endpoints.dart';
import 'package:flutter/material.dart';

import '../../../core/util/storage.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> loginFn(String username, String password) async {
    _setLoading(true);

    try {
      final response = await ServerClient.post(
        Urls.login,
        data: {"username": username, "password": password},
        useForm: true,
      );

      final statusCode = response[0];
      final responseBody = response[1];

      if (statusCode >= 200 && statusCode < 300 && responseBody['status'] == true) {
        Store.userToken = responseBody['token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
