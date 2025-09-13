import 'package:flutter/material.dart';

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

  // Selection states
  PaymentType _selectedPayment = PaymentType.cash;
  final List<Treatment> _treatments = [];
  String? _selectedLocation;
  String? _selectedBranch;

  // Sample data (replace with your API data)
  final List<String> _locations = ['Kozhikode', 'Kochi', 'Thiruvananthapuram', 'Thrissur'];
  final List<String> _branches = ['Main Branch', 'City Center', 'Mall Branch', 'Express Branch'];
  final List<String> _availableTreatments = [
    'Couple Combo Package',
    'Ayurvedic Massage',
    'Body Therapy',
    'Facial Treatment',
    'Spa Package',
  ];

  // Getters
  Map<String, String?> get fieldErrors => _fieldErrors;
  String? get generalError => _generalError;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  PaymentType get selectedPayment => _selectedPayment;
  List<Treatment> get treatments => _treatments;
  String? get selectedLocation => _selectedLocation;
  String? get selectedBranch => _selectedBranch;
  List<String> get locations => _locations;
  List<String> get branches => _branches;
  List<String> get availableTreatments => _availableTreatments;

  RegisterProvider() {
    _initializeListeners();
    _addDefaultTreatment();
  }

  void _initializeListeners() {
    // Add listeners for amount calculations
    totalAmountController.addListener(_calculateBalance);
    discountAmountController.addListener(_calculateBalance);
    advanceAmountController.addListener(_calculateBalance);
  }

  void _addDefaultTreatment() {
    _treatments.add(Treatment(id: 1, name: 'Couple Combo Package', maleCount: 2, femaleCount: 2));
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

    // Clear branch when location changes
    _selectedBranch = null;
    branchController.clear();

    notifyListeners();
  }

  void setBranch(String branch) {
    _selectedBranch = branch;
    branchController.text = branch;
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

  // Treatment management
  void addTreatment() {
    _treatments.add(Treatment(id: _treatments.length + 1, name: 'Select Treatment', maleCount: 1, femaleCount: 1));
    notifyListeners();
  }

  void removeTreatment(int index) {
    if (_treatments.length > 1) {
      _treatments.removeAt(index);
      notifyListeners();
    }
  }

  void updateTreatmentCount(int treatmentIndex, int genderType, int count) {
    if (treatmentIndex < _treatments.length) {
      if (genderType == 0) {
        _treatments[treatmentIndex].maleCount = count;
      } else {
        _treatments[treatmentIndex].femaleCount = count;
      }
      notifyListeners();
    }
  }

  void updateTreatmentName(int index, String name) {
    if (index < _treatments.length) {
      _treatments[index].name = name;
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

    final locationError = validateLocation(_selectedLocation);
    if (locationError != null) {
      _setFieldError('location', locationError);
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
      _setGeneralError('Please fix the errors above');
      return;
    }

    _isSaving = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final formData = _collectFormData();

      // Here you would typically call your API
      await _submitToAPI(formData);

      _setGeneralError(null);
      // You can add a success callback or navigation here
    } catch (e) {
      _setGeneralError('Failed to save registration: ${e.toString()}');
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _collectFormData() {
    return {
      'name': nameController.text.trim(),
      'whatsapp': whatsappController.text.trim(),
      'address': addressController.text.trim(),
      'location': _selectedLocation,
      'branch': _selectedBranch,
      'treatments': _treatments.map((t) => t.toJson()).toList(),
      'totalAmount': double.tryParse(totalAmountController.text) ?? 0,
      'discountAmount': double.tryParse(discountAmountController.text) ?? 0,
      'advanceAmount': double.tryParse(advanceAmountController.text) ?? 0,
      'balanceAmount': double.tryParse(balanceAmountController.text) ?? 0,
      'paymentMethod': _selectedPayment.toString().split('.').last,
      'treatmentDate': treatmentDateController.text,
      'treatmentTime': '${hourController.text}:${minuteController.text}',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  Future<void> _submitToAPI(Map<String, dynamic> data) async {
    // Replace with your actual API call
    print('Submitting data: $data');

    // Simulate potential API errors
    if (data['name'] == 'error') {
      throw Exception('Server error occurred');
    }
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

// Treatment model
class Treatment {
  final int id;
  String name;
  int maleCount;
  int femaleCount;

  Treatment({required this.id, required this.name, required this.maleCount, required this.femaleCount});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'maleCount': maleCount, 'femaleCount': femaleCount};
  }
}
