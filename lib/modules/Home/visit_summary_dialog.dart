import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits/shared/components/components.dart';
import 'package:visits/shared/components/constants.dart';
import 'package:visits/modules/Home/cubit/cubit.dart';
import 'package:visits/modules/Home/cubit/states.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../Visits/visits_screen.dart';

class VisitSummaryDialog extends StatefulWidget {
  final Map<String, String> visitData;
  final homeCubit cubit;
  final VoidCallback onUpdate;

  const VisitSummaryDialog({
    Key? key,
    required this.visitData,
    required this.cubit,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<VisitSummaryDialog> createState() => _VisitSummaryDialogState();
}

class _VisitSummaryDialogState extends State<VisitSummaryDialog> {
  bool _isEditingVisitor = false;
  bool _isEditingVisit = false;

  // Controllers for visitor editing
  late TextEditingController _rankController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _additionalPhoneController;
  late TextEditingController _departmentController;

  // Controllers for visit editing
  late TextEditingController _subjectController;
  late TextEditingController _feedbackController;

  // Date variable for visit date
  DateTime _visitDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _rankController = TextEditingController(text: widget.visitData['rank'] ?? '');
    _nameController = TextEditingController(text: widget.visitData['name'] ?? '');
    _phoneController = TextEditingController(text: widget.visitData['phoneNo'] ?? '');
    _additionalPhoneController = TextEditingController(text: widget.visitData['additionalPhoneNo'] ?? '');
    _departmentController = TextEditingController(text: widget.visitData['department'] ?? '');
    _subjectController = TextEditingController(text: widget.visitData['visitReason'] ?? '');
    _feedbackController = TextEditingController(text: widget.visitData['feedback'] ?? '');

    // Initialize visit date from visitData or use current date
    if (widget.visitData['visitDate'] != null && widget.visitData['visitDate']!.isNotEmpty) {
      _visitDate = DateTime.tryParse(widget.visitData['visitDate']!) ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _rankController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _additionalPhoneController.dispose();
    _departmentController.dispose();
    _subjectController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Widget _buildVisitorInfo() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'بيانات الزائر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                IconButton(
                  icon: Icon(_isEditingVisitor ? Icons.save : Icons.edit),
                  color: _isEditingVisitor ? Colors.green : Colors.blue,
                  onPressed: () {
                    if (_isEditingVisitor) {
                      _saveVisitorChanges();
                    } else {
                      setState(() {
                        _isEditingVisitor = true;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            if (_isEditingVisitor) ...[
              _buildEditableField('الرتبة', _rankController),
              _buildEditableField('الاسم', _nameController),
              _buildEditableField('رقم الهاتف', _phoneController),
              _buildEditableField('رقم هاتف إضافي', _additionalPhoneController),
              _buildEditableField('الجهة', _departmentController),
            ] else ...[
              _buildInfoRow('الرتبة:', widget.visitData['rank'] ?? ''),
              _buildInfoRow('الاسم:', widget.visitData['name'] ?? ''),
              _buildInfoRow('رقم الهاتف:', widget.visitData['phoneNo'] ?? ''),
              _buildInfoRow('رقم هاتف إضافي:', widget.visitData['additionalPhoneNo'] ?? ''),
              _buildInfoRow('الجهة:', widget.visitData['department'] ?? ''),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVisitInfo() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'بيانات الزيارة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                IconButton(
                  icon: Icon(_isEditingVisit ? Icons.save : Icons.edit),
                  color: _isEditingVisit ? Colors.green : Colors.blue,
                  onPressed: () {
                    if (_isEditingVisit) {
                      _saveVisitChanges();
                    } else {
                      setState(() {
                        _isEditingVisit = true;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            if (_isEditingVisit) ...[
              _buildEditableField('سبب الزيارة', _subjectController),
              _buildEditableField('ملاحظات', _feedbackController),
              _buildDatePickerField(),
            ] else ...[
              _buildInfoRow('سبب الزيارة:', widget.visitData['visitReason'] ?? ''),
              _buildInfoRow('ملاحظات:', widget.visitData['feedback'] ?? ''),
              _buildInfoRow('تاريخ الزيارة:', '${_visitDate.year}-${_visitDate.month.toString().padLeft(2, '0')}-${_visitDate.day.toString().padLeft(2, '0')}'),
              _buildInfoRow('وقت الزيارة:', '${_visitDate.hour.toString().padLeft(2, '0')}:${_visitDate.minute.toString().padLeft(2, '0')}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تاريخ الزيارة',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          InkWell(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _visitDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_visitDate),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  setState(() {
                    _visitDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                  SizedBox(width: 8),
                  Text(
                    '${_visitDate.year}-${_visitDate.month.toString().padLeft(2, '0')}-${_visitDate.day.toString().padLeft(2, '0')} ${_visitDate.hour.toString().padLeft(2, '0')}:${_visitDate.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'غير محدد' : value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  void _saveVisitorChanges() {
    // Update the visitor data using the modify function
    final visitorId = int.tryParse(widget.visitData['visitorId'] ?? '0');
    if (visitorId != null && visitorId > 0) {
      widget.cubit.modifyVisitor(
        visitorId: visitorId,
        rank: _rankController.text,
        name: _nameController.text,
        phone_number: _phoneController.text,
        additional_phone_number: _additionalPhoneController.text.isEmpty
            ? null
            : _additionalPhoneController.text,
        department: _departmentController.text,
      );

      // Update the visit data map for UI consistency
      widget.visitData['rank'] = _rankController.text;
      widget.visitData['name'] = _nameController.text;
      widget.visitData['phoneNo'] = _phoneController.text;
      widget.visitData['additionalPhoneNo'] = _additionalPhoneController.text;
      widget.visitData['department'] = _departmentController.text;
    }

    setState(() {
      _isEditingVisitor = false;
    });

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'تم حفظ تعديلات الزائر',
      autoCloseDuration: Duration(seconds: 2),
    );
  }

  void _saveVisitChanges() {
    // Update the visit data using the modify function
    final visitId = int.tryParse(widget.visitData['visitId'] ?? '0');
    if (visitId != null && visitId > 0) {
      widget.cubit.modifyVisit(
        visitId: visitId,
        feedback: _feedbackController.text,
        visitReason: _subjectController.text,
        visitDate: _visitDate.toIso8601String(),
      );

      // Update the visit data map for UI consistency
      widget.visitData['feedback'] = _feedbackController.text;
      widget.visitData['visitReason'] = _subjectController.text;
      widget.visitData['visitDate'] = _visitDate.toIso8601String();
    }

    setState(() {
      _isEditingVisit = false;
    });

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'تم حفظ تعديلات الزيارة',
      autoCloseDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تم إضافة الزيارة بنجاح',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildVisitorInfo(),
                    _buildVisitInfo(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to visits screen to show today's visits
                      // navigateTo(context, VisitsScreen());
                    },
                    icon: Icon(Icons.list_alt),
                    label: Text('عرض زيارات اليوم'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onUpdate();
                    },
                    icon: Icon(Icons.add),
                    label: Text('إضافة زيارة أخرى'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showVisitSummaryDialog(BuildContext context, Map<String, String> visitData, homeCubit cubit, VoidCallback onUpdate) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => VisitSummaryDialog(
      visitData: visitData,
      cubit: cubit,
      onUpdate: onUpdate,
    ),
  );
}
