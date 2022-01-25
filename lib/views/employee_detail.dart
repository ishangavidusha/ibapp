import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibapp/models/employee.dart';
import 'package:ibapp/service/employee.dart';
import 'package:ibapp/utils/app_theme.dart';
import 'package:ibapp/utils/size.dart';
import 'package:provider/provider.dart';

class EmployeeDetail extends StatefulWidget {
  final Employee? employee;
  const EmployeeDetail({
    Key? key,
    this.employee,
  }) : super(key: key);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  late TextEditingController nameEditingController;
  late TextEditingController phoneEditingController;
  late TextEditingController hourRateEditingController;
  late TextEditingController otRateEditingController;
  late String? updateId;
  String? nameError;
  String? phoneError;
  String? hourRateError;
  String? otRateError;

  @override
  void initState() {
    updateId = widget.employee?.id;
    nameEditingController = TextEditingController(text: widget.employee?.name);
    phoneEditingController = TextEditingController(text: widget.employee?.phoneNumber);
    hourRateEditingController = TextEditingController(text: (widget.employee?.hourlyRate ?? 0.00).toStringAsFixed(0));
    otRateEditingController = TextEditingController(text: (widget.employee?.otRate ?? 0.00).toStringAsFixed(0) );
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    phoneEditingController.dispose();
    hourRateEditingController.dispose();
    otRateEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeService = Provider.of<EmployeeService>(context);
    final appTheme = Provider.of<AppTheme>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: appTheme.background,
        body: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add New Employee",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: TextField(
                          controller: nameEditingController,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            border: InputBorder.none,
                            labelText: "Name",
                            labelStyle: TextStyle(
                              color: appTheme.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                            hintText: "Enter name",
                            hintStyle: TextStyle(
                              color: appTheme.secondaryText.withOpacity(0.6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            ),
                            errorText: nameError,
                            errorStyle: TextStyle(
                              color: appTheme.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w400
                            ),
                            filled: true,
                            fillColor: appTheme.primary.withAlpha(20),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                nameError = "Name can't be empty";
                              });
                            } else {
                              setState(() {
                                nameError = null;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: TextField(
                          controller: phoneEditingController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            border: InputBorder.none,
                            labelText: "Phone Number",
                            labelStyle: TextStyle(
                              color: appTheme.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                            hintText: "Enter phone number",
                            hintStyle: TextStyle(
                              color: appTheme.secondaryText.withOpacity(0.6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            ),
                            errorText: phoneError,
                            errorStyle: TextStyle(
                              color: appTheme.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w400
                            ),
                            filled: true,
                            fillColor: appTheme.primary.withAlpha(20),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                phoneError = "Phone number can't be empty";
                              });
                            } else {
                              setState(() {
                                phoneError = null;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: TextField(
                          controller: hourRateEditingController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            border: InputBorder.none,
                            labelText: "Hourly Wage",
                            labelStyle: TextStyle(
                              color: appTheme.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                            hintText: "Enter hourly wage",
                            hintStyle: TextStyle(
                              color: appTheme.secondaryText.withOpacity(0.6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            ),
                            prefix: Text(
                              "Rs. ",
                              style: TextStyle(
                                fontSize: 16,
                                color: appTheme.secondaryText
                              ),
                            ),
                            suffix: Text(
                              ".00",
                              style: TextStyle(
                                fontSize: 16,
                                color: appTheme.secondaryText
                              ),
                            ),
                            errorText: hourRateError,
                            errorStyle: TextStyle(
                              color: appTheme.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w400
                            ),
                            filled: true,
                            fillColor: appTheme.primary.withAlpha(20),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                hourRateError = "Hourly wage can't be empty";
                              });
                            } else {
                              setState(() {
                                hourRateError = null;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: TextField(
                          controller: otRateEditingController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            border: InputBorder.none,
                            labelText: "OT Hourly Wage",
                            labelStyle: TextStyle(
                              color: appTheme.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                            hintText: "Enter OT hourly wage",
                            hintStyle: TextStyle(
                              color: appTheme.secondaryText.withOpacity(0.6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            ),
                            prefix: Text(
                              "Rs. ",
                              style: TextStyle(
                                fontSize: 16,
                                color: appTheme.secondaryText
                              ),
                            ),
                            suffix: Text(
                              ".00",
                              style: TextStyle(
                                fontSize: 16,
                                color: appTheme.secondaryText
                              ),
                            ),
                            errorText: otRateError,
                            errorStyle: TextStyle(
                              color: appTheme.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w400
                            ),
                            filled: true,
                            fillColor: appTheme.primary.withAlpha(20),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                otRateError = "OT Hourly wage can't be empty";
                              });
                            } else {
                              setState(() {
                                otRateError = null;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: ElevatedButton(
                        child: Text(
                          updateId != null ? "UPDATE" : "SAVE",
                          style: TextStyle(
                            color: appTheme.surface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: appTheme.primary,
                          onPrimary: appTheme.shift(appTheme.primary, 0.2),
                          onSurface: appTheme.secondary,
                          elevation: 8.0,
                          minimumSize: Size(devWidth(context), 40),
                          shadowColor: appTheme.shift(appTheme.secondary, 0.4, stronger: true).withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                        onPressed: () async {
                          String name = nameEditingController.text.trim();
                          String phone = phoneEditingController.text.trim();
                          String hourlyRate = hourRateEditingController.text.trim();
                          String otRate = otRateEditingController.text.trim();
                          if (name.isEmpty) {
                            setState(() {
                              nameError = "Name can't be empty";
                            });
                            return;
                          } else {
                            setState(() {
                              nameError = null;
                            });
                          }
                          if (phone.isEmpty) {
                            setState(() {
                              phoneError = "Phone number can't be empty";
                            });
                            return;
                          } else {
                            setState(() {
                              phoneError = null;
                            });
                          }
                          if (hourlyRate.isEmpty) {
                            setState(() {
                              hourRateError = "Hourly wage can't be empty";
                            });
                            return;
                          } else {
                            setState(() {
                              hourRateError = null;
                            });
                          }
                          if (otRate.isEmpty) {
                            setState(() {
                              otRateError = "OT Hourly wage can't be empty";
                            });
                            return;
                          } else {
                            setState(() {
                              otRateError = null;
                            });
                          }
                          if (updateId == null) {
                            CreateEmployee createEmployee = CreateEmployee(name: name, phoneNumber: phone, hourlyRate: double.parse(hourlyRate), otRate: double.parse(otRate));
                            bool result = await employeeService.addNewEmployee(createEmployee);
                            Navigator.pop(context, result);
                          } else {
                            UpdateEmployee updateEmployee = UpdateEmployee(name: name, phoneNumber: phone, hourlyRate: double.parse(hourlyRate), otRate: double.parse(otRate));
                            bool result = await employeeService.updateEmployee(updateEmployee, updateId!);
                            Navigator.pop(context, result);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              child: employeeService.loading ? Container(
                color: appTheme.background.withAlpha(60),
                child: Center(
                  child: CircularProgressIndicator(
                    color: appTheme.primary,
                  ),
                ),
              ) : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}