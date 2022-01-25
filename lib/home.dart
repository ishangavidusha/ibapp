import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ibapp/service/employee.dart';
import 'package:ibapp/utils/app_theme.dart';
import 'package:ibapp/utils/size.dart';
import 'package:ibapp/utils/snack_bar.dart';
import 'package:ibapp/views/employee_detail.dart';
import 'package:ibapp/views/working_hours.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EmployeeService _employeeService;
  late Future<bool>? resolveFuture;

  @override
  void initState() {
    _employeeService = Provider.of<EmployeeService>(context, listen: false);
    resolveFuture = resolveEmployees();
    super.initState();
  }

  void shouldReload() => setState(() {
    resolveFuture = resolveEmployees();
  });

  Future<bool> resolveEmployees() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _employeeService.fetchEmployees();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    final employeeService = Provider.of<EmployeeService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Induwaree Batik",
        ),
      ),
      backgroundColor: appTheme.background,
      body: FutureBuilder(
        future: resolveFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: appTheme.primary,
              ),
            );
          }
          return Stack(
            children: [
              Positioned(
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
                                "Employees",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(
                                "Currently Working",
                                style: TextStyle(
                                  color: appTheme.secondaryText.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: employeeService.employees.isNotEmpty ? RefreshIndicator(
                        onRefresh: employeeService.fetchEmployees,
                        child: ListView.builder(
                          itemCount: employeeService.employees.length,
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(UniqueKey().toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  bool result = await employeeService.deleteEmployee(employeeService.employees[index].id);
                                  if (result) {
                                    AppSnackBar.success("Employee deleted");
                                  } else {
                                    AppSnackBar.success("Couldn't delete employee");
                                  }
                                }
                              },
                              background: Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                alignment: AlignmentDirectional.centerEnd,
                                decoration: BoxDecoration(
                                  color: appTheme.primary.withAlpha(120)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.delete_forever,
                                      size: 28,
                                      color: appTheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 36,
                                  height: 80,
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 28,
                                      color: appTheme.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  employeeService.employees[index].name,
                                  style: TextStyle(
                                    color: appTheme.secondaryText,
                                    fontSize: 16
                                  ),
                                ),
                                subtitle: Text(
                                  employeeService.employees[index].phoneNumber,
                                  style: TextStyle(
                                    color: appTheme.secondaryText,
                                    fontSize: 12
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        bool? result = await showCupertinoModalBottomSheet<bool>(
                                          context: context,
                                          topRadius: const Radius.circular(20),
                                          backgroundColor: appTheme.background,
                                          animationCurve: Curves.fastOutSlowIn,
                                          builder: (context) => SizedBox(
                                            child: EmployeeDetail(employee: employeeService.employees[index],),
                                          )
                                        );
                                        if (result != null && result) {
                                          AppSnackBar.success("Updated successfully");
                                        } else if (result != null && !result) {
                                          AppSnackBar.error("Couldn't update");
                                        }
                                      },
                                      icon: Icon(
                                        Icons.mode_edit_rounded,
                                        size: 24,
                                        color: appTheme.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await launch("tel:${employeeService.employees[index].phoneNumber}");
                                      },
                                      icon: Icon(
                                        Icons.phone,
                                        size: 24,
                                        color: appTheme.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  bool? refresh = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(builder: (_) => WorkingDaysPage(employee: employeeService.employees[index],))
                                  );
                                  if (refresh != null && refresh) {
                                    shouldReload();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ) : SizedBox(
                        height: devHeight(context) * 0.4,
                        width: devWidth(context),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            child: Text(
                              "No Employees to view",
                              style: TextStyle(
                                color: appTheme.secondaryText,
                                fontSize: 16,
                              ),
                            )
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Column(
                  children: [
                    if (employeeService.loading) LinearProgressIndicator(
                      color: appTheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.background,
        child: const Icon(Icons.add, size: 24,),
        onPressed: () async {
          bool? result = await showCupertinoModalBottomSheet<bool>(
            context: context,
            topRadius: const Radius.circular(20),
            backgroundColor: appTheme.background,
            animationCurve: Curves.fastOutSlowIn,
            builder: (context) => const EmployeeDetail()
          );
          if (result != null && result) {
            AppSnackBar.success("New employee added successfully");
          } else if (result != null && !result) {
            AppSnackBar.error("Couldn't add new employee");
          }
        },
      ),
    );
  }
}