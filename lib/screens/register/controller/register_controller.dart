import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class RegisterProvider extends ChangeNotifier {
  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController = TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  final TextEditingController treatmentDateController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();

  // Form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Error states
  final Map<String, String?> _fieldErrors = {};
  String? _generalError;

  // Loading states
  final bool _isLoading = false;
  bool _isSaving = false;
  bool _isBranchLoading = false;
  bool _isTreatmentLoading = false;

  // Selection states
  PaymentType _selectedPayment = PaymentType.cash;
  final List<Treatment> _treatments = [];
  String? _selectedLocation;
  String? _selectedBranch;
  Branch? _selectedBranchObject;

  // Dynamic data from API
  List<Branch> _branches = [];
  List<TreatmentOption> _availableTreatments = [];

  // Error states for API calls
  bool _hasBranchError = false;
  bool _hasTreatmentError = false;
  String? _branchErrorMessage;
  String? _treatmentErrorMessage;

  // Static locations (assuming these don't come from API)
  final List<String> _locations = ['Kozhikode', 'Kochi', 'Thiruvananthapuram', 'Thrissur'];

  // Getters
  Map<String, String?> get fieldErrors => _fieldErrors;
  String? get generalError => _generalError;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isBranchLoading => _isBranchLoading;
  bool get isTreatmentLoading => _isTreatmentLoading;
  PaymentType get selectedPayment => _selectedPayment;
  List<Treatment> get treatments => _treatments;
  String? get selectedLocation => _selectedLocation;
  String? get selectedBranch => _selectedBranch;
  Branch? get selectedBranchObject => _selectedBranchObject;
  List<String> get locations => _locations;
  List<Branch> get branches => _branches;
  List<TreatmentOption> get availableTreatments => _availableTreatments;
  bool get hasBranchError => _hasBranchError;
  bool get hasTreatmentError => _hasTreatmentError;
  String? get branchErrorMessage => _branchErrorMessage;
  String? get treatmentErrorMessage => _treatmentErrorMessage;

  RegisterProvider() {
    _initializeListeners();
    _loadInitialData();
  }

  void _initializeListeners() {
    // Add listeners for amount calculations
    totalAmountController.addListener(_calculateBalance);
    discountAmountController.addListener(_calculateBalance);
    advanceAmountController.addListener(_calculateBalance);
  }

  Future<void> _loadInitialData() async {
    await getBranchFn();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateWhatsApp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'WhatsApp number is required';
    }
    if (value.length < 10) {
      return 'WhatsApp number must be at least 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'WhatsApp number should contain only digits';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? validateBranch(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Branch is required';
    }
    return null;
  }

  String? validateAmount(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    if (amount < 0) {
      return 'Amount cannot be negative';
    }
    return null;
  }

  String? validateTreatmentDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Treatment date is required';
    }
    return null;
  }

  String? validateTime(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Business logic methods
  void _calculateBalance() {
    final total = double.tryParse(totalAmountController.text) ?? 0;
    final discount = double.tryParse(discountAmountController.text) ?? 0;
    final advance = double.tryParse(advanceAmountController.text) ?? 0;

    final balance = (total - discount) - advance;
    balanceAmountController.text = balance > 0 ? balance.toStringAsFixed(2) : '0.00';

    // Clear amount-related errors when recalculating
    clearFieldError('totalAmount');
    clearFieldError('balanceAmount');

    notifyListeners();
  }

  void setPaymentMethod(PaymentType paymentType) {
    _selectedPayment = paymentType;
    clearFieldError('payment');
    notifyListeners();
  }

  void setLocation(String location) {
    _selectedLocation = location;
    locationController.text = location;
    clearFieldError('location');
    notifyListeners();
  }

  void setBranch(Branch branch) {
    _selectedBranchObject = branch;
    _selectedBranch = branch.name ?? '';
    branchController.text = branch.name ?? '';
    clearFieldError('branch');
    notifyListeners();
  }

  void setTreatmentDate(DateTime date) {
    treatmentDateController.text = "${date.day}/${date.month}/${date.year}";
    clearFieldError('treatmentDate');
    notifyListeners();
  }

  void setTime(String type, String value) {
    if (type == 'hour') {
      hourController.text = value;
      clearFieldError('hour');
    } else {
      minuteController.text = value;
      clearFieldError('minute');
    }
    notifyListeners();
  }

  // Treatment management methods
  void addTreatmentWithDetails(TreatmentOption treatmentOption, int maleCount, int femaleCount) {
    final newTreatment = Treatment(
      id: treatmentOption.id,
      name: treatmentOption.name,
      maleCount: maleCount,
      femaleCount: femaleCount,
    );
    _treatments.add(newTreatment);
    clearFieldError('treatments');

    log('Treatment added. Total treatments: ${_treatments.length}');
    notifyListeners();
  }

  void removeTreatment(int index) {
    if (index < _treatments.length) {
      _treatments.removeAt(index);
      notifyListeners();
    }
  }

  void updateTreatment(int index, TreatmentOption treatmentOption, int maleCount, int femaleCount) {
    if (index < _treatments.length) {
      _treatments[index].id = treatmentOption.id;
      _treatments[index].name = treatmentOption.name;
      _treatments[index].maleCount = maleCount;
      _treatments[index].femaleCount = femaleCount;
      notifyListeners();
    }
  }

  // Error handling
  void _setFieldError(String field, String? error) {
    _fieldErrors[field] = error;
    notifyListeners();
  }

  void clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      _fieldErrors.remove(field);
      notifyListeners();
    }
  }

  void _setGeneralError(String? error) {
    _generalError = error;
    notifyListeners();
  }

  void clearAllErrors() {
    _fieldErrors.clear();
    _generalError = null;
    notifyListeners();
  }

  // Form submission
  bool validateForm() {
    clearAllErrors();
    bool isValid = true;

    // Validate all fields
    final nameError = validateName(nameController.text);
    if (nameError != null) {
      _setFieldError('name', nameError);
      isValid = false;
    }

    final whatsappError = validateWhatsApp(whatsappController.text);
    if (whatsappError != null) {
      _setFieldError('whatsapp', whatsappError);
      isValid = false;
    }

    final addressError = validateAddress(addressController.text);
    if (addressError != null) {
      _setFieldError('address', addressError);
      isValid = false;
    }

    final branchError = validateBranch(_selectedBranch);
    if (branchError != null) {
      _setFieldError('branch', branchError);
      isValid = false;
    }

    // Validate treatments
    if (_treatments.isEmpty) {
      _setFieldError('treatments', 'At least one treatment is required');
      isValid = false;
    }

    final totalAmountError = validateAmount(totalAmountController.text, 'Total amount');
    if (totalAmountError != null) {
      _setFieldError('totalAmount', totalAmountError);
      isValid = false;
    }

    final advanceAmountError = validateAmount(advanceAmountController.text, 'Advance amount');
    if (advanceAmountError != null) {
      _setFieldError('advanceAmount', advanceAmountError);
      isValid = false;
    }

    final treatmentDateError = validateTreatmentDate(treatmentDateController.text);
    if (treatmentDateError != null) {
      _setFieldError('treatmentDate', treatmentDateError);
      isValid = false;
    }

    final hourError = validateTime(hourController.text, 'Hour');
    if (hourError != null) {
      _setFieldError('hour', hourError);
      isValid = false;
    }

    final minuteError = validateTime(minuteController.text, 'Minute');
    if (minuteError != null) {
      _setFieldError('minute', minuteError);
      isValid = false;
    }

    return isValid;
  }

  Future<void> saveRegistration() async {
    if (!validateForm()) {
      _setGeneralError('Please fix the errors below');
      return;
    }

    _isSaving = true;
    notifyListeners();

    try {
      await registerFn();
      _setGeneralError(null);
    } catch (e) {
      _setGeneralError('Failed to save registration: ${e.toString()}');
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // API Calls
  Future<void> registerFn() async {
    try {
      final data = {
        "name": nameController.text.trim(),
        "excecutive": "", // Add the missing field that the server expects
        "payment": _selectedPayment.toString().split('.').last,
        "phone": whatsappController.text.trim(),
        "address": addressController.text.trim(),
        "total_amount": (double.tryParse(totalAmountController.text) ?? 0.0).round(),
        "discount_amount": (double.tryParse(discountAmountController.text) ?? 0.0).round(),
        "advance_amount": (double.tryParse(advanceAmountController.text) ?? 0.0).round(),
        "balance_amount": (double.tryParse(balanceAmountController.text) ?? 0.0).round(),
        "date_nd_time": "${treatmentDateController.text}-${hourController.text}:${minuteController.text}",
        "id": "",
        "male": _getMaleCountsString(),
        "female": _getFemaleCountsString(),
        "branch": _selectedBranchObject?.id.toString() ?? "",
        "treatments": _getTreatmentIdsString(),
      };

      final response = await ServerClient.post(Urls.registerPatientUrl, data: data, useForm: true);
      final statusCode = response[0];
      final responseBody = response[1];

      if (statusCode >= 200 && statusCode < 300 && responseBody['status'] == true) {
        log('Registration successful: $responseBody');
      } else {
        throw Exception(responseBody['message'] ?? 'Registration failed');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  // Fixed getBranchFn method
  Future<void> getBranchFn() async {
    _isBranchLoading = true;
    _hasBranchError = false;
    _branchErrorMessage = null;
    notifyListeners();

    try {
      final response = await ServerClient.get(Urls.getBranchUrl);
      log('Branch API Response Status: ${response.first}');
      log('Branch API Response Body: ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        try {
          final raw = response.last;
          if (raw != null && raw is Map<String, dynamic>) {
            // Parse using BranchModel
            final branchModel = BranchModel.fromJson(raw);

            if (branchModel.status == true) {
              if (branchModel.branches != null && branchModel.branches!.isNotEmpty) {
                _branches = branchModel.branches!;
                log('Branches loaded successfully: ${_branches.length} branches');
                for (var branch in _branches) {
                  log('Branch: ${branch.name} (ID: ${branch.id}, Location: ${branch.location})');
                }
              } else {
                log('No branches found in response');
                _branches = [];
              }
            } else {
              throw Exception(branchModel.message ?? 'Failed to load branches');
            }
          } else {
            throw Exception('Invalid response format: response is null or not a Map');
          }
        } catch (e) {
          log('Branch parsing error: $e');
          _hasBranchError = true;
          _branchErrorMessage = 'Failed to parse branch data: ${e.toString()}';
        }
      } else {
        _hasBranchError = true;
        _branchErrorMessage = 'Failed to load branches from server (Status: ${response.first})';
        log('Branch API failed with status: ${response.first}');
      }
    } catch (e) {
      debugPrint('Error in getBranchFn: $e');
      _hasBranchError = true;
      _branchErrorMessage = 'Network error: ${e.toString()}';
    } finally {
      _isBranchLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTreatmentFn() async {
    _isTreatmentLoading = true;
    _hasTreatmentError = false;
    _treatmentErrorMessage = null;
    notifyListeners();

    try {
      final response = await ServerClient.get(Urls.treatmentList);
      log('Treatment API Response Status: ${response.first}');
      log('Treatment API Response Body: ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        try {
          final raw = response.last;
          if (raw != null && raw is Map<String, dynamic>) {
            // Try different possible response structures
            List<dynamic> treatmentData = [];

            if (raw['status'] == true) {
              if (raw['treatments'] != null) {
                treatmentData = raw['treatments'];
              } else if (raw['data'] != null) {
                treatmentData = raw['data'];
              } else {
                throw Exception('No treatment data found in response');
              }

              _availableTreatments = treatmentData.map((json) => TreatmentOption.fromJson(json)).toList();
              log('Treatments parsed successfully: ${_availableTreatments.length} treatments loaded');
              for (var treatment in _availableTreatments) {
                log('Treatment: ${treatment.name} (ID: ${treatment.id})');
              }
            } else {
              throw Exception(raw['message'] ?? 'Failed to load treatments');
            }
          } else {
            throw Exception('Invalid response format');
          }
        } catch (e) {
          log('Treatment parsing error: $e');
          _hasTreatmentError = true;
          _treatmentErrorMessage = 'Failed to parse treatment data: ${e.toString()}';
        }
      } else {
        _hasTreatmentError = true;
        _treatmentErrorMessage = 'Failed to load treatments from server (Status: ${response.first})';
      }
    } catch (e) {
      debugPrint('Error in getTreatmentFn: $e');
      _hasTreatmentError = true;
      _treatmentErrorMessage = 'Network error: ${e.toString()}';
    } finally {
      _isTreatmentLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryLoadBranches() async {
    await getBranchFn();
  }

  Future<void> retryLoadTreatments() async {
    await getTreatmentFn();
  }

  // Helper methods for API data formatting
  String _getMaleCountsString() {
    return _treatments.map((t) => t.maleCount.toString()).join(',');
  }

  String _getFemaleCountsString() {
    return _treatments.map((t) => t.femaleCount.toString()).join(',');
  }

  String _getTreatmentIdsString() {
    return _treatments.map((t) => t.id.toString()).join(',');
  }

  @override
  void dispose() {
    // Dispose all controllers
    nameController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    locationController.dispose();
    branchController.dispose();
    totalAmountController.dispose();
    discountAmountController.dispose();
    advanceAmountController.dispose();
    balanceAmountController.dispose();
    treatmentDateController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }
}

// Payment enum
enum PaymentType { cash, card, upi }

// Updated Branch model to match your new BranchModel structure
class Branch {
  final int? id;
  final String? name;
  final int? patientsCount;
  final String? location;
  final String? phone;
  final String? mail;
  final String? address;
  final String? gst;
  final bool? isActive;

  Branch({
    this.id,
    this.name,
    this.patientsCount,
    this.location,
    this.phone,
    this.mail,
    this.address,
    this.gst,
    this.isActive,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as int?,
      name: json['name'] as String?,
      patientsCount: json['patients_count'] as int?,
      location: json['location'] as String?,
      phone: json['phone']?.toString(),
      mail: json['mail'] as String?,
      address: json['address'] as String?,
      gst: json['gst'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'patients_count': patientsCount,
      'location': location,
      'phone': phone,
      'mail': mail,
      'address': address,
      'gst': gst,
      'is_active': isActive,
    };
  }
}

// BranchModel for API response
class BranchModel {
  final bool? status;
  final String? message;
  final List<Branch>? branches;

  BranchModel({this.status, this.message, this.branches});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      branches: (json['branches'] as List<dynamic>?)?.map((e) => Branch.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'branches': branches?.map((e) => e.toJson()).toList()};
  }
}

// Treatment Option model (from API)
class TreatmentOption {
  final int id;
  final String name;
  final String? description;
  final String? price;

  TreatmentOption({required this.id, required this.name, this.description, this.price});

  factory TreatmentOption.fromJson(Map<String, dynamic> json) {
    return TreatmentOption(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description, 'price': price};
  }
}

// Treatment model (selected by user)
class Treatment {
  int id;
  String name;
  int maleCount;
  int femaleCount;

  Treatment({required this.id, required this.name, required this.maleCount, required this.femaleCount});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'maleCount': maleCount, 'femaleCount': femaleCount};
  }
}
