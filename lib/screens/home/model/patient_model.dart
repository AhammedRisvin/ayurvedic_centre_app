class PatientModel {
  final bool status;
  final String message;
  final List<Patient> patient;

  PatientModel({this.status = false, this.message = '', this.patient = const []});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      patient: (json['patient'] as List<dynamic>?)?.map((e) => Patient.fromJson(e)).toList() ?? [],
    );
  }
}

class Patient {
  final int? id;
  final String? name;
  final String? phone;
  final String? address;
  final String? payment;
  final String? user;
  final double? totalAmount;
  final double? discountAmount;
  final double? advanceAmount;
  final double? balanceAmount;
  final String? dateTime;
  final bool? isActive;
  final BranchInfo? branch;
  final List<PatientDetails>? patientDetails;

  Patient({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.payment,
    this.user,
    this.totalAmount,
    this.discountAmount,
    this.advanceAmount,
    this.balanceAmount,
    this.dateTime,
    this.isActive,
    this.branch,
    this.patientDetails,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      payment: json['payment'] ?? '',
      user: json['user'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      advanceAmount: (json['advance_amount'] as num?)?.toDouble(),
      balanceAmount: (json['balance_amount'] as num?)?.toDouble(),
      dateTime: json['date_nd_time'] ?? '',
      isActive: json['is_active'] ?? false,
      branch: json['branch'] != null ? BranchInfo.fromJson(json['branch']) : null,
      patientDetails:
          (json['patientdetails_set'] as List<dynamic>?)?.map((e) => PatientDetails.fromJson(e)).toList() ?? [],
    );
  }
}

class BranchInfo {
  final int? id;
  final String? name;
  final String? location;
  final String? phone;
  final String? mail;
  final String? address;
  final bool? isActive;

  BranchInfo({this.id, this.name, this.location, this.phone, this.mail, this.address, this.isActive});

  factory BranchInfo.fromJson(Map<String, dynamic> json) {
    return BranchInfo(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      mail: json['mail'] ?? '',
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}

class PatientDetails {
  final int? id;
  final String? male;
  final String? female;
  final int? patient;
  final int? treatment;
  final String? treatmentName;

  PatientDetails({this.id, this.male, this.female, this.patient, this.treatment, this.treatmentName});

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      id: json['id'],
      male: json['male'] ?? '0',
      female: json['female'] ?? '0',
      patient: json['patient'],
      treatment: json['treatment'],
      treatmentName: json['treatment_name'],
    );
  }
}
