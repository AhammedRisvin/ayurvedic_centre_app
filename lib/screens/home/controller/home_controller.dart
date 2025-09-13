import 'dart:developer';

import 'package:ayurvedic_centre_app/core/network/api_client.dart';
import 'package:ayurvedic_centre_app/core/network/api_endpoints.dart';
import 'package:ayurvedic_centre_app/screens/home/model/patient_model.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool _hasError = false;
  bool _isLoading = false;

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  PatientModel patientModel = PatientModel();

  Future<void> getHomeData() async {
    _hasError = false;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ServerClient.get(Urls.home);
      log('first ${response.first}');

      if (response.first >= 200 && response.first < 300) {
        try {
          final raw = response.last;
          if (raw != null && raw is Map<String, dynamic>) {
            patientModel = PatientModel.fromJson(raw);
            log('Loaded ${patientModel.patient.length} patients');
          } else {
            log('Unexpected response format');
            _hasError = true;
          }
        } catch (e) {
          log('Parsing error: $e');
          _hasError = true;
        }
      } else {
        _hasError = true;
      }
    } catch (e) {
      log('Network error: $e');
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }
}
