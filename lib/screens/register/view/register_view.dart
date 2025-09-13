import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/util/app_color.dart';
import '../../../core/util/common_widgets.dart';
import '../../../core/util/sized_box.dart';
import '../controller/register_controller.dart';
import 'widget/payment_selection_widget.dart';
import 'widget/treatment_selection_widget.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => RegisterProvider(), child: const _RegisterViewContent());
  }
}

class _RegisterViewContent extends StatelessWidget {
  const _RegisterViewContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            child: Form(
              key: provider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  if (provider.generalError != null) _buildGeneralErrorWidget(provider.generalError!),
                  _buildBasicInfoSection(provider, context),
                  _buildLocationSection(provider, context),
                  TreatmentSelectionWidget(),
                  _buildAmountSection(provider, context),
                  PaymentSelectionWidget(
                    initialSelection: provider.selectedPayment,
                    onSelectionChanged: provider.setPaymentMethod,
                  ),
                  _buildAdvanceBalanceSection(provider, context),
                  _buildTreatmentScheduleSection(provider, context),
                  _buildSaveButton(provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: AppColor.black),
      ),
      actions: [Image.asset('assets/images/notificationBell.png', height: 28, width: 28), const SizeBoxV(20)],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizeBoxH(15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: text(
            text: 'Register',
            size: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            color: AppColor.black,
          ),
        ),
        const SizeBoxH(12),
        Divider(color: AppColor.black.withOpacity(0.2), thickness: 1),
        const SizeBoxH(30),
      ],
    );
  }

  Widget _buildGeneralErrorWidget(String error) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          const SizeBoxV(10),
          Expanded(
            child: text(text: error, size: 14, color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(RegisterProvider provider, BuildContext context) {
    return Column(
      children: [
        _buildFormField(
          label: 'Name',
          hintText: 'Enter your full name',
          controller: provider.nameController,
          keyboardType: TextInputType.name,
          error: provider.fieldErrors['name'],
          onChanged: (value) => provider.clearFieldError != null ? {} : null,
          context: context,
        ),
        _buildFormField(
          label: 'Whatsapp Number',
          hintText: 'Enter your Whatsapp number',
          controller: provider.whatsappController,
          keyboardType: TextInputType.phone,
          error: provider.fieldErrors['whatsapp'],
          context: context,
        ),
        _buildFormField(
          label: 'Address',
          hintText: 'Enter your full address',
          controller: provider.addressController,
          keyboardType: TextInputType.streetAddress,
          error: provider.fieldErrors['address'],
          context: context,
        ),
      ],
    );
  }

  Widget _buildLocationSection(RegisterProvider provider, BuildContext context) {
    return Column(
      children: [
        _buildFormField(
          label: 'Location',
          hintText: 'Choose your location',
          controller: provider.locationController,
          keyboardType: TextInputType.text,
          readOnly: true,
          onTap: () => _showLocationPicker(provider),
          suffixIcon: Icon(Icons.keyboard_arrow_down, color: AppColor.appPrimary),
          error: provider.fieldErrors['location'],
          context: context,
        ),
        _buildFormField(
          label: 'Branch',
          hintText: 'Select the branch',
          controller: provider.branchController,
          keyboardType: TextInputType.text,
          readOnly: true,
          onTap: () => _showBranchPicker(provider),
          suffixIcon: Icon(Icons.keyboard_arrow_down, color: AppColor.greenColor),
          error: provider.fieldErrors['branch'],
          context: context,
        ),
      ],
    );
  }

  Widget _buildAmountSection(RegisterProvider provider, BuildContext context) {
    return Column(
      children: [
        _buildFormField(
          label: 'Total Amount',
          hintText: '0.00',
          controller: provider.totalAmountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          error: provider.fieldErrors['totalAmount'],
          context: context,
        ),
        _buildFormField(
          label: 'Discount Amount',
          hintText: '0.00',
          controller: provider.discountAmountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          error: provider.fieldErrors['discountAmount'],
          context: context,
        ),
      ],
    );
  }

  Widget _buildAdvanceBalanceSection(RegisterProvider provider, BuildContext context) {
    return Column(
      children: [
        _buildFormField(
          label: 'Advance Amount',
          hintText: '0.00',
          controller: provider.advanceAmountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          error: provider.fieldErrors['advanceAmount'],
          context: context,
        ),
        _buildFormField(
          label: 'Balance Amount',
          hintText: '0.00',
          controller: provider.balanceAmountController,
          keyboardType: TextInputType.number,
          readOnly: true,
          error: provider.fieldErrors['balanceAmount'],
          context: context,
        ),
      ],
    );
  }

  Widget _buildTreatmentScheduleSection(RegisterProvider provider, BuildContext context) {
    return Column(
      children: [
        _buildFormField(
          label: 'Treatment Date',
          hintText: 'Select date',
          controller: provider.treatmentDateController,
          keyboardType: TextInputType.datetime,
          readOnly: true,
          onTap: () => _selectDate(provider),
          suffixIcon: Image.asset('assets/images/calenderIcon.png', color: AppColor.appPrimary),
          error: provider.fieldErrors['treatmentDate'],
          context: context,
        ),
        _buildTreatmentTimeFields(provider, context),
      ],
    );
  }

  Widget _buildTreatmentTimeFields(RegisterProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizeBoxH(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: text(text: 'Treatment Time', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
        ),
        const SizeBoxH(6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildCommonTextFormField(
                      hintText: 'Hour',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: provider.hourController,
                      readOnly: true,
                      context: context,
                      validator: (p0) => null,
                      obscureText: false,
                      onTap: () => _selectTime(provider, 'hour'),
                      onFieldSubmitted: (p0) {},
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: AppColor.appPrimary),
                    ),
                    if (provider.fieldErrors['hour'] != null) _buildFieldError(provider.fieldErrors['hour']!),
                  ],
                ),
              ),
              const SizeBoxV(15),
              Expanded(
                child: Column(
                  children: [
                    buildCommonTextFormField(
                      hintText: 'Minutes',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: provider.minuteController,
                      readOnly: true,
                      context: context,
                      validator: (p0) => null,
                      obscureText: false,
                      onTap: () => _selectTime(provider, 'minute'),
                      onFieldSubmitted: (p0) {},
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: AppColor.appPrimary),
                    ),
                    if (provider.fieldErrors['minute'] != null) _buildFieldError(provider.fieldErrors['minute']!),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizeBoxH(20),
      ],
    );
  }

  Widget _buildSaveButton(RegisterProvider provider) {
    return Column(
      children: [
        const SizeBoxH(55),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: button(
            name: 'Save',
            height: 50,
            width: double.infinity,
            onTap: provider.saveRegistration,
            isLoading: provider.isSaving,
          ),
        ),
        const SizeBoxH(55),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool readOnly = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    Function(String)? onChanged,
    String? error,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: text(text: label, size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
        ),
        const SizeBoxH(6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: buildCommonTextFormField(
            hintText: hintText,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.next,
            controller: controller,
            readOnly: readOnly,
            context: context,
            validator: (p0) => null,
            obscureText: false,
            onTap: onTap ?? () {},
            onFieldSubmitted: (p0) {},
            onChanged: onChanged,
            suffixIcon: suffixIcon,
          ),
        ),
        if (error != null) _buildFieldError(error),
        const SizeBoxH(20),
      ],
    );
  }

  Widget _buildFieldError(String error) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 5),
      child: text(text: error, size: 12, color: Colors.red, fontWeight: FontWeight.w400),
    );
  }

  void _showLocationPicker(RegisterProvider provider) {
    showDialog(
      context: provider.formKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Select Location'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: ListView.builder(
            itemCount: provider.locations.length,
            itemBuilder: (context, index) {
              final location = provider.locations[index];
              return ListTile(
                title: Text(location),
                selected: provider.selectedLocation == location,
                onTap: () {
                  provider.setLocation(location);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showBranchPicker(RegisterProvider provider) {
    if (provider.selectedLocation == null) {
      _showErrorSnackBar(provider.formKey.currentContext!, 'Please select location first');
      return;
    }

    showDialog(
      context: provider.formKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Select Branch'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: ListView.builder(
            itemCount: provider.branches.length,
            itemBuilder: (context, index) {
              final branch = provider.branches[index];
              return ListTile(
                title: Text(branch),
                selected: provider.selectedBranch == branch,
                onTap: () {
                  provider.setBranch(branch);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _selectDate(RegisterProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: provider.formKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      provider.setTreatmentDate(picked);
    }
  }

  void _selectTime(RegisterProvider provider, String type) {
    List<String> options = type == 'hour'
        ? List.generate(24, (index) => index.toString().padLeft(2, '0'))
        : List.generate(60, (index) => index.toString().padLeft(2, '0'));

    showDialog(
      context: provider.formKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('Select ${type.capitalize()}'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  provider.setTime(type, options[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
