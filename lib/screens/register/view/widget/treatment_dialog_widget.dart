import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';
import '../../controller/register_controller.dart';

class TreatmentDialogWidget extends StatefulWidget {
  final int? editIndex; // null for new treatment, index for editing existing

  const TreatmentDialogWidget({super.key, this.editIndex});

  @override
  State<TreatmentDialogWidget> createState() => _TreatmentDialogWidgetState();
}

class _TreatmentDialogWidgetState extends State<TreatmentDialogWidget> {
  final TextEditingController _treatmentController = TextEditingController();
  int _maleCount = 1;
  int _femaleCount = 1;
  TreatmentOption? _selectedTreatment;
  String? _errorMessage;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTreatmentsAndInitialize();
    });
  }

  Future<void> _loadTreatmentsAndInitialize() async {
    final provider = context.read<RegisterProvider>();

    // Load treatments if not already loaded or if there was an error
    if (provider.availableTreatments.isEmpty && !provider.isTreatmentLoading) {
      await provider.getTreatmentFn();
    }

    _initializeData();
  }

  void _initializeData() {
    final provider = context.read<RegisterProvider>();

    if (widget.editIndex != null && widget.editIndex! < provider.treatments.length) {
      // Editing existing treatment
      final treatment = provider.treatments[widget.editIndex!];

      // Find the corresponding TreatmentOption
      _selectedTreatment = provider.availableTreatments.firstWhere(
        (option) => option.id == treatment.id,
        orElse: () => TreatmentOption(id: treatment.id, name: treatment.name),
      );

      _treatmentController.text = treatment.name;
      _maleCount = treatment.maleCount;
      _femaleCount = treatment.femaleCount;
    }

    _isInitialized = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _treatmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: Consumer<RegisterProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizeBoxH(40),
                  _buildHeader(),
                  const SizeBoxH(6),
                  _buildTreatmentDropdown(provider),
                  if (_errorMessage != null) _buildErrorMessage(),
                  if (provider.hasTreatmentError) _buildTreatmentErrorWidget(provider),
                  const SizeBoxH(20),
                  _buildPatientsSection(),
                  const SizeBoxH(6),
                  _buildGenderRow('Male', _maleCount, _updateMaleCount),
                  const SizeBoxH(22),
                  _buildGenderRow('Female', _femaleCount, _updateFemaleCount),
                  const SizeBoxH(30),
                  _buildSaveButton(provider),
                  const SizeBoxH(40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return text(
      text: widget.editIndex != null ? 'Edit Treatment' : 'Choose Treatment',
      size: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.4,
    );
  }

  Widget _buildTreatmentDropdown(RegisterProvider provider) {
    return buildCommonTextFormField(
      hintText: 'Choose preferred treatment',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: _treatmentController,
      context: context,
      readOnly: true,
      validator: (p0) => null,
      obscureText: false,
      onTap: () => _handleTreatmentSelection(provider),
      onFieldSubmitted: (p0) {},
      suffixIcon: _buildTreatmentDropdownSuffix(provider),
    );
  }

  Widget _buildTreatmentDropdownSuffix(RegisterProvider provider) {
    if (provider.isTreatmentLoading) {
      return Container(
        width: 20,
        height: 20,
        margin: const EdgeInsets.all(12),
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.appPrimary),
      );
    }

    if (provider.hasTreatmentError) {
      return Icon(Icons.error_outline, color: Colors.red);
    }

    return Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.appPrimary);
  }

  Widget _buildTreatmentErrorWidget(RegisterProvider provider) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 16),
              const SizeBoxV(8),
              Expanded(
                child: text(
                  text: 'Failed to load treatments',
                  size: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (provider.treatmentErrorMessage != null) ...[
            const SizeBoxH(4),
            text(
              text: provider.treatmentErrorMessage!,
              size: 11,
              color: Colors.red.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ],
          const SizeBoxH(8),
          GestureDetector(
            onTap: () => provider.retryLoadTreatments(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: text(text: 'Retry', size: 11, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: text(text: _errorMessage!, size: 12, color: Colors.red, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildPatientsSection() {
    return text(text: 'Add Patients', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4);
  }

  Widget _buildGenderRow(String gender, int count, Function(int) onCountChanged) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 124,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.53),
            border: Border.all(color: AppColor.black.withOpacity(0.25)),
            color: const Color(0XFFD9D9D9).withOpacity(0.25),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: text(text: gender, fontWeight: FontWeight.w300, size: 14),
          ),
        ),
        const Spacer(),
        _buildCounterButton(Icons.remove, () => _decrementCount(onCountChanged, count)),
        const SizeBoxV(8),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.53),
            border: Border.all(color: AppColor.black.withOpacity(0.25)),
          ),
          child: Center(
            child: text(text: count.toString(), fontWeight: FontWeight.w500, size: 18),
          ),
        ),
        const SizeBoxV(8),
        _buildCounterButton(Icons.add, () => _incrementCount(onCountChanged, count)),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColor.appPrimary,
          boxShadow: [
            BoxShadow(color: AppColor.appPrimary.withOpacity(0.2), blurRadius: 4, offset: const Offset(2, 2)),
          ],
        ),
        child: Icon(icon, color: AppColor.white),
      ),
    );
  }

  Widget _buildSaveButton(RegisterProvider provider) {
    return button(
      name: 'Save',
      height: 50,
      fontSize: 15,
      width: double.infinity,
      onTap: () => _saveTreatment(provider),
      isLoading: false,
    );
  }

  void _handleTreatmentSelection(RegisterProvider provider) {
    if (provider.isTreatmentLoading) {
      _showInfoSnackBar('Loading treatments, please wait...');
      return;
    }

    if (provider.hasTreatmentError) {
      _showErrorDialog(
        'Error Loading Treatments',
        provider.treatmentErrorMessage ?? 'Failed to load treatments',
        () => provider.retryLoadTreatments(),
      );
      return;
    }

    if (provider.availableTreatments.isEmpty) {
      _showErrorSnackBar('No treatments available');
      return;
    }

    _showTreatmentPicker(provider);
  }

  void _showTreatmentPicker(RegisterProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Treatment'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: ListView.builder(
            itemCount: provider.availableTreatments.length,
            itemBuilder: (context, index) {
              final treatment = provider.availableTreatments[index];
              final isSelected = _selectedTreatment?.id == treatment.id;

              return ListTile(
                title: Text(treatment.name),
                subtitle: treatment.description != null
                    ? Text(
                        treatment.description!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: treatment.price != null
                    ? Text('₹${treatment.price}', style: const TextStyle(fontWeight: FontWeight.w500))
                    : null,
                selected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedTreatment = treatment;
                    _treatmentController.text = treatment.name;
                    _errorMessage = null;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
      ),
    );
  }

  void _updateMaleCount(int count) {
    setState(() {
      _maleCount = count;
    });
  }

  void _updateFemaleCount(int count) {
    setState(() {
      _femaleCount = count;
    });
  }

  void _incrementCount(Function(int) onCountChanged, int currentCount) {
    onCountChanged(currentCount + 1);
  }

  void _decrementCount(Function(int) onCountChanged, int currentCount) {
    if (currentCount > 1) {
      onCountChanged(currentCount - 1);
    }
  }

  void _saveTreatment(RegisterProvider provider) {
    // Validate treatment selection
    if (_selectedTreatment == null) {
      setState(() {
        _errorMessage = 'Please select a treatment';
      });
      return;
    }

    // Check if treatment is already selected (for new treatments)
    if (widget.editIndex == null) {
      final isAlreadySelected = provider.treatments.any((treatment) => treatment.id == _selectedTreatment!.id);

      if (isAlreadySelected) {
        setState(() {
          _errorMessage = 'This treatment is already selected';
        });
        return;
      }
    }

    try {
      if (widget.editIndex != null) {
        provider.updateTreatment(widget.editIndex!, _selectedTreatment!, _maleCount, _femaleCount);
      } else {
        provider.addTreatmentWithDetails(_selectedTreatment!, _maleCount, _femaleCount);
      }

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save treatment: ${e.toString()}';
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColor.appPrimary, behavior: SnackBarBehavior.floating),
    );
  }

  void _showErrorDialog(String title, String message, VoidCallback onRetry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
